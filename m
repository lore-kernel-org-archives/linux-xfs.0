Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RJ8RgQ227449 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:08:27 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id sABFk20FZEIKHgjz
	for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 11:08:26 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id B059C6C11A
	for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:08:25 -0600 (CST)
Message-ID: <4F22F62B.2090506@hardwarefreak.com>
Date: Fri, 27 Jan 2012 13:08:27 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Insane file system overhead on large volume
References: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
In-Reply-To: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 1/27/2012 1:50 AM, Manny wrote:
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

Maybe you simply assigned 2 spares and forgot, so you actually only have
10 RAID6 disks with 8 disks worth of stripe, equaling 24 TB, or 21.8
TiB.  21.8 TiB matches up pretty closely with your 22 TB, so this
scenario seems pretty plausible, dare I say likely.

If this is the case you'll want to reformat the 10 disk RAID6 with the
proper sunit/swidth values.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
