Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8DA0D7F3F
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2014 08:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E913304043
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2014 06:20:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hAkSMvGERCiVn9kv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 23 Jul 2014 06:20:33 -0700 (PDT)
Date: Wed, 23 Jul 2014 09:20:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: avoid false quotacheck after unclean shutdown
Message-ID: <20140723132022.GA56078@bfoster.bfoster>
References: <53CE6415.8080607@excellency.fr>
 <53CE9AF6.3090401@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53CE9AF6.3090401@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: cbay@excellency.fr, xfs@oss.sgi.com

On Tue, Jul 22, 2014 at 12:10:14PM -0500, Eric Sandeen wrote:
> The commit
> 
> 83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
> 
> added a new function xfs_sb_quota_from_disk() which swaps
> on-disk XFS_OQUOTA_* flags for in-core XFS_GQUOTA_* and XFS_PQUOTA_*
> flags after the superblock is read.
> 
> However, if log recovery is required, the superblock is read again,
> and the modified in-core flags are re-read from disk, so we have
> XFS_OQUOTA_* flags in memory again.  This causes the 
> XFS_QM_NEED_QUOTACHECK() test to be true, because the XFS_OQUOTA_CHKD
> is still set, and not XFS_GQUOTA_CHKD or XFS_PQUOTA_CHKD.
> 
> The simple one-line fix is to call xfs_sb_quota_from_disk after
> we re-read the superblock during log recovery.
> 

First off, this looks reasonable to me given the current code.

> Reported-by: Cyril B. <cbay@excellency.fr>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Quick-tested only; it seems to resolve Cyril's testcase, but I've
> not done an xfstests run yet as this is somewhat of an RFC:
> 
> It feels like there may be a better/more systemic fix here, though.
> We can't call xfs_sb_quota_from_disk it from xfs_sb_from_disk(),
> because the sb read verifier wants to know what was really on disk,
> not what was fixed up after the fact.
> 

I was wondering why this is the case because the verifier runs in the
I/O path, so it would hit before we actually return with the buffer in
hand in the mount codepath. Looking a bit further, I see that we call
xfs_sb_from_disk() from within the verifier (xfs_sb_verify()) and
apparently some flag validation is done on the result of that. So I
suspect that's what you mean here and probably why
xfs_sb_quota_from_disk() is outside of xfs_sb_from_disk().

FWIW, xfs_sb_quota_to_disk() is called within xfs_sb_to_disk(). IMO, the
more clear thing to do is make xfs_sb_to_disk() and xfs_sb_from_disk()
consistent in behavior and let the special verifier case deal with the
quirk. In other words, rename it to something like
__xfs_sb_from_disk(..., bool convert_flags) and conditionally call
xfs_sb_quota_from_disk(). Let the verifier call that variant directly
with false and then #define xfs_sb_from_disk to the true variant. Just
my .02. ;)

Brian

> We could add an "xlate_quota" arg to xfs_sb_from_disk(), but
> that feels a little odd; the function today quite clearly only
> does endian conversions, not other more detailed translations.
> 
> But if something like that is preferred, I can send a patch V2.
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index bce53ac..0a29de7 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4429,6 +4429,7 @@ xlog_do_recover(
>  	/* Convert superblock from on-disk format */
>  	sbp = &log->l_mp->m_sb;
>  	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
> +	xfs_sb_quota_from_disk(sbp);
>  	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
>  	ASSERT(xfs_sb_good_version(sbp));
>  	xfs_buf_relse(bp);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
