Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F43C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 03:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiCIDyx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiCIDyv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 22:54:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DC415C655
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 19:53:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B415C6182E
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 03:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1755BC340E8;
        Wed,  9 Mar 2022 03:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646798032;
        bh=z8cH+peiKT9RJSShWbZ0lYLGkEX6NVcN196TsXLliEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SnhuoATQgbSghbCCg/+RDQBpQhuRoviUe99DwPjaOsZ+DqHuNzRQNCYT87atYsigr
         T6G9HUXAkMjpKvO6rsoacSf6R9exiO2CPFTLES1XXje1QptOLh4WVMXl04/1XJ1ZQ4
         LNonbsFFysdNyvqXgTrrIjApoU2t+fs1+2mGrOvo50vC70HOPNkfCT0eeDqtj35lvp
         Rxuls9yTQ8ZNxcO2VLeALDh7lQSH+rz4ntqksBzkL17iMu5DJJblKkxF9Yxo+AvAbq
         08TRKLggPwVhOBQj1QK455vG7Sv5Gq5tb/WqUIsihiax3ojmQysXN7EOfWWC1aVVU6
         11f/S0vlUVsmQ==
Date:   Tue, 8 Mar 2022 19:53:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v28 00/15] xfs: Log Attribute Replay
Message-ID: <20220309035351.GA8224@magnolia>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
 <20220301022920.GC117732@magnolia>
 <d93c3a9a-126b-058b-81e2-bdf2e675ad0a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d93c3a9a-126b-058b-81e2-bdf2e675ad0a@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 01:39:36PM -0700, Allison Henderson wrote:
