Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92KmBKx085184 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 15:48:12 -0500
Received: from vwp1161.webpack.hosteurope.de (vwp1161.webpack.hosteurope.de
	[87.230.104.173]) by cuda.sgi.com with ESMTP id
	P80yJ1vAVTcFFWdC for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 13:49:33 -0700 (PDT)
Message-ID: <506B5357.6060609@blafoo.org>
Date: Tue, 02 Oct 2012 22:49:27 +0200
From: Volker <mail@blafoo.org>
MIME-Version: 1.0
Subject: Re: OOM on quotacheck (again?)
References: <5059D2B4.8010300@blafoo.org> <20120919205924.GC31501@dastard>
	<505AE2A1.5060703@blafoo.org> <20120924132113.GL20960@dastard>
	<5060727D.4000009@blafoo.org> <506B1667.4010203@blafoo.org>
	<20121002200946.GP23520@dastard>
In-Reply-To: <20121002200946.GP23520@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi,

>> If its of any interest, i can supply the stack-traces.
> 
> Yes, it is of interest, can you post everything you found out about
> the problem? (dmesg, stack traces, repair output, etc).

Everything posted here is from a single server and its chronologically
top to bottom. Without having checked each and every stacktrace, it
looked quite similar on the other servers.

http://pastebin.com/PXquE4sM

Sidenote:
The xfs_repair would not finish without supplying -P, otherwise the
repair hang in phase 6 (might be related to this bug:
http://oss.sgi.com/archives/xfs-masters/2011-01/msg00009.html)

Hope it helps! Since we have about 300 servers left to go from 2.6.37 to
3.6, i'd be happy to do some testing as long we are not gambling with
our customers data :-)

- volker



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
