Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42734 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeCNVS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 17:18:56 -0400
Date: Wed, 14 Mar 2018 14:18:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: generic/127 failure on xfs with hacked fsx
Message-ID: <20180314211851.GW4865@magnolia>
References: <CAJfpegs=RenwFojwAze_y7WF3hwiNu-+5qDw_wyT=o0M063HkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegs=RenwFojwAze_y7WF3hwiNu-+5qDw_wyT=o0M063HkQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Mar 14, 2018 at 04:50:02PM +0100, Miklos Szeredi wrote:
> While testing overlayfs I found something which appears to be an
> unwanted side effect of xfs_release().
> 
> Apply the attached patch to xfstests and run generic/127.
> 
> Result is:
> 
>     +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 fsx_std_mmap
>     +Mapped Read: non-zero data past EOF (0x8aa1) page offset 0xaa2 is 0xa091
>     +LOG DUMP (70315 total operations):
> 
> Thanks,
> Miklos

Hmm.... so I applied this and ran generic/127 on xfs:

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 magnolia-mtr00 4.16.0-rc5-xfsx
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, /dev/pmem4
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sda /opt

generic/127      53s
Ran: generic/127
Passed all 1 tests

Reran a couple of times without seeing any problems, so what am
I missing?  Are you running xfstests atop overlayfs atop xfs?

/me confused. :/

--D

> ---
>  ltp/fsx.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -647,6 +647,14 @@ check_trunc_hack(void)
>  	}
>  }
>  
> +static void openclose(int fd)
> +{
> +	char path[32];
> +
> +	sprintf(path, "/proc/self/fd/%i", fd);
> +	close(open(path, O_RDONLY));
> +}
> +
>  void
>  doflush(unsigned offset, unsigned size)
>  {
> @@ -799,6 +807,7 @@ domapread(unsigned offset, unsigned size
>  	        prterr("domapread: mmap");
>  		report_failure(190);
>  	}
> +	openclose(fd);
>  	memcpy(temp_buf, p + pg_offset, size);
>  
>  	check_eofpage("Read", offset, p, size);

