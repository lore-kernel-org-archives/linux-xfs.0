Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Nov 2006 06:55:41 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA3EtWaG028004
	for <xfs@oss.sgi.com>; Fri, 3 Nov 2006 06:55:34 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D9ECCD1B33AE
	for <xfs@oss.sgi.com>; Fri,  3 Nov 2006 06:54:44 -0800 (PST)
Message-ID: <454B5833.9030008@sandeen.net>
Date: Fri, 03 Nov 2006 08:54:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mount failed after xfs_growfs beyond 16 TB
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <20061103004142.GI8394166@melbourne.sgi.com>
In-Reply-To: <20061103004142.GI8394166@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>, xfs@oss.sgi.com

David Chinner wrote:
> On Thu, Nov 02, 2006 at 06:26:08PM +0100, Christian Guggenberger wrote:
>> Hi,
>>
>> a colleague recently tried to grow a 16 TB filesystem (x86, 32bit) on
>> top of lvm2 to 17TB. (I am not even sure if that's supposed work with
>> linux-2.6, 32bit)
> 
> Not supported - any metadata access past 16TB will wrap the 32 bit page cache
> index for the metadata address space and you'll corrupt the filesystem.


Ohhhh right.  I've been in x86_64 land for too long, sorry for the earlier false 
assertion....  :(

xfs guys, if it's not there already (and I don't see it from a quick look..) 
growfs -really- should refuse (in the kernel) to grow a filesystem past 16T on a 
32-bit machine, just as we refuse to mount one.  something like this in 
xfs_growfs_data_private:

#if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */
         if (unlikely(
             (nb >> (PAGE_SHIFT - sbp->sb_blocklog)) > ULONG_MAX) {
#else                  /* Limited by UINT_MAX of sectors */
         if (unlikely(
             (nb << (sbp->sb_blocklog - BBSHIFT)) > UINT_MAX) {
#endif
                 cmn_err(CE_WARN,
                         "new filesystem size too large for this system.");
                 return XFS_ERROR(E2BIG);
         }

and something similar in xfs_growfs_rt ?

-Eric
