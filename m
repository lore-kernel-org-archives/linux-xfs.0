Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F9017F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:46:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95980AC003
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 09:46:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id t7sGLkYek9Mg1hgC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 09:46:46 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 0B212AE5D9
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 16:46:46 +0000 (UTC)
Date: Thu, 19 Mar 2015 12:46:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 09/13] libxfs: remove ASSERT on ftype read from disk
Message-ID: <20150319164643.GD11669@laptop.bfoster>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-10-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1426624395-8258-10-git-send-email-sandeen@redhat.com>
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

On Tue, Mar 17, 2015 at 03:33:11PM -0500, Eric Sandeen wrote:
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
>  include/xfs_da_format.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
> index 89a1a21..695e698 100644
> --- a/include/xfs_da_format.h
> +++ b/include/xfs_da_format.h
> @@ -561,7 +561,7 @@ xfs_dir3_dirent_get_ftype(
>  	if (xfs_sb_version_hasftype(&mp->m_sb)) {
>  		__uint8_t	type = dep->name[dep->namelen];
>  
> -		ASSERT(type < XFS_DIR3_FT_MAX);
> +		//ASSERT(type < XFS_DIR3_FT_MAX);

Just delete it..?

Brian

>  		if (type < XFS_DIR3_FT_MAX)
>  			return type;
>  
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
