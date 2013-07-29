Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2430C7F37
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 19:00:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97BEBAC002
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 17:00:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	nnvzbzhTxPz09c4T for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 17:00:32 -0700 (PDT)
Date: Mon, 29 Jul 2013 10:00:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
Message-ID: <20130729000000.GZ13468@dastard>
References: <52C3E9E6-61DD-4537-9A64-C8CBFC86F6E3@gmail.com>
	<31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
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
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On Sat, Jul 27, 2013 at 10:21:34PM -0400, Jay Ashworth wrote:
> ----- Original Message -----
> > From: "aurfalien" <aurfalien@gmail.com>
> 
> > If it RHEL/CentOS really is the only option, then perhaps get one box
> > on RHEL and submit bugs for it.
> 
> Sure, but "submit bugs" was a straw man the entire time  The OP wasn't talking
> about how and where to submit bugs, and neither was I.
> 
> The OP was trying to determine how he got from Distro/Kernel Version to
> XFS checkout ID, so that he could *talk to the XFS devs* about his problem.
> 
> And no one had a straight answer for him, which straight answer *is*:
> 
> "You have to talk to whomever builds the kernel packages for the distro 
> you're working on; they should be able to tell you which XFS {version|
> release|checkout} is built into that particular kernel RPM."

I gave a straight answer: you have to look at the kernel source
package that ships with the distro.

> From there, we veered *very* close to "we don't talk to people unless 
> they're paying Red Had customers", and I'm relatively certain that was
> *not* the takeaway Dave was aiming for with us.

Yup, nothing quite like geting quoted out of context, is there?
I said CentOS is downstream of RHEL, and so the only way to
influence it's content in terms of bug fixes and documentation is to
get changes into RHEL. And getting changes and documentation into
RHEL requires $$$.....

Fundamentally, I don't care what distro you use. If you've got a
bug, I'll try to find it and fix it. That's my responsibility to the
wider XFS community. If you want me to implement or document
something for you, then you need to provide some incentive for me to
do that. Red Hat provides a lot of incentive for me - they pay my
bills.

But asking me to document something already documented in code and
git, for multiple different code bases? What's my incentive? There
isn't any from a RH POV, nor is there any from a monetary POV. And
it]ll be boring work, so there's no intellectual incentive, either.
So, tell me, why should I do what you ask?

That's the down side to open-source software - if nobody wants to
scratch the same itch as you need scratched, then only you can
scratch it. Hell, if you really wanted to be useful, you'd go and
document what you know already and propose it for inclusion into the
kernel documentation. Then we'd review it, you'd correct it, and you
would have improved the state of the code for everyone.

That's how open source software works. Not by demanding other people
do something for you, but doing stuff yourself and providing the
fruits of your labour to the wider benefit of the community.

> If I were a developer on a major kernel subsystem project where
> that actually mattered, I think I'd probably get with the kernel builders
> at at least the major distros and kernel.org, and get them to tell me...

I think you'll find in that case most kernel developers say "please
reproduce on a current, unmodified mainline kernel" and so don't
have to care one bit about what is in the distro kernel. Then they
find and fix the bug in the mainline kernel - getting that fix onto
the user's machines is the user's problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
