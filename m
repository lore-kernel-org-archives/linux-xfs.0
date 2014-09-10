Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A2D97F6C
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 23:16:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE36FAC003
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 21:15:57 -0700 (PDT)
Received: from mail04.lsn.net (mail04.lsn.net [66.90.130.138]) by cuda.sgi.com
	with ESMTP id nA0NYnjeNNmOgxFD for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 21:15:55 -0700 (PDT)
Message-ID: <540FD038.5010202@mygrande.net>
Date: Tue, 09 Sep 2014 23:14:48 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>
	<20140909220645.GH20518@dastard>	<540FA586.9090308@mygrande.net>
	<20140910015331.GJ20518@dastard>	<540FC135.8010601@mygrande.net>
	<20140910033331.GA27048@dastard>
In-Reply-To: <20140910033331.GA27048@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 9/9/2014 10:33 PM, Dave Chinner wrote:

> There is no direct relevance to your situation, but for a lot of
> other common problems it definitely is. That's why we ask people to
> report it with all the other information about their system

	Yeah, understood.

> Ok. We have seen over time that those 3ware controllers can do
> strange things in error conditions - we've had reports of entire
> hardware luns dying and being completely unrecoverable after a
> disk was kicked out due to an error.

	Oof.  That's not good.  It's stable right now.  I'm considering a 
different controller at some point.  I may accelerate that process.

> I can't comment on the
> highpoint controller - either not many people use them or they just
> don't report problems if there do. Either way, I'd suggest that if
> you aren't running the latest firmware it would be to update them
> as these problems were typically fixed by newer firmware releases.

	As a matter of fact, I was going to do just that.  I have to reboot the 
system in DOS (of all things), since they don't have a linux loader. 
I've got to arrange a convenient time.

>> 	OK. I'll scarf the source and compile.  All I need is to git clone
>> git://oss.sgi.com/xfs/xfs and git://oss.sgi.com/xfs/cmds/xfsprogs,
>> right?
>
> Just clone git://oss.sgi.com/xfs/cmds/xfsprogs and check out the
> v3.2.1 tag and build that..

	OK, I'm doing something wrong, I think.  It's been over a decade since 
I compiled a kernel.  It makes me a little nervous.
>
>> 	I've never used git on a package maintained in my distro.  Will I
>> have issues when I upgrade to Debian Jessie in a few months, since
>> this is not being managed by apt / dpkg?  It looks like Jessie has
>> 3.2.1 of xfs-progs.
>
> If you're using debian you can build debian packages directly from
> the git tree via "make deb" (I use it all the time for pushing

	Um, is that make deb-pkg, perhaps?  I'm not seeing a "deb" in the 
package targets.

> new builds to my test machines) and so when you upgrade to Jessie it
> should just replace your custom built package correctly...

	`make deb` finds no install target.  If I run `make menuconfig` it 
complains about there being no ncurses.  Libncurses5 is installed, and I 
don't know what else I should get.  `make oldconfig` seems to work.  Am 
I headed the right direction?  There are quite a few configuration 
targets, and I am not sure which one to choose.  There are also a number 
of questions asked by the oldconfig target (and presumably the same for 
other config targets), and I'm unsure how to answer.  I definitely don't 
want to make an error and potentially wind up with an unbootable system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
