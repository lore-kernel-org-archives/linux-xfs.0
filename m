Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0U0lOeG178815 for <xfs@oss.sgi.com>; Sun, 29 Jan 2012 18:47:25 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QOxpirqCv1135xHT for <xfs@oss.sgi.com>;
	Sun, 29 Jan 2012 16:47:20 -0800 (PST)
Date: Mon, 30 Jan 2012 11:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Dave's presentation at Linux.Conf.Au 2012
Message-ID: <20120130004717.GH15102@dastard>
References: <4F24949E.2090108@hardwarefreak.com>
	<201201290838.52497.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201201290838.52497.Martin@lichtvoll.de>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On Sun, Jan 29, 2012 at 08:38:52AM +0100, Martin Steigerwald wrote:
> Am Sonntag, 29. Januar 2012 schrieb Stan Hoeppner:
> > http://www.phoronix.com/scan.php?page=3Dnews_item&px=3DMTA0NzM
> > (I don't care for the Phoronix title or summary)
> > =

> > I really enjoyed your presentation Dave.  It's also nice to finally put
> > a face and voice to a name.
> =

> Yes, I enjoyed it as well, although I mainly read the LWN summary about i=
t =

> without watching it completely yet.
> =

> Since then I wonder whether it might be good to replace the Ext4 for /hom=
e =

> on the Intel SSD 320 in my ThinkPad T520 with Intel i5 Dualcore (+ HT) by =

> XFS again. I didn=B4t use XFS initially specifically due to the lower =

> metadata performance

If ext4 works well enough for you, then there is no compelling
reason to change to XFS. If it ain't broke.....

> and due to that to my knowledge only Ext4 implements =

> the rename-case workaround for delayed allocation.

I'm pretty sure ext4 copied all the "flush it faster" fixes to work
around the zero-length files problem from XFS in the first place....
;)

> I will put various informations and a link to the lwn.net article =

> regarding his presentation [1] - which I prefer over the Phoronix article =

> the headline of the later appears lurid to me, well that appears to be =

> Michael=B4s style, maybe he thinks he attracts more visitors this way - i=
nto =

> my Linux performance analysis & tuning training.

I can't say that I like the way Phoronix presented it, either, but
that's Phoronix for you.  Indeed, people even complain about it in
the forums:

http://phoronix.com/forums/showthread.php?68388-XFS-Developer-Takes-Shots-A=
t-Btrfs-EXT4

The Phoronix forum has the usual trolls of "XFS zero's files when it
crashes" and "XFS corrupted data back in 2000 so I'll never use it
again" whenever XFS is mentioned. And it doesn't have the SNR of the
LWN article comments, so it's not really a place worth visiting or
caring that much about, IMO.

> [1] XFS: the filesystem of the future?, https://lwn.net/Articles/476263/ =

> (if not subscribed you need to wait till February 2, 2012)

It's been up for more than a week now, so I don't think Jon will
mind if it post this link for everyone on the list to read now if
they haven't already:

http://lwn.net/SubscriberLink/476263/1d75cb4eb1af8868/

If you don't already subscribe to LWN, then getting early access to
this sort of article is why you should subscribe. ;)

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
