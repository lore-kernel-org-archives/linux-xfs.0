Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 252767F51
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 04:41:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13BE78F8068
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 02:41:04 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ZVBWKBCWIoApekhJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Feb 2015 02:41:03 -0800 (PST)
Date: Wed, 25 Feb 2015 11:40:57 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: Fix quota type in quota structures when reusing
	quota file
Message-ID: <20150225104057.GA22736@quack.suse.cz>
References: <1424188630-1111-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424188630-1111-1-git-send-email-jack@suse.cz>
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
To: xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>

  Ping? Can you guys please review / pick-up the fix? Thanks!

								Honza

On Tue 17-02-15 16:57:10, Jan Kara wrote:
> For filesystems without separate project quota inode field in the
> superblock we just reuse project quota file for group quotas (and vice
> versa) if project quota file is allocated and we need group quota file.
> When we reuse the file, quota structures on disk suddenly have wrong
> type stored in d_flags though. Nobody really cares about this (although
> structure type reported to userspace was wrong as well) except
> that after commit 14bf61ffe6ac (quota: Switch ->get_dqblk() and
> ->set_dqblk() to use bytes as space units) assertion in
> xfs_qm_scall_getquota() started to trigger on xfs/106 test (apparently I
> was testing without XFS_DEBUG so I didn't notice when submitting the
> above commit).
> 
> Fix the problem by properly resetting ddq->d_flags when running quotacheck
> for a quota file.
> 
> CC: stable@vger.kernel.org
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_qm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 3e8186279541..dd0dcc7b76cd 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -836,6 +836,11 @@ xfs_qm_reset_dqcounts(
>  		 */
>  		xfs_dqcheck(mp, ddq, id+j, type, XFS_QMOPT_DQREPAIR,
>  			    "xfs_quotacheck");
> +		/*
> +		 * Reset type in case we are reusing group quota file for
> +		 * project quotas or vice versa
> +		 */
> +		ddq->d_flags = type;
>  		ddq->d_bcount = 0;
>  		ddq->d_icount = 0;
>  		ddq->d_rtbcount = 0;
> -- 
> 2.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
