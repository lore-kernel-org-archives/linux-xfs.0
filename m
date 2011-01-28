Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S1KQCS068136 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 19:20:27 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70FF889D437
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 17:22:50 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.183]) by cuda.sgi.com with ESMTP id
	KBB9HGqFdt7SaBWy for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 17:22:50 -0800 (PST)
Message-ID: <4D421A68.9000607@teksavvy.com>
Date: Thu, 27 Jan 2011 20:22:48 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com>
	<4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard>
In-Reply-To: <20110128001735.GO21311@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>

On 11-01-27 07:17 PM, Dave Chinner wrote:
>
> In my experience with XFS, most people who tweak mkfs parameters end
> up with some kind of problem they can't explain and don't know how
> to solve. And they are typically problems that would not have
> occurred had they simply used the defaults in the first place. What
> you've done is a perfect example of this.

Maybe.  But what I read from the paragraph above,
is that the documentation could perhaps explain things better,
and then people other than the coders might understand how
best to tweak it.

> Why 8 AGs and not the default?

How AGs are used is not really explained anywhere I've looked,
so I am guessing at what they do and how the system might respond
to different values there (that documentation thing again).

Lacking documentation, my earlier experiences suggest that more AGs
gives me less fragmentation when multiple simultaneous recording streams
are active.  I got higher fragmentation with the defaults than with
the tweaked value.

Now, that might be due to differences in kernel versions too,
as things in XFS are continuously getting even better (thanks!),
and the original "defaults" assessment was with the kernel-of-the-day
back in early 2010 (2.6.34?), and now the system is using 2.6.37.

But I just don't know.  My working theory, likely entirely wrong,
is that if I have N streams active, odds are that each of those
streams might get assigned to different AGs, given sufficient AGs >= N.

Since the box often has 3-7 recording streams active,
I'm trying it out with 8 AGs now.

Cheers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
