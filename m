Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1ECEF29E08
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 10:05:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 14E2A8F807A
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 08:05:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id neFF3yiY2YFrm74b for
	<xfs@oss.sgi.com>; Tue, 17 Jun 2014 08:05:13 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5HF5CN2021954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 11:05:12 -0400
Date: Tue, 17 Jun 2014 11:05:11 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] libxfs: fix crc field handling in xfs_sb_to/from_disk
Message-ID: <20140617150510.GD8905@bfoster.bfoster>
References: <1402960461-27881-1-git-send-email-sandeen@redhat.com>
	<1402960461-27881-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1402960461-27881-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 16, 2014 at 06:14:21PM -0500, Eric Sandeen wrote:
> If we xfs_mdrestore an image from a non-crc filesystem, lo
> and behold the restored image has gained a CRC:
> 
> # db/xfs_metadump.sh -o /dev/sdc1 - | xfs_mdrestore - test.img
> # xfs_db -c "sb 0" -c "p crc" /dev/sdc1
> crc = 0 (correct)
> # xfs_db -c "sb 0" -c "p crc" test.img
> crc = 0xb6f8d6a0 (correct)
> 
> This is because xfs_sb_from_disk doesn't fill in sb_crc,
> but xfs_sb_to_disk(XFS_SB_ALL_BITS) does write the in-memory
> CRC to disk - so we get uninitialized memory on disk.
> 
> Fix this by always initializing sb_crc to 0 when we read
> the superblock, and masking out the CRC bit from ALL_BITS
> when we write it.
> 
> This same fix has already been sent for kernelspace.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/xfs_sb.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index 7ee4612..ea89367 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -408,6 +408,8 @@ xfs_sb_from_disk(
>  	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
>  	to->sb_features_log_incompat =
>  				be32_to_cpu(from->sb_features_log_incompat);
> +	/* crc is only used on disk, not in memory; just init to 0 here. */
> +	to->sb_crc = 0;
>  	to->sb_pad = 0;
>  	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
>  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
> @@ -485,6 +487,9 @@ xfs_sb_to_disk(
>  	if (!fields)
>  		return;
>  
> +	/* We should never write the crc here, it's updated in the IO path */
> +	fields &= ~XFS_SB_CRC;
> +
>  	xfs_sb_quota_to_disk(to, from, &fields);
>  	while (fields) {
>  		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
