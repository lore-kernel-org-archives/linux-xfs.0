Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A777E6;
	Fri, 12 Jul 2024 01:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720746992; cv=none; b=fehuJcvRxLRFd+q0WakzdOWJFeWEQVuw+2ewsMT07DuhewE3NnnVDK9jTrS7jmA3l1w3d+nT6iD2DzdSyFegfuQCrwVjYgbNuo5RuJNd4CoN1aMJiGOyiILBGoJgNwa8PRFc+5+rgcoSHxVT1MVofVxOzwQ5dWwqXY1YqzyxvRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720746992; c=relaxed/simple;
	bh=ByXbfI/FrLOIKII1lwb8zymOdcPzQWc7nSGrvcdTSvI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZDda3mBWEcqicnDbJrZkhlZXOGk9GDxEHCqrny/mgFWomuEpmd4KWCID8kq4AifNu6qD2RbrYBfT5pBK8/RY0DPnTLkWQ6sQWSepiQuIaRpwicbI34WKGlK8bM2T3S6Qxj20RqIi8b1/TCHjjLnpshgtU136qbwncVhp+KoOL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C99EC116B1;
	Fri, 12 Jul 2024 01:16:31 +0000 (UTC)
Date: Thu, 11 Jul 2024 21:17:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix file_path handling in tracepoints
Message-ID: <20240711211754.316de618@gandalf.local.home>
In-Reply-To: <ZpAB2HU8zE41s9j6@infradead.org>
References: <ZpAB2HU8zE41s9j6@infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Jul 2024 09:01:28 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jul 10, 2024 at 10:43:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Since file_path() takes the output buffer as one of its arguments, we
> > might as well have it format directly into the tracepoint's char array
> > instead of wasting stack space.  
> 
> This looks sensible to me, but..
> 
> The nicest way to format the interesting parts of a file path is to
> simply use the magic %pD printk specificer, which removes the entire

Would that even work? Looking at what %pD does in vsnprintf() we have:

static noinline_for_stack
char *file_dentry_name(char *buf, char *end, const struct file *f,
			struct printf_spec spec, const char *fmt)
{
	if (check_pointer(&buf, end, f, spec))
		return buf;

	return dentry_name(buf, end, f->f_path.dentry, spec, fmt);
}

That "f->f_path.dentry" is a dereference of the passed in pointer. If we
did that in the TP_printk(), then it would dereference that file pointer
saved by the trace. This would happen at some time later from when the file
pointer was saved. That is, it will dereference the pointer when the user
reads the trace, not when the trace occurred. This could be seconds,
minutes, hours, days even months later! So %pD would not work there.


> need for an extra buffer.  It would be kinda nice to use that for
> tracing, but I can't see how to accomodate the users of the binary
> trace buffer with that.  Adding Steven and the trace list for
> comments.

With the above said, perhaps you could do something like:


> 
> > -		__array(char, pathname, 256)
> > +		__array(char, pathname, MAXNAMELEN)

		__dynamic_array(char, pathname, snprintf(NULL, 0, "%pD", xf->file) + 1);

// This will allocated the space needed for the string

> >  	),
> >  	TP_fast_assign(
> > -		char		pathname[257];
> >  		char		*path;
> >  
> >  		__entry->ino = file_inode(xf->file)->i_ino;

		sprintf(__get_dynamic_array(pathname), "%pD", xf->file);

// and the above will copy it directly to that location.
// It assumes the value of the first snprintf() will be the same as the second.

> > +		path = file_path(xf->file, __entry->pathname, MAXNAMELEN);
> >  		if (IS_ERR(path))
> > +			strncpy(__entry->pathname, "(unknown)",
> > +					sizeof(__entry->pathname));
> >  	),
> >  	TP_printk("xfino 0x%lx path '%s'",
> >  		  __entry->ino,

		  (char *)__get_dynamic_array(pathname),

// for accessing the string, although yes, __get_str(pathname) would work,
// but that's more by luck than design.


Looking at this file, I noticed that you have some open coded __string_len()
fields. Why not just use that? In fact, I think I even found a bug:

There's a:
		memcpy(__get_str(name), name, name->len);

Where I think it should have been:

		memcpy(__get_str(name), name->name, name->len);

Hmm, I should make sure that __string() and __string_len() are passed in
strings. As this is a common bug.

I can make this a formal patch if you like. Although, I haven't even tried
compile testing it ;-)

