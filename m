Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O7UR2x115829 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 02:30:28 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD7CA13EC15B
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 00:31:11 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 5SQTZ1R1vRWJKizS for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 00:31:11 -0700 (PDT)
Date: Fri, 24 Jul 2009 09:30:30 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
Message-ID: <20090724073030.GA15785@citd.de>
References: <4A691B2D.1090600@sandeen.net> <C68EA385.B8CE%elbles@sessys.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <C68EA385.B8CE%elbles@sessys.com>
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
To: Sean Elble <elbles@sessys.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 23.07.2009 23:32, Sean Elble wrote:
> On 7/23/09 10:23 PM, "Eric Sandeen" <sandeen@sandeen.net> wrote:
> 
> > Sean Elble wrote:
> >> Hi all,
> >> 
> >> While I am aware that the current kernel implementation of XFS doesn't
> >> support mounting an IRIX filesystem with version 1 directories, I'm not so
> >> sure whether xfsdump/xfsrestore will support the dumping of an IRIX
> >> filesystem with version 1 directories.  To be more specific, I am dealing
> >> with an old disk from an Indigo2, running IRIX 6.5.6m with version 1
> >> (0x1094) directories.  I was hoping it had version 2 directories, but after
> >> finding an old SCSI card I could put in a Linux box with XFS support, I
> >> found just the opposite, obviously.  I had the old SCSI card back in its
> >> donor system (which was up-and-running) when it occurred to me that
> >> xfsdump/xfsrestore *might* be a possibility, and I can't take it (the donor
> >> system) down again unless I know I can make this work.
> >> 
> >> If anyone can give me an answer to this question, I would certainly
> >> appreciate it.  I didn't see anything in the man pages, and my Google
> >> searches have proven fruitless thus far, but I've been known to be blind on
> >> occasion.  :-)  Thanks, in advance.
> >> 
> > 
> > linux used to work with v1 dirs, though there were some problems.  It
> > never got fixed, was not critical for 99.9% of users, and got taken out.
> >  But it might work well enough to do what you need.  Go through the
> > changelogs or google, and try an older Linux kernel, perhaps ....
> > 
> > -Eric
> > 
> 
> Looks like the version 1 directory code was removed as of June 15th, 2006,
> per this:
> 
> http://oss.sgi.com/archives/xfs/2006-06/msg00067.html
> 
> But another post <http://oss.sgi.com/archives/xfs/2003-07/msg00495.html> has
> a 2.4.21 kernel being used with a patch, so I'm not sure if I want to try a
> 2.6 kernel, or see if I can patch together a 2.4.x kernel on an old FC4 box
> I have laying around.  Truth be told, it's a lot of work just to blank the
> entries in /etc/shadow so I can login to a 150 MHz box again, so who knows
> if I'll even try at this point, hah.
> 
> In any event, thanks a lot for the pointers in the right direction.

I'd guess the disc isn't very big.

You just dd it completly (for backup).

Then search for the content of the shadow-file and blank out the entry 
with a hex-editor. Make sure that you don't change the filesize, pad 
the previous/following entry with any character you have to remove.






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
