Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 421417CA0
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 18:08:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7240AC003
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 16:08:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iZy7zLLs65BVRHWH for <xfs@oss.sgi.com>;
	Sun, 31 Jul 2016 16:08:04 -0700 (PDT)
Date: Mon, 1 Aug 2016 09:08:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Any better way to interact with xfs?
Message-ID: <20160731230801.GG16044@dastard>
References: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
	<CAOQ4uxiOavjc+wrRQHW8U16EDocNRRGnM24a7d6dhO8tzV0a1w@mail.gmail.com>
	<20160729022552.GA16044@dastard>
	<CAOQ4uxiJ9yNyJhyEoTPrqJ0F-HcJz6hagio1K_pxVPPQiDC=KQ@mail.gmail.com>
	<20160731003431.GF16044@dastard>
	<CAOQ4uxjidXm-BLEsw0mumk92NC9haZJtKEg=P0hE_ycqhnrSDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjidXm-BLEsw0mumk92NC9haZJtKEg=P0hE_ycqhnrSDQ@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: Ryan Lindsay <rlindsay@unimelb.edu.au>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Jul 31, 2016 at 09:12:23AM +0300, Amir Goldstein wrote:
> On Sun, Jul 31, 2016 at 3:34 AM, Dave Chinner <david@fromorbit.com> wrote:
> > i.e. it's all the same coherency issues that we have with multiple
> > NFS clients modifying the same file concurrently. They don't know
> > what each other are doing, and so modifications are going to get
> > lost or be overwritten incorrectly....
> 
> All the disclaimers above are very important for the administrator to know.

Administrator != developer.

These are things a filesystem tool developer would need to know.
They are far, far outside the realm of what a system administrator
needs to know or wants to care about.

> But I believe that the answer to Ryan's original question is:
> Yes, there is a way of interacting at the file system level to
> facilitate a change
> of UID's on files rather than having to just chown recursively down
> the file system.

It's not supported - you'll get to keep all the broken bits to
yourself if you do something like this. You get to handle all the
undocumented wacky corner cases yourself, like unlinked inodes,
inodes that the scan misses because they were created in a region
already scanned before the bulkstat completes, handling partial
completion failures, invalidation of all your backups because they
can't obviously detect that changes have been made, etc.

> I'm not sure how much faster it is going to be and whether anyone
> would want to invest time in writing this bulkchown tool, but it
> is definitely going to reduce Ryan's system downtime.

Is it, though? You say it like it's an unconditional win, but that's
nt necessarily true. i.e. if directory travesal isn't the limiting
factor (e.g. single threaded chown process is the limiting factor),
then simply running concurrent chowns is will be the fastest and
simplest method to scale this out.

> Please correct me if I am wrong.

Bulkstat is not a general purpose API. You can use it if you want
to, but if you don't understand /exactly/ what it is providing, then
the application that uses it wll be buggy and quite possibly
dangerous to the user's data and/or filesystem structure.

You're welcome to play russian roulette with your own filesystems,
but please don't advocate that others should do play along with
you...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