-- Steve

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 92ef4cdc486e..bbb7b0a09ffe 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1430,14 +1430,14 @@ TRACE_EVENT(xchk_nlinks_collect_dirent,
 		__field(xfs_ino_t, dir)
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->dir = dp->i_ino;
 		__entry->ino = ino;
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d dir 0x%llx -> ino 0x%llx name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1457,14 +1457,14 @@ TRACE_EVENT(xchk_nlinks_collect_pptr,
 		__field(xfs_ino_t, dir)
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->dir = dp->i_ino;
 		__entry->ino = be64_to_cpu(pptr->p_ino);
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d dir 0x%llx -> ino 0x%llx name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1502,7 +1502,7 @@ TRACE_EVENT(xchk_nlinks_live_update,
 		__field(xfs_ino_t, ino)
 		__field(int, delta)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, namelen)
+		__string_len(name, name, namelen)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
@@ -1511,7 +1511,7 @@ TRACE_EVENT(xchk_nlinks_live_update,
 		__entry->ino = ino;
 		__entry->delta = delta;
 		__entry->namelen = namelen;
-		memcpy(__get_str(name), name, namelen);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d dir 0x%llx ino 0x%llx nlink_delta %d name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1630,14 +1630,14 @@ DECLARE_EVENT_CLASS(xchk_pptr_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 		__field(xfs_ino_t, far_ino)
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name, name->len);
+		__assign_str(name);
 		__entry->far_ino = far_ino;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name '%.*s' far_ino 0x%llx",
@@ -1672,7 +1672,7 @@ DECLARE_EVENT_CLASS(xchk_dirtree_class,
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
@@ -1682,7 +1682,7 @@ DECLARE_EVENT_CLASS(xchk_dirtree_class,
 		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
 		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d path %u child_ino 0x%llx child_gen 0x%x parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1718,7 +1718,7 @@ DECLARE_EVENT_CLASS(xchk_dirpath_class,
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
@@ -1729,7 +1729,7 @@ DECLARE_EVENT_CLASS(xchk_dirpath_class,
 		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
 		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d path %u step %u child_ino 0x%llx child_gen 0x%x parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1863,7 +1863,7 @@ TRACE_EVENT(xchk_dirpath_changed,
 		__field(xfs_ino_t, child_ino)
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, xname->len)
+		__string_len(name, xname->name, xname->len)
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
@@ -1872,7 +1872,7 @@ TRACE_EVENT(xchk_dirpath_changed,
 		__entry->child_ino = ip->i_ino;
 		__entry->parent_ino = dp->i_ino;
 		__entry->namelen = xname->len;
-		memcpy(__get_str(name), xname->name, xname->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d path %u step %u child_ino 0x%llx parent_ino 0x%llx name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -1896,7 +1896,7 @@ TRACE_EVENT(xchk_dirtree_live_update,
 		__field(xfs_ino_t, child_ino)
 		__field(int, delta)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, xname->len)
+		__string_len(name, xname->name, xname->len)
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
@@ -1905,7 +1905,7 @@ TRACE_EVENT(xchk_dirtree_live_update,
 		__entry->child_ino = ip->i_ino;
 		__entry->delta = delta;
 		__entry->namelen = xname->len;
-		memcpy(__get_str(name), xname->name, xname->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d parent_ino 0x%llx child_ino 0x%llx nlink_delta %d name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -2853,7 +2853,7 @@ DECLARE_EVENT_CLASS(xrep_xattr_salvage_class,
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, flags)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, namelen)
+		__string_len(name, name, namelen)
 		__field(unsigned int, valuelen)
 	),
 	TP_fast_assign(
@@ -2861,7 +2861,7 @@ DECLARE_EVENT_CLASS(xrep_xattr_salvage_class,
 		__entry->ino = ip->i_ino;
 		__entry->flags = flags;
 		__entry->namelen = namelen;
-		memcpy(__get_str(name), name, namelen);
+		__assign_str(name);
 		__entry->valuelen = valuelen;
 	),
 	TP_printk("dev %d:%d ino 0x%llx flags %s name '%.*s' valuelen 0x%x",
@@ -2892,7 +2892,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, namelen)
+		__string_len(name, name, namelen)
 	),
 	TP_fast_assign(
 		const struct xfs_parent_rec	*rec = value;
@@ -2902,7 +2902,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
 		__entry->parent_ino = be64_to_cpu(rec->p_ino);
 		__entry->parent_gen = be32_to_cpu(rec->p_gen);
 		__entry->namelen = namelen;
-		memcpy(__get_str(name), name, namelen);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -2956,7 +2956,7 @@ DECLARE_EVENT_CLASS(xrep_xattr_pptr_scan_class,
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
@@ -2964,7 +2964,7 @@ DECLARE_EVENT_CLASS(xrep_xattr_pptr_scan_class,
 		__entry->parent_ino = dp->i_ino;
 		__entry->parent_gen = VFS_IC(dp)->i_generation;
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -3042,7 +3042,7 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, dir_ino)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 		__field(xfs_ino_t, ino)
 		__field(uint8_t, ftype)
 	),
@@ -3050,7 +3050,7 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
 		__entry->dev = dp->i_mount->m_super->s_dev;
 		__entry->dir_ino = dp->i_ino;
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 		__entry->ino = ino;
 		__entry->ftype = name->type;
 	),
@@ -3137,7 +3137,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
@@ -3145,7 +3145,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
 		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
 		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -3175,7 +3175,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, name->len)
+		__string_len(name, name->name, name->len)
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
@@ -3183,7 +3183,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 		__entry->parent_ino = dp->i_ino;
 		__entry->parent_gen = VFS_IC(dp)->i_generation;
 		__entry->namelen = name->len;
-		memcpy(__get_str(name), name->name, name->len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -3237,7 +3237,7 @@ DECLARE_EVENT_CLASS(xrep_dentry_class,
 		__field(bool, positive)
 		__field(unsigned long, parent_ino)
 		__field(unsigned int, namelen)
-		__dynamic_array(char, name, dentry->d_name.len)
+		__string_len(name, dentry->d_name.name, dentry->d_name.len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
@@ -3249,7 +3249,7 @@ DECLARE_EVENT_CLASS(xrep_dentry_class,
 			__entry->parent_ino = -1UL;
 		__entry->ino = d_inode(dentry) ? d_inode(dentry)->i_ino : 0;
 		__entry->namelen = dentry->d_name.len;
-		memcpy(__get_str(name), dentry->d_name.name, dentry->d_name.len);
+		__assign_str(name);
 	),
 	TP_printk("dev %d:%d flags 0x%x positive? %d parent_ino 0x%lx ino 0x%lx name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -3275,13 +3275,14 @@ TRACE_EVENT(xrep_symlink_salvage_target,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, targetlen)
+		__string_len(target, target, targetlen)
 		__dynamic_array(char, target, targetlen + 1)
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->targetlen = targetlen;
-		memcpy(__get_str(target), target, targetlen);
+		__assign_str(target);
 		__get_str(target)[targetlen] = 0;
 	),
 	TP_printk("dev %d:%d ip 0x%llx target '%.*s'",
