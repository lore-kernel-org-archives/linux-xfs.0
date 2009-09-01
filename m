Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81Cm9FY175068 for <xfs@OSS.SGI.com>; Tue, 1 Sep 2009 07:48:29 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F26E415FDF
	for <xfs@OSS.SGI.com>; Tue,  1 Sep 2009 05:49:00 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id wacgQQjMk1OfsaZY
	for <xfs@OSS.SGI.com>; Tue, 01 Sep 2009 05:49:00 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1MiSjY-0003eT-W4
	for <xfs@OSS.SGI.com>; Tue, 01 Sep 2009 12:45:13 +0000
MIME-Version: 1.0
Message-ID: <19101.5976.387292.614270@tree.ty.sabi.co.uk>
Date: Tue, 1 Sep 2009 12:45:12 +0000
Subject: Re: xfs data loss
In-Reply-To: <B9A7B002C7FAFC469D4229539E909760308DA65408@DU-EXC-MAIL.empa.emp-eaw.ch>
References: <B9A7B002C7FAFC469D4229539E909760308DA651DE@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A975A35.3060809@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65345@DU-EXC-MAIL.empa.emp-eaw.ch>
	<4A981133.6060009@sandeen.net>
	<B9A7B002C7FAFC469D4229539E909760308DA65408@DU-EXC-MAIL.empa.emp-eaw.ch>
From: pg_xf2@xf2.to.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

> [ ... ] such a harsh way.

Harsh? That sounds way too harsh. :-)

When you write to a mailing list asking for free help and support,
it is rather rude to not have done some preliminary work, such as
figuring out the characterisics of RAID5 in case of failure. It
is also somewhat rude (but amazingly common) to make confused and
partial reports, such as not checking and reporting what has
actually failed.

> Is this the habit of this mailing list?

Depends -- some people here are XFS salesmen, in that their career
and employability depend at least in part on widespread adoption
of XFS, and on support from other kernel subsystem guys, who may
be one day on an interview panel (the guild of Linux kernel
hackers is a pretty small and closed world in practice). These are
sell-side engineers, and they will be smooth and emollient even in
the face of outrageously ridiculous stuff. Sell-side engineers
just like sell-side stack analyst never issue anything as harsh as
a "sell" recommendation.

That's what I do myself when I am on the sell-side, to my
coworkers and customers; they pay me to solve their problems, not
to tell them they are idiots for creating those problems, and
suffering fools gladly is pat of what I get paid for.

But here I am on the buy-side; I am buying XFS (and the Linux
block layer), not selling it. Not only that, I am providing unpaid
opinions.

Since I am here buying, and actually paying with my time, I can
comment more openly than a someone with a sell-side POV, but still
in a relatively soft way, about the merit of the issues I comment
upon.

> Apart from that, thank you for you help.

But a soft but more open assessment of how outrageous some queries
are is help too as it makes it easier to assess the gravity of the
situation. The smooth, emollient sell-side people will let you dig
your own grave. Just consider your statement below about "assume
clean" that to me sounds very dangerous (big euphemism), and that
did not elicit any warning from the sell-side:

> Moreover, when a raid loses 2 devices, and the devices are still
> ok, it is possible to reassemble the raid by assuming the
> devices clean.

Sure you can reassemble the RAID, but what do you mean by "still
ok"? Have you read-tested those 2 drives? Have you tested the
*other* 18 drives? How do you know none of the other 18 drives got
damaged? Have you verified that only the host adapter electronics
failed or whatever it was that made those 2 drives drop out?

Why do you *need* to assume clean? If the 2 "lost" drives are
really ok, you just resync the array. If you *need* to assume
clean, it is likely that you have lost something like 5% of data
in (every stripe and thus) most files and directories (and
internal metadata) and will be replacing it with random
bytes. That will very likely cause XFS problems (the least of the
problems of course).

> I understand that RAID5 is not the ideal solution for that
> system, [ ... ]

That we don't know for sure; I personaly very much dislike RAID5,
but for throw-away mostly read-only data I have to concede that it
seems appropriate. It is rather better than RAID6 in almost every
reasonable situation. Still a 19+1 array sounds rather bizarre to
say the least. Especially in a place where part of the everyday
activity is earthquake simulation...

> But apart from that, it is not as easy to backup 20 TB,

Or to 'fsck' several TB as you also discovered. Anyhow my opinion
is that the best way to backup large storage servers is another
large storage server (or more than one). When I buy a hard drive I
buy 3 backup drives for each "live" drive I use -- at *home*.

> so we decided to set it as data storage leaving the
> responsibilty of the backup to our users. I do not consider it
> completely absurd.

Not at all absurd -- if those users *really* accept that. But you
are trying to recover the arrays instead of scratching them and
restarting. That suggests to me that the users did not actually
accept that. If the real agreement with the users is "you have to
keep backups, but if something happens you will behave as if you
cannot or don't want to restore them" it is quite different.

> This is not the case for /Raid/md4, where apparently all devices
> are there.

That's not so clear. One problem with trying to provide some
opinions on your issue and whether the filesystems are recoverable
is that you haven't made clear what failed and how you tested each
component of each array to make sure that what is still working is
known (and talk of "assume clean" is very suspicious).

I'd check *everything* because until then you don't know how much
has been damaged where, as a major power issue may have affected
*everything* even if only partially. When you wrote:

  > one half (5 TB) of the user directories on /dev/md4 have
  > disappeared.

that seems to indicate some major filesystem metadata and data
loss, and the idea of "assume clean" seems to me extremely
dangerous. Also '/dev/md5' seems to have reported serious drive
issues, so perhaps something bad happened to the '/dev/md4' drives
too.

That you have tried to run repair tools on a filesystem with an
incomplete storage layer may have made things rather worse, so
knowing *exactly* what has failed may help you a lot.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
