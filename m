Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA1657F52
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 17:05:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ACC3130406A
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 15:05:25 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id bzsqlA6Qw5IYa1l7 for
	<xfs@oss.sgi.com>; Tue, 05 Feb 2013 15:05:21 -0800 (PST)
Message-ID: <31611.192.104.24.222.1360105520.squirrel@secure.skymagik.net>
Date: Tue, 5 Feb 2013 18:05:20 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <20130205213206.GP2667@dastard>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
	<45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
	<20130204125510.GL2667@dastard>
	<11083.192.104.24.222.1360088562.squirrel@secure.skymagik.net>
	<20130205213206.GP2667@dastard>
MIME-Version: 1.0
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
To: david@fromorbit.com
Cc: storm9c1@skymagik.com, xfs@oss.sgi.com

In a previous message, Dave Chinner wrote:
>>
>> Any suggestions on how I would debug this?
>
> Find out if the unmount is returning an error first. If there is no
> error, then you need to find what is doing bind mounts on your
> system and make sure they are unmounted properly before the final
> unmount is done. If lazy unmount is being done, make it a normal
> unmount an see where the unmount is getting stcuk or taking time to
> complete by using sysrq-w if it gets delayed for any length of time.
>

I agree.  However, I may be at the mercy of the upstream vendor.
This is a completely stock CentOS system with minimal packages
installed (save using XFS as the root fs).  Oracle Enterprise Linux
as well as Scientific Linux also suffers from the same problem.
It's curious because the upstream vendor must be doing something
at shutdown to trigger this.  I will get my hands dirty tonight and
see how the system performs these umounts at shutdown.

I am also prepared to blacklist the entire CentOS/RHEL 5.9 since
I've been struggling with this for a few weeks now.  I am getting
close to giving up and moving on.  I mean, I ran into this during
regression testing before moving my "latest" pointer from 5.8 to 5.9.
I can easily keep latest at 5.8 and not cause impact for now (which is
why I use the version "pointer" mentality).  But I'm also worried about
no upgrade path until this is resolved.  I am stubborn about using XFS
exclusively.  Otherwise I could just deploy on ext3 and never see this.


> FWIW, because this is a old, old kernel, event tracing is not
> available, so the single most useful tool for tracking this down is not
> available...

Yeah, I know.  Welcome to the RHEL/CentOS/OEL/SL world.  That's why I use
Ubuntu for the desktop (easy to play with, easy to break, easy to fix) and
RHEL for servers (hard to break, but when it does break, watch out).
It's been a long time since I saw RHEL break this bad...I'm usually pretty
good at working around problems like this.  But this one has me stumped.

Thanks again.  I'll keep you posted.

-- Tom


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
