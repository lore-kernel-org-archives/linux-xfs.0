Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313B3C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 19:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E29DC208E4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 19:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgINTtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 15:49:00 -0400
Received: from sandeen.net ([63.231.237.45]:51186 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgINTtA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Sep 2020 15:49:00 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 897FE2AEA;
        Mon, 14 Sep 2020 14:48:16 -0500 (CDT)
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
References: <20200911164311.GU7955@magnolia>
 <20200914072909.GC29046@infradead.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3] xfs: deprecate the V4 format
Message-ID: <e30d7d5e-ceec-f378-a6f9-e4a2bb3b89d7@sandeen.net>
Date:   Mon, 14 Sep 2020 14:48:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200914072909.GC29046@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/14/20 2:29 AM, Christoph Hellwig wrote:
> On Fri, Sep 11, 2020 at 09:43:11AM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> The V4 filesystem format contains known weaknesses in the on-disk format
>> that make metadata verification diffiult.  In addition, the format will
>> does not support dates past 2038 and will not be upgraded to do so.
>> Therefore, we should start the process of retiring the old format to
>> close off attack surfaces and to encourage users to migrate onto V5.
>>
>> Therefore, make XFS V4 support a configurable option.  For the first
>> period it will be default Y in case some distributors want to withdraw
>> support early; for the second period it will be default N so that anyone
>> who wishes to continue support can do so; and after that, support will
>> be removed from the kernel.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>> v3: be a little more helpful about old xfsprogs and warn more loudly
>> about deprecation
>> v2: define what is a V4 filesystem, update the administrator guide
> 
> Whie this patch itself looks good, I think the ifdef as is is rather
> silly as it just prevents mounting v4 file systems without reaping any
> benefits from that.
> 
> So at very least we should add a little helper like this:
> 
> static inline bool xfs_sb_is_v4(truct xfs_sb *sbp)
> {
> 	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
> 		return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
> 	return false;
> }
> 
> and use it in all the feature test macros to let the compile eliminate
> all the dead code.
> 

Makes sense, I think - something like this?

xfs: short-circuit version tests if V4 is disabled at compile time

Replace open-coded checks for == XFS_SB_VERSION_[45] with helpers
which can be compiled away if CONFIG_XFS_SUPPORT_V4 is disabled.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

NB: this is compile-tested only

Honestly I'd like to replace lots of the has_crc() checks with is_v5()
as well, unless the test is specifically related to CRC use. *shrug*


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 31b7ece985bb..18b187e38017 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -283,6 +283,23 @@ typedef struct xfs_dsb {
 /*
  * The first XFS version we support is a v4 superblock with V2 directories.
  */
+
+static inline bool xfs_sb_version_is_v4(struct xfs_sb *sbp)
+{
+	if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
+		return false;
+
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4;
+}
+
+static inline bool xfs_sb_version_is_v5(struct xfs_sb *sbp)
+{
+	if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
+		return true;
+
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+}
+
 static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
 {
 	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
@@ -301,9 +318,9 @@ static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_good_version(struct xfs_sb *sbp)
 {
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+	if (xfs_sb_version_is_v5(sbp))
 		return true;
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+	if (xfs_sb_version_is_v4(sbp))
 		return xfs_sb_good_v4_features(sbp);
 	return false;
 }
@@ -344,7 +361,7 @@ static inline void xfs_sb_version_addquota(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasalign(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	return (xfs_sb_version_is_v5(sbp) ||
 		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
 }
 
@@ -355,7 +372,7 @@ static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	return xfs_sb_version_is_v5(sbp) ||
 	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
@@ -371,7 +388,7 @@ static inline bool xfs_sb_version_hasasciici(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	return xfs_sb_version_is_v5(sbp) ||
 	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
@@ -380,14 +397,14 @@ static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
  */
 static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	return (xfs_sb_version_is_v5(sbp)) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
 		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
 }
 
 static inline bool xfs_sb_version_hasattr2(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	return (xfs_sb_version_is_v5(sbp)) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
 		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
 }
@@ -407,7 +424,7 @@ static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	return (xfs_sb_version_is_v5(sbp)) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
 		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
 }
@@ -494,7 +511,7 @@ xfs_sb_has_incompat_log_feature(
  */
 static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+	return xfs_sb_version_is_v5(sbp);
 }
 
 /*
@@ -503,7 +520,7 @@ static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
  */
 static inline bool xfs_sb_version_has_v3inode(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+	return xfs_sb_version_is_v5(sbp);
 }
 
 static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
@@ -516,12 +533,12 @@ static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
 
 static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
+	return xfs_sb_version_is_v5(sbp);
 }
 
 static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	return (xfs_sb_version_is_v5(sbp) &&
 		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
 	       (xfs_sb_version_hasmorebits(sbp) &&
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
@@ -529,13 +546,13 @@ static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+	return (xfs_sb_version_is_v5(sbp)) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
 }
 
 static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	return xfs_sb_version_is_v5(sbp) &&
 		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
 }
 
@@ -547,19 +564,19 @@ static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
  */
 static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+	return (xfs_sb_version_is_v5(sbp)) &&
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
 }
 
 static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+	return (xfs_sb_version_is_v5(sbp)) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
 static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	return xfs_sb_version_is_v5(sbp) &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ae9aaf1f34bf..fcd1e674be73 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -97,7 +97,7 @@ xfs_validate_sb_read(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_version_is_v5(sbp))
 		return 0;
 
 	/*
@@ -164,7 +164,7 @@ xfs_validate_sb_write(
 		return -EFSCORRUPTED;
 	}
 
-	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
+	if (!xfs_sb_version_is_v5(sbp))
 		return 0;
 
 	/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e2ec91b2d0f4..503fc6baabaa 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3420,7 +3420,7 @@ xlog_recover(
 		 * (e.g. unsupported transactions, then simply reject the
 		 * attempt at recovery before touching anything.
 		 */
-		if (XFS_SB_VERSION_NUM(&log->l_mp->m_sb) == XFS_SB_VERSION_5 &&
+		if (xfs_sb_version_is_v5(&log->l_mp->m_sb) &&
 		    xfs_sb_has_incompat_log_feature(&log->l_mp->m_sb,
 					XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN)) {
 			xfs_warn(log->l_mp,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 501b9e14ce38..fc44d9891f79 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1504,7 +1504,7 @@ xfs_fc_fill_super(
 	set_posix_acl_flag(sb);
 
 	/* version 5 superblocks support inode version counters. */
-	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+	if (xfs_sb_version_is_v5(&mp->m_sb))
 		sb->s_flags |= SB_I_VERSION;
 
 	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
@@ -1622,7 +1622,7 @@ xfs_remount_rw(
 		return -EINVAL;
 	}
 
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	if (xfs_sb_version_is_v5(&mp->m_sb) &&
 	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
 		xfs_warn(mp,
 	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
@@ -1735,7 +1735,7 @@ xfs_fc_reconfigure(
 	int			error;
 
 	/* version 5 superblocks always support version counters. */
-	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+	if (xfs_sb_version_is_v5(&mp->m_sb))
 		fc->sb_flags |= SB_I_VERSION;
 
 	error = xfs_fc_validate_params(new_mp);

