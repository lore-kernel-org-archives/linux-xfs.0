Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2IJSQmN010254 for <xfs@oss.sgi.com>; Sun, 18 Mar 2012 14:28:26 -0500
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	lrrbuh4HVXlAHnaG for <xfs@oss.sgi.com>;
	Sun, 18 Mar 2012 12:28:24 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <20326.13500.799169.828158@tree.ty.sabi.co.UK>
Date: Sun, 18 Mar 2012 19:17:16 +0000
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
In-Reply-To: <20120318140051.GA2594@infradead.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com> <20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
	<20325.50714.237894.328039@tree.ty.sabi.co.UK>
	<20120318140051.GA2594@infradead.org>
From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>>>  =ABThere have been decent but no major improvements in XFS
>>>  metadata *performance*, but weaker implicit *semantics*
>>>  have been made an option, and these have a different
>>>  safety/performance tradeoff (less implicit safety, somewhat
>>>  more performance), not "just" better performance.=BB

>> I have left implicit a point that perhaps should be explicit: I
>> think that XFS metadata performance before 'delaylog' was pretty
>> good, and that it has remained pretty good with 'delaylog'.

> For many workloads it absolutely wasn't.

My self importance is not quite as huge as feeling able to just
say =ABabsolutely wasn't=BB to settle points once and for all.

So I would rather argue (and I did in a different form) that for
some workloads 'nobarrier'+'hdparm -W1' or 'eatmydata' have the
most desirable tradeoffs, and for many others the safety/speed
tradeoff of 'delaylog' is more appropriate (so for example I
think that making it the default is reasonable if a bit edgy).

But also that as the already quoted document makes it very clear
how overall 'delaylog' improves unsafety and only thanks to this
latency and time to completion are better:

http://lwn.net/Articles/476267/
http://www.mjmwired.net/kernel/Documentation/filesystems/xfs-delayed-loggin=
g-design.txt
124     [ ... ] In other
125	words, instead of there only being a maximum of 2MB of transaction chan=
ges not
126	written to the log at any point in time, there may be a much greater am=
ount
127	being accumulated in memory. Hence the potential for loss of metadata o=
n a
128	crash is much greater than for the existing logging mechanism.

That's why my argument was that performance without 'delaylog'
was good: given the safer semantics, it was quite good.

Just perhaps not the semantics tradeoff that some people wanted
in some cases, and I think that it is cheeky marketing to
describe something involving a much greater =ABpotential for loss
of metadata=BB as better performance boldly and barely, as then
one could argue that 'eatmydata' gives the best "performance".

Note: the work on multithreading the journaling path is an
  authentic (and I guess amazingly tricky) performance
  improvement instead, not merely a new safety/latency/speed
  tradeoff similar to 'nobarrier' or 'eatmydata'.

>> People who complained about slow metadata performance with XFS
>> before 'delaylog' were in effect complaining that XFS was
>> implementing overly (in some sense) safe metadata semantics, and
>> in effect were demanding less (implicit) safety, without
>> probably realizing they were asking for that.

> No, they weren't,

Again my self importance is not quite as huge as feeling able to
just say =ABNo, they weren't=BB to settle points once and for all.

Here it is not clear to me what you mean by =ABthey weren't=BB, but
as the quote above shows, even if complainers weren't in effect
=ABdemanding less (implicit) safety=BB, that's what they got anyhow,
because that's the main (unavoidable) way to improve latency
massively given how expensive barriers are (at least on disk
devices). That's how the O_PONIES story goes...

> [ ... personal attacks ... ]

It is noticeable that 90% of your post is pure malicious
offtopic personal attack, and the rest is "from on high",
and the whole is entirely devoid of technical content.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
