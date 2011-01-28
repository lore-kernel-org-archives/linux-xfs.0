Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S4Ck6b096828 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 22:12:46 -0600
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64901298238
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 20:15:10 -0800 (PST)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	oV3QJTNZaetx3xdf for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 20:15:10 -0800 (PST)
Received: by vxc38 with SMTP id 38so163439vxc.26
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 20:15:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D421A68.9000607@teksavvy.com>
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
	<4D41CA16.8070001@hardwarefreak.com> <4D41EA04.7010506@teksavvy.com>
	<20110128001735.GO21311@dastard> <4D421A68.9000607@teksavvy.com>
From: David Rees <drees76@gmail.com>
Date: Thu, 27 Jan 2011 20:14:50 -0800
Message-ID: <AANLkTinO1JsX_3NDHS=ew5u2C7VcCHT1Y1Yabnz=RQLO@mail.gmail.com>
Subject: Re: xfs: very slow after mount, very slow at umount
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
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>, Stan Hoeppner <stan@hardwarefreak.com>

On Thu, Jan 27, 2011 at 5:22 PM, Mark Lord <kernel@teksavvy.com> wrote:
> But I just don't know. =A0My working theory, likely entirely wrong,
> is that if I have N streams active, odds are that each of those
> streams might get assigned to different AGs, given sufficient AGs >=3D N.
>
> Since the box often has 3-7 recording streams active,
> I'm trying it out with 8 AGs now.

As suggested before - why are you messing with AGs instead of allocsize?

I suspect that with the default configuration, XFS was trying to
maximize throughput by reducing seeks with multiple processes writing
streams.

But now, you're telling XFS that it's OK to write in up to 8 different
locations on the disk without worrying about seek performance.

I think this is likely to result in overall worse performance at the
worst time - under write load.

If you are trying to optimize single thread read performance by
minimizing file fragments, why don't you simply figure out at what
point increasing allocsize stops increasing read performance?

I suspect that the the defaults do good job because even if your file
are fragmented in 64MB chunks because you have multiple streams
writing, those chunks are very likely to be very close together so
there isn't much of a seek penalty.

-Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
