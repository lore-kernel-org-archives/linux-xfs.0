Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q720dGYx094039 for <xfs@oss.sgi.com>; Wed, 1 Aug 2012 19:39:17 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id F0NvYbYDymVv5b4I
	for <xfs@oss.sgi.com>; Wed, 01 Aug 2012 17:39:15 -0700 (PDT)
Message-ID: <5019CC34.5050003@hardwarefreak.com>
Date: Wed, 01 Aug 2012 19:39:16 -0500
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
In-Reply-To: <CAGou9Mj=8xcF4YwaSQYp0_BbJW_Ms1sasDDRNxL1oh0oR7zupw@mail.gmail.com>
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
To: Jason Newton <nevion@gmail.com>
Cc: xfs@oss.sgi.com

On 8/1/2012 12:55 AM, Jason Newton wrote:

>> Just to figure out for sure what the bottlenecks are and whether they can
> be dealt with rather than looking at it as opaque system and assuming
> nothing can be done.  Also as a learning experience.

Jason, have you considered something like this to solve your problems?

RAM is cheap.  Far cheaper than attacking this problem with any other
hardware type.  And you can't easily solve it by rewriting to use AIO,
given the effort involved with that.

You should be able to fit 32GB of RAM on the board.  Create a 24GB RAM
disk and use that for writing your 5.7MB frame files in real time.  This
eliminates any latency and stutter issues during capture.  Treat the RAM
disk as a FIFO, taking each new file and copying it out to SSD after
it's been closed, then delete the original.  This gives you in essence a
very fast buffer.  If my math is correct, 24,000MB / 300MB/s = roughly
80 seconds of buffer at a 300MB/s streaming capture rate, 40 seconds at
600MB/s.

This should be very easy to implement, and cheaper than all other
alternatives.  It should eliminate all possible latency issues, though
it will increase CPU cycles due to the data movement to/from the RAM
disk, though how much I can't guess at this point.  8GB RAM disk will
give you 26 seconds of buffering at 300MB/s, and a 4GB RAM disk will
give you 13 seconds of buffering.  If 13 seconds is sufficient, you can
implement this on a machine with only 8GB RAM, assuming you need no more
than 4GB for kernel/user space/application.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
