Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Nov 2006 17:15:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA61F6aG024803
	for <xfs@oss.sgi.com>; Sun, 5 Nov 2006 17:15:08 -0800
Date: Mon, 06 Nov 2006 11:15:22 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: mount failed after xfs_growfs beyond 16 TB
Message-ID: <FFDFD6610F310171562D474B@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <454B5833.9030008@sandeen.net>
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de>
 <20061103004142.GI8394166@melbourne.sgi.com> <454B5833.9030008@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>, xfs@oss.sgi.com

Good idea, Eric.
I've created a pv.
I noticed this was taken from xfs_mount_validate_sb() for the dblocks test.
I guess it would be nice to abstract this test in a macro for use in multiple places.

Cheers,
Tim.

--On 3 November 2006 8:54:43 AM -0600 Eric Sandeen <sandeen@sandeen.net> wrote:

> David Chinner wrote:
>> On Thu, Nov 02, 2006 at 06:26:08PM +0100, Christian Guggenberger wrote:
>>> Hi,
>>>
>>> a colleague recently tried to grow a 16 TB filesystem (x86, 32bit) on
>>> top of lvm2 to 17TB. (I am not even sure if that's supposed work with
>>> linux-2.6, 32bit)
>>
>> Not supported - any metadata access past 16TB will wrap the 32 bit page cache
>> index for the metadata address space and you'll corrupt the filesystem.
>
>
> Ohhhh right.  I've been in x86_64 land for too long, sorry for the earlier false assertion....  :(
>
> xfs guys, if it's not there already (and I don't see it from a quick look..) growfs -really-
> should refuse (in the kernel) to grow a filesystem past 16T on a 32-bit machine, just as we
> refuse to mount one.  something like this in xfs_growfs_data_private:
>
># if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
>          if (unlikely(
>              (nb >> (PAGE_SHIFT - sbp->sb_blocklog)) > ULONG_MAX) {
># else                  /* Limited by UINT_MAX of sectors */
>          if (unlikely(
>              (nb << (sbp->sb_blocklog - BBSHIFT)) > UINT_MAX) {
># endif
>                  cmn_err(CE_WARN,
>                          "new filesystem size too large for this system.");
>                  return XFS_ERROR(E2BIG);
>          }
>
> and something similar in xfs_growfs_rt ?
>
> -Eric
>
