Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 362AF29E11
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 16:45:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9CADAC001
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:45:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qAFhpPcOEwLxEqrg for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 14:45:53 -0700 (PDT)
Message-ID: <51F2EE0F.4060305@sandeen.net>
Date: Fri, 26 Jul 2013 16:45:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: understanding speculative preallocation
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
In-Reply-To: <CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
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
To: Jason Rosenberg <jbr@squareup.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On 7/26/13 3:38 PM, Jason Rosenberg wrote:
> Hi Stan,
> 
> Thanks for the info (most of it was, in fact, news to me). I'm an
> application developer trying to debug a disk space problem, that's
> all. So far, I've tracked it down to being an XFS issue.
> 
> So you are saying there's no public information that can correlate
> XFS versioning to CentOS (or RHEL) versioning?
> 
> Sad state of affairs.
> 
> If anyone can volunteer this info (if available to you) I'd be much
> appreciative.
> 
> Regardless, is there a version history for XFS vis-a-via mainline
> Linux?

There is no exact version history per se, ie. no "XFS version 2.51"

Instead, the best point of reference upstream is the kernel release number,
i.e. kernel 2.6.32, kernel 3.2, etc.  Ben pointed you at changelogs
for that, which you can peruse...

Once you get into RHEL, you're into a land of backports - originally
2.6.32, but various & sundry updates & backports, to the point where
it is a bit of a special snowflake, based on the requirements of RHEL
customers and the RHEL maintainers (who, incidentally, are also major
upstream XFS developers).

Your best bet for a distro kernel is to look at i.e. the kernel RPM
changelog to see what's been going on.  But you won't be able
to correlate that exactly with any one upstream version, unless maybe
you see a "rebase $SUBSYSTEM to $KERNEL_VERSION" code type changelog.

Back to your original problem, you may find that just setting a fixed
allocsize as a mount option has more pros than cons for your usecase.

HTH,

-Eric

> Thanks,
> 
> Jason
> 
> 
> On Fri, Jul 26, 2013 at 3:27 PM, Stan Hoeppner <stan@hardwarefreak.com <mailto:stan@hardwarefreak.com>> wrote:
> 
>     On 7/26/2013 12:40 PM, Jason Rosenberg wrote:
> 
>     > Anyway, I'm surprised that you don't have some list or other way to
>     > correlate version history of XFS, with os release versions.  I'm guessing
>     > the version I have is not using the latest/greatest.  We actually have
>     > another system that uses an older version of the kernel (2.6.32-279), and
> 
>     2.6.32-279  - this is not a mainline kernel version.  This is a Red Hat
>     specific string describing their internal kernel release.  It has zero
>     correlation to any version number of anything else in the world of
>     mainline Linux.
> 
>     > If, say you tell me, the mainline xfs code has improved behavior, it would
>     > be nice to have a way to know which version of CentOS might include that?
> 
>     IMNSHO, CentOS is a free proprietary chrome plated dog turd.  It's
>     flashy on the outside and claims it's "ENTERPRISE", "just like RHEL!".
>     Then you crack it open and find nothing but crap inside.  So you take it
>     back to the store that gave it away for free and the doors are barred,
>     the place out of business.  The chrome has peeled off and you're stuck
>     with crap that difficult to use.  Every time you touch it you get dirty
>     in some fashion.
> 
>     RHEL is a proprietary solid chrome turd you pay for.  You can't get to
>     the inside, but if you find a scratch and 'return' it Red Hat will say
>     "we can help you fix that".
> 
>     If you avoid the flashy turds altogether while still plunking down no
>     cash, and use a distro based entirely on mainline Linux and GNU user
>     space source, you can get help directly from the folks who wrote the
>     code you're running because they know what is where.  Whether it be
>     Linux proper, the XFS subsystem, NFS, Samba, Postix, etc.  Such
>     distributions are too numerous to mention.  None of them are chrome
>     plated, none claim to be "just like ENTERPRISE distro X".  I tell all
>     users of RHEL knock offs every time I see a situation like this:
> 
>     Either pay for and receive the support that's required for the
>     proprietary distribution you're running, or use a completely open source
>     distro based on mainline kernel source and GNU user space.  By using a
>     RHEL knock off, you're simply locking yourself into an outdated
>     proprietary code base for which there is no viable support option,
>     because so few people in the community understand the packaging of the
>     constituent parts of the RHEL kernels.  This is entirely intentional on
>     the part of Red Hat, specifically to make the life of CentOS users
>     painful, and rightfully so.
> 
>     FYI, many of the folks on the XFS list are Red Hat employees, including
>     Dave.  They'll gladly assist RHEL customers here if needed.  However, to
>     support CentOS users, especially in your situation, they'd have to use
>     Red Hat Inc resources to hunt down the information related to the CentOS
>     kernel you have that correlates to the RHEL kernel it is copied from.
>     So they've just consumed Red Hat Inc resources to directly assist a free
>     competitor who copied their distro.
> 
>     Thus there's not much incentive to assist CentOS users as they'd in
>     essence be taking money out of their employer's pocket.  Taken to the
>     extreme this results in pay cuts, possibly furloughs or pink slips, etc.
> 
>     Surely this can't be the first time you've run into a free community
>     support issue with the CentOS kernel.  Surely what I've written isn't
>     news to you.  Pay Red Hat for RHEL, or switch to Debian, Ubuntu, Open
>     Suse, etc.  Either way you'll be able to get much better support.
> 
>     --
>     Stan
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
