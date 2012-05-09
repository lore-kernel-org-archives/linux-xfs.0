Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q497ZBEO079559 for <xfs@oss.sgi.com>; Wed, 9 May 2012 02:35:12 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8EEcdEDOej7JssY4 for <xfs@oss.sgi.com>;
	Wed, 09 May 2012 00:35:09 -0700 (PDT)
Date: Wed, 9 May 2012 17:35:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120509073507.GQ5091@dastard>
References: <20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507225944.GA5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120507225944.GA5091@dastard>
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
To: Juerg Haefliger <juergh@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, May 08, 2012 at 08:59:44AM +1000, Dave Chinner wrote:
> On Sat, May 05, 2012 at 09:44:35AM +0200, Juerg Haefliger wrote:
> > >> But better would be to use the device number of the relevant
> > >> filesystem to filter the events. The device is 252:2, which means in
> > >> kernel terms is it:
> > >>
> > >> =A0 =A0 =A0 =A0dev =3D (major << 20) | minor
> > >> =A0 =A0 =A0 =A0 =A0 =A0=3D 0xfc00002
> > >>
> > >> So you should be able to get just the xfs-hang events via:
> > >>
> > >> # trace-cmd record -e xfs\* -d 'dev =3D=3D 0xfc00002'
> > >>
> > >> and as long as you don't host log files on /xfs-hang, it'll only
> > >> record the workload running on the xfs-hang filesystem.
> > >
> > > Third try: https://region-a.geo-1.objects.hpcloudsvc.com:443/v1.0/AUT=
H_9630ead2-6194-40df-afd3-7395448d4536/xfs-hang/report-2012-04-27-180secs.t=
gz
> > > Filtered by device, trace events go to a different filesystem.
> > =

> > Did anybody have a chance to look at the data?
> =

> I've had a quick look, but I need to write scripts to visualise it
> (i.e. graph it) to determine if there's any pattern to the issue.

And, as expected, something unexpected popped out.

Judicious use of awk on the log space grant events shows an
interesting pattern occuring from time to time:

Transaction	 Wait queues	 Grant head	 Write Head	 Log head	 Log tail
---------------------------------------------------------------------------=
--------------
INACTIVE         empty empty     118 438024      118 438024      118 802   =
      118 697
INACTIVE         empty empty     119 20240       119 20240       118 802   =
      118 697
REMOVE           empty empty     118 438456      118 438456      118 802   =
      118 697
REMOVE           empty empty     118 438772      118 438772      118 802   =
      118 697
CREATE           empty empty     119 35872       119 35872       118 802   =
      118 697
FSYNC_TS         active empty    119 205428      119 205428      118 802   =
      118 697
FSYNC_TS         active empty    119 202944      119 202944      118 802   =
      118 697
FSYNC_TS         active empty    119 200664      119 200664      118 802   =
      118 697
REMOVE           empty empty     118 380316      118 380316      118 724   =
      118 652
INACTIVE         empty empty     118 552532      118 552532      118 724   =
      118 652
FSYNC_TS         empty empty     118 382140      118 382140      118 724   =
      118 652
INACTIVE         empty empty     118 565968      118 565968      118 724   =
      118 652
REMOVE           empty empty     119 25404       119 25404       118 802   =
      118 697
INACTIVE         active empty    119 25580       119 25580       118 802   =
      118 697

Anyone notice something fishing with the log head and tail?

That's right, they go *backwards* when a particular REMOVE
transaction is executed. That's, well, completely unexpected, and
completely breaks the assumptions made in the log space reservation
code. Essentially, the log tail ismoving backwards, and the head is
relative to the tail so moves with it.

That is *nasty*. It means that if this occurs at just the right
(wrong) time (i.e. just before a checkpoint), we can overwrite log
metadata and essentially corrupt the log. If we were to crash with
something like this active in the log, then log reocvery would fail
and or corrupt the filesystem. It is however, very hard to trigger a
crash while this conditions exists because, as you can see, it only
existed for 4 transactions - about 100uS according to the traces in
this case.

I think this has to do with how inode allocation/unlink buffers are
handled - we handle their position (via their LSN) in the AIL
specially, and I think that's affecting the in memory view of the
log tail and hence how much space is really available in the log. I
need to do more investigation to really understand the way it fails,
and write a reproducable test case, but I think I've found the
smoking gun....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
