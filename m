Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q73BSTpa088411 for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 06:28:29 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id tCLj45WquCDhF3VC
	for <xfs@oss.sgi.com>; Fri, 03 Aug 2012 04:28:28 -0700 (PDT)
Message-ID: <501BB5DD.1000302@hardwarefreak.com>
Date: Fri, 03 Aug 2012 06:28:29 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: realtime section bugs still around
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
	<20120730030333.GE2877@dastard>
	<CAGou9MheeBWxajd65szNfDB2L+VVoZ7SypEdUKj7np3L0H8fHA@mail.gmail.com>
	<CAGou9MgMHbTPebFUDXdyLvrUr4T9wo-geNtaPUft9uUmOaju6Q@mail.gmail.com>
	<50186E51.1020107@hardwarefreak.com>
	<CAGou9MhneejOuhX4c8G06c3Zh7dxF-OtZ+=mT-7fho_u1Q3zWw@mail.gmail.com>
	<5018A8C7.8050406@hardwarefreak.com>
	<CAGou9Mj=8xcF4YwaSQYp0_BbJW_Ms1sasDDRNxL1oh0oR7zupw@mail.gmail.com>
	<5019CC34.5050003@hardwarefreak.com>
	<CAGou9Mg4teJU3VHWxDK3-y1MMxN_FQ-Dpk3E1KzX0pNdLEHNOQ@mail.gmail.com>
	<501A58DB.7070801@hardwarefreak.com>
In-Reply-To: <501A58DB.7070801@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Jason Newton <nevion@gmail.com>, xfs@oss.sgi.com

On 8/2/2012 5:39 AM, Stan Hoeppner wrote:

> We already gave you the biggest cause of your latency, which is garbage
> collection/wear leveling.  You can't see inside the SSDs, but you can
> see the latency jump with either top (%wa) or iostat (await,
> milliseconds).  Run
> 
> iostat -x -d 1 20
> 
> and you get 20 reports 1 second apart.  1s is minimum granularity.  This
> should clearly show the latency spikes caused by the SSDs.  Maybe even
> execute it for 60 seconds and pipe to a file.

The above assumes Linux can see the individual devices.  I've never used
Intel's fakeraid.  If its driver presents a single device to the kernel
instead of both SSD devices, iostat won't show which SSD's garbage
collection is kicking in and/or when.  It would be most beneficial if
you could see the iostat data for both SSD devices as it would tell you
exactly when each drive's GC/leveling kicks in.  If the Intel fakeraid
doesn't allow you to see both devices, you'll need to switch to md/RAID.
 I'm sure that will be problematic as you're very likely booting from
the Intel RAIDed SSD device.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
