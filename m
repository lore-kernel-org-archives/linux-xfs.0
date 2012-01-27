Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RILnug224291 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 12:21:49 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id IYMnFrbm3iUFgBBC for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 10:21:47 -0800 (PST)
Message-ID: <4F22EB3C.6020106@sandeen.net>
Date: Fri, 27 Jan 2012 12:21:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Insane file system overhead on large volume
References: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
In-Reply-To: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Manny <dermaniac@gmail.com>
Cc: xfs@oss.sgi.com

On 1/27/12 1:50 AM, Manny wrote:
> Hi there,
> 
> I'm not sure if this is intended behavior, but I was a bit stumped
> when I formatted a 30TB volume (12x3TB minus 2x3TB for parity in RAID
> 6) with XFS and noticed that there were only 22 TB left. I just called
> mkfs.xfs with default parameters - except for swith and sunit which
> match the RAID setup.
> 
> Is it normal that I lost 8TB just for the file system? That's almost
> 30% of the volume. Should I set the block size higher? Or should I
> increase the number of allocation groups? Would that make a
> difference? Whats the preferred method for handling such large
> volumes?

If it was 12x3TB I imagine you're confusing TB with TiB, so
perhaps your 30T is really only 27TiB to start with.

Anyway, fs metadata should not eat much space:

# mkfs.xfs -dfile,name=fsfile,size=30t
# ls -lh fsfile
-rw-r--r-- 1 root root 30T Jan 27 12:18 fsfile
# mount -o loop fsfile  mnt/
# df -h mnt
Filesystem            Size  Used Avail Use% Mounted on
/tmp/fsfile            30T  5.0M   30T   1% /tmp/mnt

So Christoph's question was a good one; where are you getting
your sizes?

-Eric

> Thanks a lot,
> Manny
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
