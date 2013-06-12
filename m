Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C1CE87F53
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 12:02:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 845778F8052
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 10:02:54 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id AdxF7dd0smPve92F for
	<xfs@oss.sgi.com>; Wed, 12 Jun 2013 10:02:53 -0700 (PDT)
Date: Wed, 12 Jun 2013 10:02:52 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
Subject: Re: garbage block(s) after powercycle/reboot + sparse writes
In-Reply-To: <51AE84C9.5030903@sandeen.net>
Message-ID: <alpine.DEB.2.00.1306120955460.15386@cobra.newdream.net>
References: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
	<51AE84C9.5030903@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, david@fromorbit.com
Cc: xfs@oss.sgi.com

Hi guys,

I reproduced this on two more boxes and have more data.  The full set of 
notes/logs is at

	http://newdream.net/~sage/bug-4976/notes.txt

I stashed a copy of the ceph log and the file itself for each case too:

	http://newdream.net/~sage/bug-4976/

The new information:
 - the file was created and allocated prior to the powercycle.
 - the writes were then replayed by the ceph journaling after restart
 - garbage data appears at offsets we never wrote to

If this pattern isn't suggesting any likely theories, I could rig things 
up to try to capture the ceph log output leading up to the crash so I 
positively confirm what the sequence was leading up to the power cycle.  

Any ideas?

Thanks!
sage

On Tue, 4 Jun 2013, Eric Sandeen wrote:
> On 6/4/13 2:24 PM, Sage Weil wrote:
> > I'm observing an interesting data corruption pattern:
> > 
> > - write a bunch of files
> > - power cycle the box
> 
> I guess this part is important?  But I'm wondering why...
> 
> > - remount
> > - immediately (within 1-2 seconds) write create a file and
> 
> a new file, right?

It was created and written to (w/ the same pattern) before the crash.  We 
then repeat the sequence after when replaying the ceph journal.

> >  - write to a lower offset, say offset 430423 len 527614
> >  - write to a higher offset, say offset 1360810 len 269613
> >  (there is other random io going to other files too)
> > 
> > - about 5 seconds later, read the whole file and verify content
> > 
> > And what I see:
> > 
> > - the first region is correct, and intact
> 
> the lower offset you wrote?

Right

> > - the bytes that follow, up until the block boundary, are 0
> 
> that's good ;)
> 
> > - the next few blocks are *not* zero! (i've observed 1 and 6 4k blocks)
> 
> that's bad!
> 
> > - then lots of zeros, up until the second region, which appears intact.
> 
> the lot-of-zeros are probably holes?

Right

> What does xfs_bmap -vvp <filename> say about the file in question?

The notes.txt file linked above has the bmap output.

Thanks!
sage


> > I'm pretty reliably hitting this, and have reproduced it twice now and 
> > found the above consistent pattern (but different filenames, different 
> > offsets).  What I haven't yet confirmed is whether the file was written at 
> > all prior to the powercycle, since that tends to blow away the last 
> > bit of the ceph logs, too.  I'm adding some additional checks to see 
> > whether the file is in fact new when the first extent is written.
> > 
> > The other possibly interesting thing is the offsets.  The garbage regions 
> > I saw were
> > 
> >  0xea000 - 0xf0000
> 
> 234-240 4k blocks
> 
> >  0xff000 - 0x100000
> 
> 255-256 4k blocks  *shrug*
> 
> Is this what you saw w/ the write offsets & sizes you specified above?
> 
> I'm wondering if this could possibly have to do w/ speculative preallocation
> on the file somehow exposing these blocks?  But that's just handwaving.
> 
> -Eric
> 
> > 
> > Does this failure pattern look familiar to anyone? I'm pretty sure it is 
> > new in 3.9, which we switched over to right around the time when this 
> > started happening.  I'm confirming that as well, but just wanted to see if 
> > this is ringing any bells...
> > 
> > Thanks!
> > sage
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
