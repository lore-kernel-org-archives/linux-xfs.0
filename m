Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L0IatJ148673 for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 19:18:37 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 019881955E59
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 17:19:34 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id 6ZWHGl10ZhsLAOwz
	for <xfs@OSS.SGI.com>; Wed, 20 Oct 2010 17:19:34 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P8isT-0001Id-4L
	for <xfs@OSS.SGI.com>; Thu, 21 Oct 2010 01:19:29 +0100
Message-ID: <19647.34574.786118.56593@tree.ty.sabi.co.uk>
Date: Thu, 21 Oct 2010 01:19:26 +0100
MIME-Version: 1.0
Subject: Re: Question/Problem: Mounting of XFS filesystem takes a lot of time
In-Reply-To: <1287593846.2338.5.camel@nukebox>
References: <1287593846.2338.5.camel@nukebox>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>


>> Check your disks. I've seen harddisks dying in that way.
>> Suddenly access times are horrible. Test random access I/O and
>> compare times, not sequential - those might still look good.

> [ ... ] When messing around with the BIOS settings (switching
> SATA mode from RAID to IDE) I get quite an obvious message
> stating that the S.M.A.R.T.  status of one of the disks is
> BAD.  Removing that disk solved the problem. [ ... ]

The suggestion about checking disk error status was good, and
relates to an important but little known detail about SATA vs. SAS
disk drives.

Usually SATA drives are pogrammed to do a large number of firmware
driven retries in case of data errors, hanging the IO subsystem,
while SAS drives, which are expected to be used in RAID sets,
don't, and report errors immediately. So called "Raid Edition"
SATA drives often behave like SAS drives in this respect.

It is often possible but usually quite awkward to change that
setting for ordinary SATA drives.

Disabling extended fw retries is usually a good idea with Linux
anyhow, as it does sw retries anyhow, and very good for drives
used in RAID sets with redundancy, to reduce latency in the case
of errors.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
