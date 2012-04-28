Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3S4gh8v248968 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 23:42:43 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id oHvYu5McspXGpIoU
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 21:42:42 -0700 (PDT)
Message-ID: <4F9B7542.8070207@hardwarefreak.com>
Date: Fri, 27 Apr 2012 23:42:42 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
	<1335363423.4586.431.camel@montana.filmlight.ltd.uk>
	<CAAxjCExzLXGMw2O32kR8xGS6-EpfwfKm-zkM0Vy58bryWygZuQ@mail.gmail.com>
	<4F9ABB35.4020806@scalableinformatics.com>
In-Reply-To: <4F9ABB35.4020806@scalableinformatics.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: landman@scalableinformatics.com
Cc: xfs@oss.sgi.com

On 4/27/2012 10:28 AM, Joe Landman wrote:
> On 04/26/2012 04:53 AM, Stefan Ring wrote:
> =

> =

>> I just want to stress that our machine with the SmartArray controller
>> is not a cheap old dusty leftover, but a recently-bought (December
>> 2011) not exactly cheap Blade server, and that=92s all you get from HP.
> =

> We have an anecdote about something akin to this which happened 2 years
> ago.  A potential customer was testing a <insert large multi-letter
> acronym brand name here> machine to run a specific set of software which
> tightly coupled to its disks.  Performance was terrible.  Our partner
> (the software vendor) contacted us and asked us to help.  We'd suggested
> that the partner loan them the machine they had bought from us 2 years
> earlier (at the time) and try that.
> =

> Our 2 year old machine (actually 2 generations back at the time of test,
> now 5 generations behind our current kit) wound up being more than an
> order of magnitude faster than the (then) latest and greatest kit from
> <insert large multi-letter acronym brand name here>.
> =

> The lesson is this.  Latest and greatest doesn't mean fastest.  Design,
> and implementation matter.  Brand names don't.
> =

> To this day, we still see machines being pushed out with PCIx technology
> for networking, or disk, or ...

I've seen this as well.  A vendor gets comfortable and confident with a
particular main board, RAID card, NIC, etc, that demonstrate uber
reliability in the field and is easy to work on/with.  They continue
selling it as long as they can still get their hands on it, even though
much better technology has long been available.  It's the "stick with
what we know works" mentality.  Sometimes this is a good strategy.  If a
customer constantly needs maximum performance, obviously not.

> ... and customers buy it up, for reasons that have little to do with
> performance, suitability to the task, etc.
> =

> If you need performance, its important to focus some effort upon
> locating systems/vendors capable of performing where you need them to
> perform.  Otherwise you may wind up with a warmed over web server with
> some random card and a few "fast" disks tossed in.
> =

> I don't mean to be blunt, but this is basically what you were sold. Note
> also, I see this in cluster file system bits all the time.  We get calls
> from people, who describe a design, and ask us for help making them go
> fast.  We discover that they've made some deep fundamental design
> decisions very poorly (usually upon the basis of what <insert large
> multi-letter acronym brand name here> told them were options), and there
> was no way to get between point A (their per unit performance) and point
> B (what they were hoping for as an aggregate system performance).
> =

> At the most basic level, your performance will be modulated by your
> slowest performing part.  You can put infinitely fast disks on a slow
> controller, and your performance will be terrible.  You can put slow
> disks on a very fast controller, and you will likely have better luck.

I generally agree with this last statement, but I think it's most
relevant to parity arrays.  In general RAID1/10 performance tends to be
less impacted by controller speed.  But yes, a really poor slow
controller is going to limit anything you try to do with any disks.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
