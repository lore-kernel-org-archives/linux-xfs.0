Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B4BF7F56
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 07:07:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDFB1304032
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:07:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lzlG4kWYwnowxDCa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 05:07:45 -0700 (PDT)
Date: Tue, 24 Mar 2015 08:07:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: PATCH 09/13 V2] libxfs: remove ASSERT on ftype read from disk
Message-ID: <20150324120743.GC21657@bfoster.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-10-git-send-email-sandeen@redhat.com>
	<551073F9.6060908@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <551073F9.6060908@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Mon, Mar 23, 2015 at 03:13:45PM -0500, Eric Sandeen wrote:
> This one is already fixed in the kernel, with
> 	fb04013 xfs: don't ASSERT on corrupt ftype
> but that kernel<->userspace merge is still pending.
> 
> In the meantime, just fix it as a one-off here, because ASSERTing
> on bad on-disk values when running xfs_repair is a very unfriendly
> thing to do.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> Remove it, don't cplusplus-comment it out!  o_O
> 
> diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
> index 89a1a21..11f1420 100644
> --- a/include/xfs_da_format.h
> +++ b/include/xfs_da_format.h
> @@ -561,7 +561,6 @@ xfs_dir3_dirent_get_ftype(
>  	if (xfs_sb_version_hasftype(&mp->m_sb)) {
>  		__uint8_t	type = dep->name[dep->namelen];
>  
> -		ASSERT(type < XFS_DIR3_FT_MAX);
>  		if (type < XFS_DIR3_FT_MAX)
>  			return type;
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
