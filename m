Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33676 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755541AbdIHQz1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 12:55:27 -0400
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <81dc9410-c9d1-20d3-65a6-6763d31b64b7@sandeen.net>
Date: Fri, 8 Sep 2017 11:55:26 -0500
MIME-Version: 1.0
In-Reply-To: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org

On 9/5/17 12:44 AM, Chandan Rajendra wrote:
> Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> physical sector size of loop devices. On ppc64, this causes loop devices
> to have 64k as the physical sector size.
> 
> With these changes, mkfs.xfs now prints error messages when filesystem
> blocksize (4k) is less than underlying device's physical
> sectorsize (64k). These messages (printed on stderr) now cause several
> xfstests to fail on ppc64 machine since xfstests' _filter_mkfs() isn't
> able to filter out stderr.
> 
> Also, the messages themselves describe a possible sub-optimal setup. But
> the setup is still usable.
> 
> Hence this commit removes the calls to fprintf() used to print the
> messages.

So, it looks like the loop change is getting reverted, right ... still -

Although I suggested this change, I'm rethinking it.  I'm not a fan
of the warning for a default situation; the user can get this warning
with nothing but a bare mkfs, which is not good IMHO.

(dchinner OTOH thinks we should warn about this suboptimal situation
in any case - but I really don't think it's mkfs's job to be warning
about every suboptimal geometry - there are a lot of them out there!)

What I'd now propose is that we change this warning into a failure,
but only if a too-small block size was actually /specified/, i.e.
bsflag is set.  If we're adjusting sector size based on device geometry
and /default/ blocksize, I think we should just shut up about it.

i.e. something like:

                if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
			if (bsflag) {
                                fprintf(stderr,
_("specified blocksize %d cannot be less than device physical sector size %d\n"),
                                        blocksize, ft.psectorsize);
                                usage();
                        }
                        sectorsize = ft.lsectorsize ? ft.lsectorsize :
                                                      XFS_MIN_SECTORSIZE;
                }

Thoughts?

-Eric

> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  mkfs/xfs_mkfs.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dfffae7..0bb3897 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2011,12 +2011,6 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  					      XFS_MIN_SECTORSIZE;
>  
>  		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
> -			fprintf(stderr,
> -_("specified blocksize %d is less than device physical sector size %d\n"),
> -				blocksize, ft.psectorsize);
> -			fprintf(stderr,
> -_("switching to logical sector size %d\n"),
> -				ft.lsectorsize);
>  			sectorsize = ft.lsectorsize ? ft.lsectorsize :
>  						      XFS_MIN_SECTORSIZE;
>  		}
> 
