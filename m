Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5009D7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:17:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ECCC8F8039
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:17:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QopbKKTWDqXuFMiT for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 15:17:52 -0700 (PDT)
Date: Wed, 17 Sep 2014 08:17:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs fails with raid5 and smaller chunk sizes
Message-ID: <20140916221738.GO4322@dastard>
References: <5418B39C.2060707@rincon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5418B39C.2060707@rincon.com>
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
To: Brian Hemme <bmh@rincon.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 16, 2014 at 03:03:08PM -0700, Brian Hemme wrote:
> Hello all,
> 
> I am having some odd problems with mkfs.xfs when used on a raid 5
> array.  The array is built from 6 960GB SSDs all connected to SATA
> ports on the MB and created with mdadm.  If I use a chunk size any
> smaller then 512K mkfs.xfs just hangs forever.  It continues to use
> CPU and so does the raid array but never completes.  If the system
> is just left running for an extended length of time the whole OS
> eventually locks up.  I have tried this on three different systems
> with the same results.   I have searched all over for someone with
> similar issues without success.  I am hoping I am just doing
> something clearly wrong and you all can set me straight quickly.
> 
> Some specifics:
>     Arch linux with 3.14.1 kernel
>     mkfs.xfs version 3.1.11
>     mdadm - v3.3 - 3rd September 2013
> 
> Commands:
> > mdadm --create /dev/md0 --chunk=64K --level=5 --raid-devices=6
> /dev/sd[a-f]
> > mkfs.xfs /dev/md0
>   ** This command fails and locks up
> 
> I have tried specifying the arguments to mkfs.xfs with the same
> results.  Building a 4 drive array seems to require a chunk size of
> 1M or greater to work.  Same results if I make a partition on the
> array and make the fs there.

mkfs.xfs really should only take a couple of seconds to complete.
Seeing as you are using SSDs, my first suspicion is that md or the
SSDs are having problems with discard. Hence you should first
try 'mkfs.xfs -K /dev/md0' and see if that completes quickly.

Otherwise, output of 'echo w > sysrq-trigger' from dmesg would be a
good start, as would a 'perf top -G -U' snapshot (run for 30s at
least a minute after mkfs.xfs starts) to tell us what is burning
CPU.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