> 
> 
> On 2/28/22 7:29 PM, Darrick J. Wong wrote:
> > On Mon, Feb 28, 2022 at 12:51:32PM -0700, Allison Henderson wrote:
> > > Hi all,
> > > 
> > > This set is a subset of a larger series parent pointers. Delayed attributes allow
> > > attribute operations (set and remove) to be logged and committed in the same
> > > way that other delayed operations do. This allows more complex operations (like
> > > parent pointers) to be broken up into multiple smaller transactions. To do
> > > this, the existing attr operations must be modified to operate as a delayed
> > > operation.  This means that they cannot roll, commit, or finish transactions.
> > > Instead, they return -EAGAIN to allow the calling function to handle the
> > > transaction.  In this series, we focus on only the delayed attribute portion.
> > > We will introduce parent pointers in a later set.
> > > 
> > > The set as a whole is a bit much to digest at once, so I usually send out the
> > > smaller sub series to reduce reviewer burn out.  But the entire extended series
> > > is visible through the included github links.
> > > 
> > > Updates since v27:
> > > xfs: don't commit the first deferred transaction without intents
> > >    Comment update
> > 
> > I applied this to 5.16-rc6, and turned on larp mode.  generic/476
> > tripped over something, and this is what kasan had to say:
> > 
> > [  835.381655] run fstests generic/476 at 2022-02-28 18:22:04
> > [  838.008485] XFS (sdb): Mounting V5 Filesystem
> > [  838.035529] XFS (sdb): Ending clean mount
> > [  838.040528] XFS (sdb): Quotacheck needed: Please wait.
> > [  838.050866] XFS (sdb): Quotacheck: Done.
> > [  838.092369] XFS (sdb): EXPERIMENTAL logged extended attributes feature added. Use at your own risk!
> > [  838.092938] general protection fault, probably for non-canonical address 0xe012f573e6000046: 0000 [#1] PREEMPT SMP KASAN
> > [  838.099085] KASAN: maybe wild-memory-access in range [0x0097cb9f30000230-0x0097cb9f30000237]
> > [  838.101148] CPU: 2 PID: 4403 Comm: fsstress Not tainted 5.17.0-rc5-djwx #rc5 63f7e400b85b2245f2d4d3033e82ec8bc95c49fd
> > [  838.103757] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > [  838.105811] RIP: 0010:xlog_cil_commit+0x2f9/0x2800 [xfs]
> > 
> > 
> > FWIW, gdb says this address is:
> > 
> > 0xffffffffa06e0739 is in xlog_cil_commit (fs/xfs/xfs_log_cil.c:237).
> > 232
> > 233                     /*
> > 234                      * if we have no shadow buffer, or it is too small, we need to
> > 235                      * reallocate it.
> > 236                      */
> > 237                     if (!lip->li_lv_shadow ||
> > 238                         buf_size > lip->li_lv_shadow->lv_size) {
> > 239                             /*
> > 240                              * We free and allocate here as a realloc would copy
> > 241                              * unnecessary data. We don't use kvzalloc() for the
> > 
> > I don't know what this is about, but my guess is that we freed something
> > we weren't supposed to...?
> > 
> > (An overnight fstests run with v27 and larp=0 ran fine, though...)
> > 
> > --D
> 
> Hmm, ok, I will dig into this then.  I dont see anything between v27 and v28
> that would have cause this though, so I'm thinking what ever it is must by
> intermittent.  I'll stick it in a loop and see if I can get a recreate
> today.  Thanks!

I think I've figured out two of the problems here --

The biggest problem is that xfs_attri_init isn't fully initializing the
xattr log item structure, which is why the CIL would crash on my system
when it tried to resize what it thought was the lv_shadow buffer
attached to the log item.  I changed it to kmem_cache_zalloc and the
problems went away; you might want to check if your kernel has some
debugging kconfig feature enabled that auto-zeroes everything.

The other KASAN report has to do with the log iovec code -- it assumes
that any buffer passed in has a size that is congruent with 4(?) bytes.
This isn't necessarily true for the xattr name (and in principle also
the value) buffer that we get from the VFS; if either is (say) 37 bytes
long, you'll get 37 bytes, and KASAN will expect you to stick to that.
I think with the way the slab works this isn't a real memory corruption
vector, but I wouldn't put it past slob or someone to actually pack
things in tightly.

Also, I'm not sure what's going on with the name/value buffers in the
relog function.  I patched it to try to track the buffer references, but
maybe you have a better idea for why we allocate new name/value buffers
for a log item relog?  I wasn't sure where those new buffers ever got
freed, so I <cough> ran it over with a backhoe, and it shows. :/

The following shabby patch helps us to pass generic/475 and generic/624
in LARP mode, though I have no idea if it's correct.  You might want to
pay attention to the "XXX:" comments I added, since that's where I got
stuck.

--D

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 41404d35c76c..7a00a43610d5 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -678,6 +678,9 @@ xfs_attr_set(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
+	void			*fakename = NULL, *fakeval = NULL;
+	const void		*oldname = args->name;
+	void			*oldval = args->value;
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
@@ -692,6 +695,34 @@ xfs_attr_set(
 	if (error)
 		return error;
 
+	/*
+	 * XXX: the log iovec code requires that every buffer it's given has a
+	 * size that's an even multiple of four.  If this isn't the case, create
+	 * a shadow buffers so that we don't read past the end of the name and
+	 * value buffers and trip KASAN.
+	 */
+	if (xfs_has_larp(mp) && (args->namelen & 3)) {
+		fakename = kzalloc(roundup(args->namelen, 4),
+				GFP_KERNEL | GFP_NOFS);
+		if (!fakename)
+			return -ENOMEM;
+		memcpy(fakename, args->name, args->namelen);
+		args->name = fakename;
+	}
+
+	if (xfs_has_larp(mp) && (args->valuelen & 3)) {
+		fakeval = kzalloc(roundup(args->valuelen, 4),
+				GFP_KERNEL | GFP_NOFS);
+		if (!fakeval) {
+			if (fakename)
+				kvfree(fakename);
+			return -ENOMEM;
+		}
+		memcpy(fakeval, args->value, args->valuelen);
+		args->value = fakeval;
+	}
+
+	//trace_printk("start name 0x%px len 0x%x val 0x%px len 0x%x", args->name, args->namelen, args->value, args->valuelen);
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
@@ -797,6 +828,13 @@ xfs_attr_set(
 drop_incompat:
 	if (delayed)
 		xlog_drop_incompat_feat(mp->m_log);
+	//trace_printk("end name 0x%px val 0x%px", args->name, args->value);
+	if (fakename)
+		kvfree(fakename);
+	if (fakeval)
+		kvfree(fakeval);
+	args->value = oldval;
+	args->name = oldname;
 	return error;
 
 out_trans_cancel:
@@ -852,6 +890,7 @@ xfs_attr_item_init(
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
+	//trace_printk("name 0x%px val 0x%px", args->name, args->value);
 	*attr = new;
 	return 0;
 }
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 5aa7a764d95e..8e365583e265 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -43,6 +43,12 @@ STATIC void
 xfs_attri_item_free(
 	struct xfs_attri_log_item	*attrip)
 {
+	if (attrip->attri_own_buffers) {
+		kvfree(attrip->attri_name);
+		if (attrip->attri_value)
+			kvfree(attrip->attri_value);
+		attrip->attri_own_buffers = false;
+	}
 	kmem_free(attrip->attri_item.li_lv_shadow);
 	kmem_free(attrip);
 }
@@ -114,6 +120,8 @@ xfs_attri_item_format(
 	if (attrip->attri_value_len > 0)
 		attrip->attri_format.alfi_size++;
 
+	//trace_printk("fmt 0x%px name 0x%px val 0x%px", &attrip->attri_format, attrip->attri_name, attrip->attri_value);
+
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
@@ -158,19 +166,39 @@ xfs_attri_item_release(
 STATIC struct xfs_attri_log_item *
 xfs_attri_init(
 	struct xfs_mount		*mp,
-	int				buffer_size)
+	unsigned int			namelen,
+	unsigned int			valuelen)
 
 {
 	struct xfs_attri_log_item	*attrip;
+	unsigned int			buffer_size;
 
-	if (buffer_size) {
-		attrip = kmem_alloc(sizeof(struct xfs_attri_log_item) +
-				    buffer_size, KM_NOFS);
-		if (attrip == NULL)
+	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_NOFS | __GFP_NOFAIL);
+
+	if (valuelen)
+		ASSERT(namelen != 0);
+
+	if (namelen) {
+		buffer_size = roundup(namelen, 4);
+		attrip->attri_name = kzalloc(buffer_size,
+				GFP_KERNEL | GFP_NOFS | __GFP_RETRY_MAYFAIL);
+		if (!attrip->attri_name) {
+			kmem_cache_free(xfs_attri_cache, attrip);
+			return NULL;
+		}
+		attrip->attri_own_buffers = true;
+	}
+
+	if (valuelen) {
+		buffer_size = roundup(valuelen, 4);
+		attrip->attri_value = kzalloc(buffer_size,
+				GFP_KERNEL | GFP_NOFS |__GFP_RETRY_MAYFAIL);
+		if (!attrip->attri_value) {
+			if (attrip->attri_name)
+				kvfree(attrip->attri_name);
+			kmem_cache_free(xfs_attri_cache, attrip);
 			return NULL;
-	} else {
-		attrip = kmem_cache_alloc(xfs_attri_cache,
-					  GFP_NOFS | __GFP_NOFAIL);
+		}
 	}
 
 	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
@@ -343,6 +371,8 @@ xfs_attr_log_item(
 	attrip->attri_value = attr->xattri_da_args->value;
 	attrip->attri_name_len = attr->xattri_da_args->namelen;
 	attrip->attri_value_len = attr->xattri_da_args->valuelen;
+
+	//trace_printk("lip 0x%px fmt 0x%px name 0x%px val 0x%px", &attrip->attri_item, &attrip->attri_format, attrip->attri_name, attrip->attri_value);
 }
 
 /* Get an ATTRI. */
@@ -362,7 +392,7 @@ xfs_attr_create_intent(
 	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
 		return NULL;
 
-	attrip = xfs_attri_init(mp, 0);
+	attrip = xfs_attri_init(mp, 0, 0);
 	if (attrip == NULL)
 		return NULL;
 
@@ -434,6 +464,13 @@ xfs_attri_item_committed(
 	 * committed so these fields are no longer accessed. Clear them out of
 	 * caution since we're about to free the xfs_attr_item.
 	 */
+	//trace_printk("fmt 0x%px name 0x%px val 0x%px", &attrip->attri_format, attrip->attri_name, attrip->attri_value);
+	if (attrip->attri_own_buffers) {
+		kvfree(attrip->attri_name);
+		if (attrip->attri_value)
+			kvfree(attrip->attri_value);
+		attrip->attri_own_buffers = false;
+	}
 	attrip->attri_name = NULL;
 	attrip->attri_value = NULL;
 
@@ -582,17 +619,15 @@ xfs_attri_item_relog(
 	struct xfs_attri_log_item	*new_attrip;
 	struct xfs_attri_log_format	*new_attrp;
 	struct xfs_attri_log_format	*old_attrp;
-	int				buffer_size;
 
 	old_attrip = ATTRI_ITEM(intent);
 	old_attrp = &old_attrip->attri_format;
-	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	attrdp = xfs_trans_get_attrd(tp, old_attrip);
 	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
 
-	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
+	new_attrip = xfs_attri_init(tp->t_mountp, 0, 0);
 	new_attrp = &new_attrip->attri_format;
 
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
@@ -602,19 +637,30 @@ xfs_attri_item_relog(
 	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
 
 	new_attrip->attri_name_len = old_attrip->attri_name_len;
-	new_attrip->attri_name = ((char *)new_attrip) +
-				 sizeof(struct xfs_attri_log_item);
-	memcpy(new_attrip->attri_name, old_attrip->attri_name,
-		new_attrip->attri_name_len);
+	new_attrip->attri_name = old_attrip->attri_name;
 
 	new_attrip->attri_value_len = old_attrip->attri_value_len;
-	if (new_attrip->attri_value_len > 0) {
-		new_attrip->attri_value = new_attrip->attri_name +
-					  new_attrip->attri_name_len;
+	if (new_attrip->attri_value_len > 0)
+		new_attrip->attri_value = old_attrip->attri_value;
 
-		memcpy(new_attrip->attri_value, old_attrip->attri_value,
-		       new_attrip->attri_value_len);
-	}
+	/*
+	 * XXX Err... so who owns the name/value buffer references, anyway?
+	 * Is it safe to drop them during ->iop_commmitted?  Do we ever want to
+	 * relog a log item after _committed, in which case we no longer have
+	 * the buffer attached to the new log item.
+	 *
+	 * If we don't need the name and value after the first commit of the
+	 * attrip then it's ok to drop the references in _committed... but that
+	 * doesn't make sense, since most of the tx rolling is to prepare the
+	 * xattr structure to receive the name and value.
+	 *
+	 * OTOH -- _committed is called to write things into the AIL.  By that
+	 * time we are well past formatting things into buffers, right?
+	 *
+	 * <zzzz tired, brain dead>
+	 */
+	new_attrip->attri_own_buffers = old_attrip->attri_own_buffers;
+	old_attrip->attri_own_buffers = false;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
 	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
@@ -633,10 +679,7 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_mount                *mp = log->l_mp;
 	struct xfs_attri_log_item       *attrip;
 	struct xfs_attri_log_format     *attri_formatp;
-	char				*name = NULL;
-	char				*value = NULL;
 	int				region = 0;
-	int				buffer_size;
 
 	attri_formatp = item->ri_buf[region].i_addr;
 
@@ -646,11 +689,9 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	buffer_size = attri_formatp->alfi_name_len +
-		      attri_formatp->alfi_value_len;
-
 	/* memory alloc failure will cause replay to abort */
-	attrip = xfs_attri_init(mp, buffer_size);
+	attrip = xfs_attri_init(mp, attri_formatp->alfi_name_len,
+			attri_formatp->alfi_value_len);
 	if (attrip == NULL)
 		return -ENOMEM;
 
@@ -662,11 +703,10 @@ xlog_recover_attri_commit_pass2(
 	attrip->attri_name_len = attri_formatp->alfi_name_len;
 	attrip->attri_value_len = attri_formatp->alfi_value_len;
 	region++;
-	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
-	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
-	attrip->attri_name = name;
+	memcpy(attrip->attri_name, item->ri_buf[region].i_addr,
+			attrip->attri_name_len);
 
-	if (!xfs_attr_namecheck(name, attrip->attri_name_len)) {
+	if (!xfs_attr_namecheck(attrip->attri_name, attrip->attri_name_len)) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
 		error = -EFSCORRUPTED;
 		goto out;
@@ -674,11 +714,8 @@ xlog_recover_attri_commit_pass2(
 
 	if (attrip->attri_value_len > 0) {
 		region++;
-		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
-				attrip->attri_name_len;
-		memcpy(value, item->ri_buf[region].i_addr,
+		memcpy(attrip->attri_value, item->ri_buf[region].i_addr,
 				attrip->attri_value_len);
-		attrip->attri_value = value;
 	}
 
 	/*
@@ -706,7 +743,7 @@ xfs_trans_get_attrd(struct xfs_trans		*tp,
 
 	ASSERT(tp != NULL);
 
-	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
+	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
 
 	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
 			  &xfs_attrd_item_ops);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index c3b779f82adb..2b690b1d3228 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -31,6 +31,9 @@ struct xfs_attri_log_item {
 	void				*attri_name;
 	void				*attri_value;
 	struct xfs_attri_log_format	attri_format;
+
+	/* Do we actually own attri_name/value? */
+	bool				attri_own_buffers;
 };
 
 /*
