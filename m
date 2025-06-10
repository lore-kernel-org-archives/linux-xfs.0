Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB8725FA05
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 19:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582545; cv=none; b=u8DL69CqmMUCgQkytlEQ6E1x2KUSswwH5DHR3/VTKCUn7mP7GbPqXijSEjWHbz1zMsac2xvSPJR8UZZOmEOLS01YCPPexeQ3qyz65w/Um+18eqIJFcldtrjSUmBmm5Be3qrYgxywBFTGFoRlKK4BO0RmdnVMGlNHDRv8wbhdFe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582545; c=relaxed/simple;
	bh=P2c9QZ2QMTGEXsAYlVLRWVJAcrcG9fdTERiO9UVJyEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jODEProkZBzieitJy/b3GwtyV7T/+RYW6UmmrkKwAEl1o0AUB8VxNNHfcE8HBFqsmFnjmsfXBRi2nbcFC8pEaBIupTpvkM/8ek64CrdmQ0sR2xI16ikrU2M54B7NnWCVlll7r2EfWqJAHH40f8yN3OMZqpBR3hij4JGWxWo3U9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D/d7I17H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/d7I17H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749582542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EDLdDx52Tt0xGB18gauxVIElFFaGCMshYvQZPbVpNqI=;
	b=D/d7I17HPXkkntsvBMw4KhWoFesp8neVZ/7fRKBGwVacqcAfM9F4AOg9aj7YMeu7kD7rIp
	7FdncO3LnIaoI3oWWIrSQ33oZY5NhJa1oPwTU2mo8Y6qXOy/OZmCijw5seb8ZKgT9TDuOq
	7X3hWQAyvB3tD6euGPt4a6Z8jwQyZIM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-487-Uvd6UUwyNea9QZ_I4i4zfg-1; Tue,
 10 Jun 2025 15:09:00 -0400
X-MC-Unique: Uvd6UUwyNea9QZ_I4i4zfg-1
X-Mimecast-MFC-AGG-ID: Uvd6UUwyNea9QZ_I4i4zfg_1749582539
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90FE3195608A;
	Tue, 10 Jun 2025 19:08:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.100])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D94519560AF;
	Tue, 10 Jun 2025 19:08:56 +0000 (UTC)
Date: Tue, 10 Jun 2025 15:12:31 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC 7/7] xfs: error tag to force zeroing on debug kernels
Message-ID: <aEiDn1WDcv8wQmLS@bfoster>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-8-bfoster@redhat.com>
 <aEe1oR3qRXz-QB67@infradead.org>
 <aEgkhYne8EenhJfI@bfoster>
 <aEgzdZKtL2Sp5RRa@infradead.org>
 <aEg_LH2BelAnY7It@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEg_LH2BelAnY7It@bfoster>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Jun 10, 2025 at 10:20:28AM -0400, Brian Foster wrote:
> On Tue, Jun 10, 2025 at 06:30:29AM -0700, Christoph Hellwig wrote:
> > On Tue, Jun 10, 2025 at 08:26:45AM -0400, Brian Foster wrote:
> > > Well that is kind of the question.. ;) My preference was to either add
> > > something to fstests to enable select errortags by default on every
> > > mount (or do the same in-kernel via XFS_DEBUG[_ERRTAGS] or some such)
> > > over just creating a one-off test that runs fsx or whatever with this
> > > error tag turned on. [1].
> > > 
> > > That said, I wouldn't be opposed to just doing both if folks prefer
> > > that. It just bugs me to add yet another test that only runs a specific
> > > fsx test when we get much more coverage by running the full suite of
> > > tests. IOW, whenever somebody is testing a kernel that would actually
> > > run a custom test (XFS_DEBUG plus specific errortag support), we could
> > > in theory be running the whole suite with the same errortag turned on
> > > (albeit perhaps at a lesser frequency than a custom test would use). So
> > > from that perspective I'm not sure it makes a whole lot of sense to do
> > > both.
> > > 
> > > So any thoughts from anyone on a custom test vs. enabling errortag
> > > defaults (via fstests or kernel) vs. some combination of both?
> > 
> > I definitively like a targeted test to exercise it.  If you want
> > additional knows to turn on error tags that's probably fine if it
> > works out.  I'm worried about adding more flags to xfstests because
> > it makes it really hard to figure out what runs are need for good
> > test coverage.
> > 
> > 
> 
> Yeah, an fstests variable would add yet another configuration to test,
> which maybe defeats the point. But we could still turn on certain tags
> by default in the kernel. For example, see the couple of open coded
> get_random_u32_below() callsites in XFS where we already effectively do
> this for XFS_DEBUG, they just aren't implemented as proper errortags.
> 
> I think the main thing that would need to change is to not xfs_warn() on
> those knobs when they are enabled by default. I think there are a few
> different ways that could possibly be done, ideally so we go back to
> default/warn behavior when userspace makes an explicit errortag change,
> but I'd have to play around with it a little bit. Hm?
> 
> Anyways, given the fstests config matrix concern I'm inclined to at
> least give something like that a try first and then fall back to a
> custom test if that fails or is objectionable for some other reason..
> 
> Brian
> 
> 

