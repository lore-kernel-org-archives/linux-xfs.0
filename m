Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47MxoOa209356 for <xfs@oss.sgi.com>; Mon, 7 May 2012 17:59:51 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CJ53eWCVnF3TeMzu for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 15:59:48 -0700 (PDT)
Date: Tue, 8 May 2012 08:59:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120507225944.GA5091@dastard>
References: <CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
	<20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
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

On Sat, May 05, 2012 at 09:44:35AM +0200, Juerg Haefliger wrote:
> >> But better would be to use the device number of the relevant
> >> filesystem to filter the events. The device is 252:2, which means in
> >> kernel terms is it:
> >>
> >> =A0 =A0 =A0 =A0dev =3D (major << 20) | minor
> >> =A0 =A0 =A0 =A0 =A0 =A0=3D 0xfc00002
> >>
> >> So you should be able to get just the xfs-hang events via:
> >>
> >> # trace-cmd record -e xfs\* -d 'dev =3D=3D 0xfc00002'
> >>
> >> and as long as you don't host log files on /xfs-hang, it'll only
> >> record the workload running on the xfs-hang filesystem.
> >
> > Third try: https://region-a.geo-1.objects.hpcloudsvc.com:443/v1.0/AUTH_=
9630ead2-6194-40df-afd3-7395448d4536/xfs-hang/report-2012-04-27-180secs.tgz
> > Filtered by device, trace events go to a different filesystem.
> =

> Did anybody have a chance to look at the data?

I've had a quick look, but I need to write scripts to visualise it
(i.e. graph it) to determine if there's any pattern to the issue.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
