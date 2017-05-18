Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19594 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932300AbdERR1E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 13:27:04 -0400
Date: Thu, 18 May 2017 10:27:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: v4.12-rc1 does not compile: xfs_file_iomap_begin/end undefined
 reference
Message-ID: <20170518172701.GB4519@birch.djwong.org>
References: <20170518191605.33635584@saldaea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518191605.33635584@saldaea>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Julian Wollrath <jwollrath@web.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 18, 2017 at 07:16:05PM +0200, Julian Wollrath wrote:
> Hi,
> 
> v4.12-rc1 does not compile with the attached config. I get the
> following:
> fs/built-in.o: In function `xfs_file_iomap_end':
> xfs_iomap.c:(.text+0xb7f75): undefined reference to `put_dax'
> fs/built-in.o: In function `xfs_file_iomap_begin':
> xfs_iomap.c:(.text+0xb8802): undefined reference to `dax_get_by_host

Does the patch referenced in
https://marc.info/?l=linux-xfs&m=149493347832378&w=2
fix this too?

--D

> 
> with the following diff I do not get the error:
> --- .config.old	2017-05-18 17:45:44.621011682 +0200
> +++ .config	2017-05-18 19:06:56.608813894 +0200
> @@ -3362,7 +3362,7 @@ CONFIG_RAS=y
>  #
>  # CONFIG_ANDROID is not set
>  # CONFIG_LIBNVDIMM is not set
> -CONFIG_DAX=m
> +CONFIG_DAX=y
>  # CONFIG_DEV_DAX is not set
>  # CONFIG_NVMEM is not set
>  # CONFIG_STM is not set
> @@ -3439,7 +3439,7 @@ CONFIG_XFS_POSIX_ACL=y
>  # CONFIG_BTRFS_FS is not set
>  # CONFIG_NILFS2_FS is not set
>  # CONFIG_F2FS_FS is not set
> -# CONFIG_FS_DAX is not set
> +CONFIG_FS_DAX=y
>  CONFIG_FS_POSIX_ACL=y
>  CONFIG_EXPORTFS=y
>  # CONFIG_EXPORTFS_BLOCK_OPS is not set
> 
> So I guess, there is some dependency on that option missing.
> 
> 
> Best regards,
> Julian Wollrath
> 
> -- 
>  ()  ascii ribbon campaign - against html e-mail 
>  /\                        - against proprietary attachments