Here's a prototype for 1. an errtag quiet mode and 2. on-by-default
tags. The alternative to a per-mount flag would be to hack a new struct
into m_errortag that holds the current randfactor as well as a per-tag
quiet flag, though I'm not sure how much people care about that. I
didn't really plan on exposing this to userspace or anything for per-tag
support, but this does mean all tags would start to warn once userspace
changes any tag. I suppose that could become noisy if some day we end up
with a bunch more default enabled tags. *shrug* I could go either way.

Otherwise I think this would allow conversion of the two open coded
get_random_u32_below() cases and the new force zero tag into
on-by-default errortags. Any thoughts?

--- 8< ---

 diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index dbd87e137694..54b38143a7a6 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -69,6 +69,7 @@ static unsigned int xfs_errortag_random_default[] = {
 struct xfs_errortag_attr {
 	struct attribute	attr;
 	unsigned int		tag;
+	bool			enable_default;
 };
 
 static inline struct xfs_errortag_attr *
@@ -129,12 +130,15 @@ static const struct sysfs_ops xfs_errortag_sysfs_ops = {
 	.store = xfs_errortag_attr_store,
 };
 
-#define XFS_ERRORTAG_ATTR_RW(_name, _tag) \
+#define __XFS_ERRORTAG_ATTR_RW(_name, _tag, enable) \
 static struct xfs_errortag_attr xfs_errortag_attr_##_name = {		\
 	.attr = {.name = __stringify(_name),				\
 		 .mode = VERIFY_OCTAL_PERMISSIONS(S_IWUSR | S_IRUGO) },	\
 	.tag	= (_tag),						\
+	.enable_default = enable,					\
 }
+#define XFS_ERRORTAG_ATTR_RW(_name, _tag) \
+	__XFS_ERRORTAG_ATTR_RW(_name, _tag, false)
 
 #define XFS_ERRORTAG_ATTR_LIST(_name) &xfs_errortag_attr_##_name.attr
 
@@ -240,6 +244,25 @@ static const struct kobj_type xfs_errortag_ktype = {
 	.default_groups = xfs_errortag_groups,
 };
 
+static void
+xfs_errortag_init_enable_defaults(
+	struct xfs_mount	*mp)
+{
+	int i;
+
+	for (i = 0; xfs_errortag_attrs[i]; i++) {
+		struct xfs_errortag_attr *xfs_attr =
+				to_attr(xfs_errortag_attrs[i]);
+
+		if (!xfs_attr->enable_default)
+			continue;
+
+		xfs_set_quiet_errtag(mp);
+		mp->m_errortag[xfs_attr->tag] =
+			xfs_errortag_random_default[xfs_attr->tag];
+	}
+}
+
 int
 xfs_errortag_init(
 	struct xfs_mount	*mp)
@@ -251,6 +274,8 @@ xfs_errortag_init(
 	if (!mp->m_errortag)
 		return -ENOMEM;
 
+	xfs_errortag_init_enable_defaults(mp);
+
 	ret = xfs_sysfs_init(&mp->m_errortag_kobj, &xfs_errortag_ktype,
 				&mp->m_kobj, "errortag");
 	if (ret)
@@ -320,9 +345,11 @@ xfs_errortag_test(
 	if (!randfactor || get_random_u32_below(randfactor))
 		return false;
 
-	xfs_warn_ratelimited(mp,
+	if (!xfs_is_quiet_errtag(mp)) {
+		xfs_warn_ratelimited(mp,
 "Injecting error (%s) at file %s, line %d, on filesystem \"%s\"",
 			expression, file, line, mp->m_super->s_id);
+	}
 	return true;
 }
 
@@ -346,6 +373,7 @@ xfs_errortag_set(
 	if (!xfs_errortag_valid(error_tag))
 		return -EINVAL;
 
+	xfs_clear_quiet_errtag(mp);
 	mp->m_errortag[error_tag] = tag_value;
 	return 0;
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d85084f9f317..44b02728056f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -558,6 +558,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
  */
 #define XFS_OPSTATE_BLOCKGC_ENABLED	6
 
+/* Debug kernel skips warning on errtag event triggers */
+#define XFS_OPSTATE_QUIET_ERRTAG	7
 /* Kernel has logged a warning about shrink being used on this fs. */
 #define XFS_OPSTATE_WARNED_SHRINK	9
 /* Kernel has logged a warning about logged xattr updates being used. */
@@ -600,6 +602,7 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(readonly, READONLY)
 __XFS_IS_OPSTATE(inodegc_enabled, INODEGC_ENABLED)
 __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
+__XFS_IS_OPSTATE(quiet_errtag, QUIET_ERRTAG)
 #ifdef CONFIG_XFS_QUOTA
 __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 __XFS_IS_OPSTATE(resuming_quotaon, RESUMING_QUOTAON)

