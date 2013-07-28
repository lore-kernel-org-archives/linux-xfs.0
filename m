Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 366337F6C
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 21:21:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 023E7304059
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 19:21:40 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	siJoTkCgcdXSpjcf for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 19:21:39 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id 28FF01F002F5
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 22:21:39 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id EI+zvIfG7U8J for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 22:21:34 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id B89851F00318
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 22:21:34 -0400 (EDT)
Date: Sat, 27 Jul 2013 22:21:34 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <52C3E9E6-61DD-4537-9A64-C8CBFC86F6E3@gmail.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
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
To: xfs@oss.sgi.com

----- Original Message -----
> From: "aurfalien" <aurfalien@gmail.com>

> If it RHEL/CentOS really is the only option, then perhaps get one box
> on RHEL and submit bugs for it.

Sure, but "submit bugs" was a straw man the entire time  The OP wasn't talking
about how and where to submit bugs, and neither was I.

The OP was trying to determine how he got from Distro/Kernel Version to
XFS checkout ID, so that he could *talk to the XFS devs* about his problem.

And no one had a straight answer for him, which straight answer *is*:

"You have to talk to whomever builds the kernel packages for the distro 
you're working on; they should be able to tell you which XFS {version|
release|checkout} is built into that particular kernel RPM."

>From there, we veered *very* close to "we don't talk to people unless 
they're paying Red Had customers", and I'm relatively certain that was
*not* the takeaway Dave was aiming for with us.

Those kernel packagers *should* (be able to) tell the XFS people those answers
off hand.  If I were a developer on a major kernel subsystem project where
that actually mattered, I think I'd probably get with the kernel builders
at at least the major distros and kernel.org, and get them to tell me...

but that is a pretty far cry from my even *suggesting* that the XFS devs do
so, much less -- as it feels like Stan believes I already have -- saying that
I *expect* they should do so.

To any event that I "expect" that -- I expect it as a professional system
administrator with 30 years experience and lots of practice dealing with
systems at both the micro and macro level.  

Not as any kind of "customer".

*I* *have* read my Raymond and Moen, for all the good it's doing me. :-}

But I still do have those professional SA reflexes, and they still inform
the way that I make strategic decisions and choices about distros and 
their various components.  And not all of those decisions are strictly
technological.

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
