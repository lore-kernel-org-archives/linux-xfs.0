Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BCA3D7F3F
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 19:40:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C2428F8040
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 17:40:43 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZUBm5idmUhJR1SJC for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 17:40:20 -0800 (PST)
Date: Mon, 9 Dec 2013 12:40:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Sudden File System Corruption
Message-ID: <20131209014002.GP31386@dastard>
References: <52A03513.6030408@hardwarefreak.com>
	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>
	<CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>
	<52A191BA.20800@hardwarefreak.com>
	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>
	<52A302A9.9050509@hardwarefreak.com>
	<CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>
	<52A401FF.9050506@hardwarefreak.com>
	<20131208160339.5c45ab91@galadriel.home>
	<52A5159F.2060309@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A5159F.2060309@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mike Dacre <mike.dacre@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Dec 08, 2013 at 06:58:07PM -0600, Stan Hoeppner wrote:
> On 12/8/2013 9:03 AM, Emmanuel Florac wrote:
> > Le Sat, 07 Dec 2013 23:22:07 -0600 vous =E9criviez:
> > =

> >>> Thanks for the great advice, I think you are on to something
> >>> there.  I will  =

> >>
> >> You're welcome.  Full disclosure:  I should have mentioned that I
> >> haven't used CacheCade yet myself.  My statements WRT performance are
> >> based on available literature and understanding of the technology.
> > =

> > I didn't test thoroughly cachecade though I have a license code
> > somewhere, however I've used the equivalent Adaptec feature and one SSD
> > roughly double the IOPS of a RAID-6 array of 15k RPM SAS drives from
> > about 4200 IOPS to 7500 IOPS.
> =

> Emmanuel do you recall which SSD you used here?  7500 IOPS is very low
> by today's standards.  What I'm wondering is if you had an older low
> IOPS SSD, or, a modern high IOPS rated SSD that performed way below its
> specs in this application.

It's most likely limited by the RAID firmware implementation, not
the SSD.

> =

> The Samsung 840 Pro I recommended is rated at 90K 4K write IOPS and
> actually hits that mark in IOmeter testing at a queue depth of 7 and
> greater:
> http://www.tomshardware.com/reviews/840-pro-ssd-toggle-mode-2,3302-3.html

Most RAID controllers can't saturate the IOPS capability of a single
modern SSD - the LSI 2208 in my largest test box can't sustain much
more than 30k write IOPS with the 1GB FBWC set to writeback mode,
even though the writes are spread across 4 SSDs that can do about
200k IOPS between them.

> Its processor is a 3 core ARM Cortex R4 so it should excel in this RAID
> cache application, which will likely have gobs of concurrency, and thus
> a high queue depth.

That is probably 2x more powerful as the RAID controller's CPU...

> Found a review of CacheCade 2.0.  Their testing shows near actual SSD
> throughput.  The Micron P300 has 44K/16K read/write IOPS and their
> testing hits 30K.  So you should be able to hit close to ~90K read/write
> IOPS with the Samsung 840s.
> =

> http://www.storagereview.com/lsi_megaraid_cachecade_pro_20_review

Like all benchmarks, take them with a grain of salt. There's nothing
there about the machine that it was actually tested on, and the data
sets used for most of the tests were a small fraction of the size of
the SSD (i.e. all the storagemark tests used a dataset smaller than
10GB, and the rest were sequential IO).

IOW, it was testing SSD resident performance only, not the
performance you'd see when the cache is full and having to page
random data in and out of the SSD cache to/from spinning disks.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
