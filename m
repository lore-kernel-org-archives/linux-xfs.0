Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7G2QGXq212279 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 21:26:16 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30F2E170EF06
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 19:26:41 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id iCCfhV4Zod8GEECH for
	<xfs@oss.sgi.com>; Sun, 15 Aug 2010 19:26:41 -0700 (PDT)
Message-ID: <4C68A1CC.4050206@tlinx.org>
Date: Sun, 15 Aug 2010 19:26:20 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs.fsck change that is unhelpful
References: <4C670101.8050901@tlinx.org> <20100815005240.GH10429@dastard>
	<4C674AE8.7030107@tlinx.org> <20100816015505.GJ10429@dastard>
In-Reply-To: <20100816015505.GJ10429@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Sat, Aug 14, 2010 at 07:03:20PM -0700, Linda Walsh wrote:
>> 	It was long a *feature* of xfs, that xfs.fsck, was a noop.
> 
> It wasn't a feature - it was simply to ensure that initscripts
> worked. There was simply no reason for it to do anything else until
> someone discovered that their booot problems were caused by
> non-standard behaviour. i.e.  fsck wasn't catching non-existent
> devices and telling the init scripts...
----
	Fine.  If it's required to be break at the slightest
provocation, then great. (*fume*)

	I'd love to see that logic applied to any system that's
supposed to be reliable -- like the human body.  Scrape a finger.  
Sorry -- can't gain consciousness.  Must forever remain dormant until
someone fixes my scraped finger.  

	I found the computer coming up to a point where I could 
remotely log into it and fix the problem to be useful far more often
than I've found it to be when it demands I sit at the console using
a limited tool set to repair some damage left over after some upgrade
or installation.

	It's a pathological condition in either case.  My preference
is to have it "do it's best", and not give up like a petulant child if
all the t's are not crossed and all the i's are not dotted just so.
That's why computers break so easily.  I feel it is better design to have
them try to do what is intended -- even if limpingly.  

	But it is required for 'init'(5) scripts -- which, apparently
are on their way out and possibly won't be used to start the machine in
the next SuSE release.  Perhaps the 'fall over and die' mentality is
part of that decision -- and FWIW, please don't take any of my words as
directed against *people*, involved in implementing the maladaptive behavior.
I realize there is a job that must be done.  I just don't always agree
with a 1970's - 1980's era computer design philosphy that says give up at the
first error.

	It only bites me when I've done some measure upgrade or install and haven't
patched fsck -> /bin/true yet -- which I only do for XFS, because for XFS, it's
the best possible action to take.  If the device isn't there.  It won't be mounted.
If it really is critical to the system booting up, then the system will be stopped
later.  But on the off chance that /usr, /etc, /tmp...etc, are ok, the system might
come up into some state where it can be remotely diagnosed and fixed.  

	I *LOVE* XFS, because I know it won't leave me hung out to dry during a 
boot due to a failed fsck.  So if init scripts need such broken mentality, I
just need to remember to 1) patch it, and 2) as others have pointed out -- make changes
in the system state, so that a missing file system won't prevent bootup.

	That said -- how many people, who have their /home or /usr/people partition
'local' to their machine, automount it?  I admit to thinking of the fsck field as having
some meaning in the order in which file systems are mounted.  I guess that order is
random now, though how I'm supposed to tell mount that '/home needs to be mounted
only after "/", but need to be mounted before /home/share, without some ordering
in fstab is something that is supposed to be specified....where?


	I.e. isn't that field also the order in which file systems are mounted, or
is there some other place that order is maintained other than in fstab?

	Sorry, am definitely showing my ignorance in this area.

	
Linda

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
