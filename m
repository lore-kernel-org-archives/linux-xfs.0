Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SNwk3D227819 for <xfs@OSS.SGI.com>; Tue, 28 Feb 2012 17:58:47 -0600
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id byrqktEOw1ztRw0d for
	<xfs@OSS.SGI.com>; Tue, 28 Feb 2012 15:58:45 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D20149217F for xfs@OSS.SGI.com;
	Tue, 28 Feb 2012 23:58:42 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1S2WwH-0008PZ-Sj
	for <xfs@OSS.SGI.com>; Tue, 28 Feb 2012 23:58:37 +0000
MIME-Version: 1.0
Message-ID: <20301.27181.727405.287963@tree.ty.sabi.co.UK>
Date: Tue, 28 Feb 2012 23:58:37 +0000
Subject: Re: Poor performance using discard
In-Reply-To: <1330469778.9688.7.camel@core24>
References: <1330469778.9688.7.camel@core24>
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> /dev/mapper/ssdvg0-testLV on /media/temp type xfs
> (rw,noatime,nodiratime,discard) [ ... ] real 5m7.139s [ ... ]

> There where lockups where the system would pause for about a
> minute during the process.

> ext4 handles this scenerio fine:

> /dev/mapper/ssdvg0-testLV on /media/temp type ext4
> (rw,noatime,nodiratime,discard) [ ... ] real 0m0.943s [ ... ]

> xfs mounted without discard seems to handle this fine:

> /dev/mapper/ssdvg0-testLV on /media/temp type xfs
> (rw,noatime,nodiratime) [ ... ] real 0m1.634s [ ... ]

[ ... ]

> Any suggestions?

* Look at 'vmstat 1' while 'rm' is running.

* Learn how TRIM is specified, and thus why many people prefer
  running periodically 'fstrim' which uses FITRIM to mounting
  with 'discard'.

* Compare with my Crucial M4 flash SSD with XFS:

    #  time sh -c 'sysctl vm/drop_caches=3; rm -r linux-2.6.32; sync'
    vm.drop_caches = 3

    real    0m59.604s
    user    0m0.060s
    sys     0m3.944s

  That's pretty good for ~32k files and ~390MiB. Probably the
  TRIM implementation on the M4 is rather faster than that on
  the Patriot.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
