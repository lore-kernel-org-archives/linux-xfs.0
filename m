Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RIYUaV199594 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 13:34:31 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02CD21D94FC3
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:35:27 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id ovM8TuJfQ0tD9dWp for
	<xfs@oss.sgi.com>; Mon, 27 Sep 2010 11:35:27 -0700 (PDT)
Date: Mon, 27 Sep 2010 20:35:16 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Contiguous file sequences
Message-ID: <20100927183516.GA18458@citd.de>
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
	<4C9A6298.106@sandeen.net>
	<AANLkTinz4rYCb8cHH69pYy-oPT-041y+DmVaWm3N_1hu@mail.gmail.com>
	<4CA018D9.1030803@sandeen.net>
	<AANLkTi=xPjAtjP5E6XK8Xhgvo1FoqAEUKLvDrNJO3-OH@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=xPjAtjP5E6XK8Xhgvo1FoqAEUKLvDrNJO3-OH@mail.gmail.com>
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
To: Daire Byrne <daire.byrne@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 27.09.2010 17:30, Daire Byrne wrote:
> Eric,
> =

> On Mon, Sep 27, 2010 at 5:08 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > Daire Byrne wrote:
> >>> Why is this the goal, what are you trying to achieve?
> >>
> >> I am essentially trying to play back a large frame sequence and trying
> >> to minimise seeks as it can lead to sporadic slowdowns on a SATA based
> >> RAID.
> >
> > Ok - and you've really seen allocation patterns that cause the playback
> > to slow down? =A0xfs_bmap information for a few sequential files that w=
ere
> > this far off would be interesting to see.
> >
> > Are you certain that it's seekiness causing the problem? =A0A great way
> > to visualize it would be to use the seekwatcher application while you
> > run a problematic file sequence.
> =

> I'm certain that the seekiness is the culprit. The image files are
> pretty big and require 400MB/s+ speeds to play them back at full rate.
> I can play a sequence which is aligned perfectly on disk just fine
> (readahead) but when seeks are required between frames the framerate
> drops noticeably. I'm using SATA disks which probably doesn't help
> matters.

As long as the disc-subsystem can sustain more than 400MB/s, there is a =

way to do "poor men's mega readahead".

I assume the sequence in which the files are accessed is predetermined =

and RAM is plentiful?

Then you can write a program/script that utilizes inotify to identify =

the file that is currently read and reads, say, 15 frames ahead, =

assuming that the sequence has 30fps the physical disc access is then =

about 1/2 a second ahead of time.

Of course the disc-subsystem has to be able to do bursts of more than =

400MB/s, so that when there is "stuttering" it can catch up before the =

"buffer runs empty".

A solution with a guarantee that the files stay in RAM could be done =

with a tmpfs. Depending on the playing program you may have to fake a =

little, but either sparse-files or symlinks should do the trick to have =

every file visible and replacing it with the real file/content a little =

before it is used and droping it afterwards.





Bis denn

-- =

Real Programmers consider "what you see is what you get" to be just as =

bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, =

cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
