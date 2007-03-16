Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 19:02:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2G2226p019973
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 19:02:04 -0700
Date: Fri, 16 Mar 2007 12:32:27 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Should xfs_repair take this long?
Message-ID: <20070316013227.GO5743@melbourne.sgi.com>
References: <20070315202027.CNS24438@comet.stsci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315202027.CNS24438@comet.stsci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Thomas Walker <walker@stsci.edu>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, Mar 15, 2007 at 08:20:27PM -0400, Thomas Walker wrote:
> 
>   Ok, here's the output of the command you wanted.  I ran it on both of the xfs file systems we have, both say bad superblock when trying to mount;
> 
> [root@hla-ags ~]# dd if=/dev/mapper/vg0-hladata3 bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x
> 000000

That failed - the output should be like:

 # dd if=/dev/mapper/test_vg-fred bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x
000000 4658 4253 0000 0010 0000 0000 1000 0000
000010 0000 0000 0000 0000 0000 0000 0000 0000
000020 34a8 5343 d8e3 8d46 01a5 b1e4 3a76 ac05
000030 0000 0000 0800 0400 0000 0000 0000 8000
000040 0000 0000 0000 8100 0000 0000 0000 8200
000050 0000 0100 0200 0000 0000 0800 0000 0000
000060 0000 000a b430 0002 0001 1000 0000 0000
000070 0000 0000 0000 0000 090c 0408 0011 1900
000080 0000 0000 0000 803c 0000 0000 0000 0606
000090 0000 0000 0c00 16f5 0000 0000 0000 0000
0000a0 0000 0000 0000 0000 0000 0000 0000 0000
0000b0 0000 0000 0000 0200 0000 0000 0000 0000
0000c0 0000 0000 0000 0000 0000 0000 0000 0000
*
000200

Can you remove the redirect to /dev/null so we can see the error message?

Sorry about that.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
