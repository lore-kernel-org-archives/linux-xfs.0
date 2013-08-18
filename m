Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1492E7CBF
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 18:21:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0146B8F8033
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 16:21:37 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	8mKgumuYS3aEFJq2 for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 16:21:36 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id ED8E11F00526
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 19:21:35 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id 5LajqesYYV0h for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 19:21:31 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 897AA1F00523
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 19:21:31 -0400 (EDT)
Date: Sun, 18 Aug 2013 19:21:31 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <24872711.4036.1376868091485.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <52115146.6070507@gmail.com>
Subject: Re: XFS recovery resumes...
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
> From: "Joe Landman" <joe.landman@gmail.com>

> Ok. I've had power supplies take down memory in the past. You might be
> hitting a bad memory cell courtesy of the PS.

Possibly, though see below.

> >> Do you have EDAC (or mcelog) on? Any errors from this?
> >
> > I don't have mcelog on, and no, the memory isn't registered, but a
> > 4-pass run of Memtest+ came up clean, so I'm speculating that the
> 
> Not registered (which is just buffered), but ECC. ECC does a parity
> computation on some number of bits, and provides you a rough "good/bad"
> binary state of a particular area of memory. If the parity bits stored
> don't match what is computed on read, then odds are that something is
> wrong. Its not foolproof, but its a good mechanism to catch potential
> errors.

Sure.  In my experience, all ECC is registered/buffered, and no non-ECC
is, so I use it as shorthand.  No possible chance this northbridge would
do ECC, no.  :-)

> We've had cases where Memtest(*) reported everything fine, yet I was
> able to generate ECC errors in a few minutes by running a memory
> intensive app. Memtest does do some hardware exercise, but its not
> usually hitting memory the way apps do. That difference can be
> significant. This is in part why the day job stopped using memtest for
> testing a number of years ago. We now run heavy duty electronic
> structure codes, and pi/e/... computations for burn in.

Fair point.  I did also run the non-+ version of Memtest, which I
understand uses a different algorithm, and a couple other things
I found on the UBCD, so I'm *relatively* confident I don't have a
running RAM problem, though as you say, not 100%.
 
> > *continuing* problem isn't hardware; I'm pretty sure it was just the
> > failing 12V rail on the dying PS. I just have to clean up after it
> > enough to get *one* of these 2 drives cleaned off, then I can make a
> > new FS, and play musical files.
> 
> Ahhh ...
> 
> I was running a Plex server on an old machine for a while. I had to
> shift over to a beefier box with ECC ram and more CPUs. Right now my
> Plex server has 8 cpus, 24 GB RAM, and about 1TB of disk (old). Once
> you start doing recoding on the fly (multi-resolution output), you
> need the ram and processor power.
> 
> >
> > Or, I may just go grab a 3TB external after all. :-)
> 
> If you do that, and you still hit the error, chances are you might
> need to swap out your MB and CPU/RAM to something newer (not to mention the
> PS). I'd recommend ECC based systems if at all possible. Xfs can and
> will get very unhappy if bits are flipped on its data structures while
> you are making changes to the file system.

As it happens, Dave helped me clean up a mess 4 or 5 years ago, where
a *wire opened up* on the PATA cable, and all my data structures had
a missing bit.  Ghod was that a mess.

We did end up getting the drive.  So assuming I can reliably read the
big drive (I have a 3T, a 2T, and a 1T all with different problems),
I'm going to move all the files from it to the new 3T I just bought,
and then play musical files down the chain one at a time.

Thank ghod the new season hasn't started yet.  ;-)

Thanks for the help, Joe. 

Oh, and the script that Stan was so worried about?  It's all 
rm and mv commands.  5859 of them.

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
