Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D81407F76
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 11:23:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C56778F8037
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 09:23:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nTEv7xHbpRIT9R5J for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 09:23:24 -0700 (PDT)
Message-ID: <55CCC47A.5030706@sandeen.net>
Date: Thu, 13 Aug 2015 11:23:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH][RFC] xfs_copy: don't use DIRECT IO to copy 4k sector
	device
References: <1439478465-14072-1-git-send-email-zlang@redhat.com>
In-Reply-To: <1439478465-14072-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>, xfs@oss.sgi.com

On 8/13/15 10:07 AM, Zorro Lang wrote:
> When I run xfstests xfs/032 in ppc64le, I hit a failure:
> 
>      xfs_copy: read failed: Invalid argument
>      xfs_copy: size check failed
>      xfs_copy: /dev/sda5 filesystem failed to initialize
>      xfs_copy: Aborting.
>      Copy failed for Sector size 4096 Block size 4096
> 
> I try to use gdb trace xfs_copy. I find it try to open the
> source device with DIRECT flag, then read the device with
> ((1<<BBSHIFT))=512 bytes length. If the source device is
> 4k sector, directly read 512 bytes will be failed.
> 
> xfs_copy '-b' option only work for target file/device, to
> sure it will open the target without DIRECT flag. But useless
> for source device open.
> 
> So I make DIRECT flag only be enabled when source device
> sector size equal BBSIZE.

Which version of xfsprogs did you test?  This is recently upstream:

commit c63ce10a9450020382bbbe2c48788961b19830f4
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Jul 31 09:03:11 2015 +1000

    xfs_copy: fix copy of hard 4k devices
    
    If we have a pure 4k device with no 512 emulation, xfs_copy
    fails straightaway because it tries to do a 512-byte direct
    IO read of the superblock.
    
    Do like we do in xfs_db, and read in the max possible sector size,
    because we don't yet know what the filesystem's sector size is.
    
    This fixes a failure in xfs/032 on a hard 4k device.

-Eric

> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> I'm not so familiar for xfsprogs, so I'm not sure this's the best
> idea to fix this problem. Please help to check, and maybe give me
> better suggestions.
> 
> Thanks very much,
> Zorro Lang
> 
>  copy/xfs_copy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index e13f468..1cd6253 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -666,7 +666,6 @@ main(int argc, char **argv)
>  	/* prepare the libxfs_init structure */
>  
>  	memset(&xargs, 0, sizeof(xargs));
> -	xargs.isdirect = LIBXFS_DIRECT;
>  	xargs.isreadonly = LIBXFS_ISREADONLY;
>  
>  	if (source_is_file)  {
> @@ -689,6 +688,8 @@ main(int argc, char **argv)
>  			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
>  	sb = &mbuf.m_sb;
>  	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
> +	if (sb->sb_sectsize == BBSIZE)
> +		xargs.isdirect = LIBXFS_DIRECT;
>  
>  	/* Do it again, now with proper length and verifier */
>  	libxfs_putbuf(sbp);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
