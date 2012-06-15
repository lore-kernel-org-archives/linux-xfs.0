Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5FBPkad084491
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2012 06:25:47 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id 6HjRB8CbWQCtjart (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Fri, 15 Jun 2012 04:25:44 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1SfUer-0003wm-Ab
	for linux-xfs@oss.sgi.com; Fri, 15 Jun 2012 13:25:41 +0200
Received: from tc-gate1.pci.uni-heidelberg.de ([129.206.21.241])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2012 13:25:41 +0200
Received: from bernd.schubert by tc-gate1.pci.uni-heidelberg.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2012 13:25:41 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Date: Fri, 15 Jun 2012 13:25:26 +0200
Message-ID: <4FDB1BA6.3030203@itwm.fraunhofer.de>
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
	<4FD8552C.4090208@xsnews.nl> <20120614000411.GY22848@dastard>
	<4FD9F5B3.3040901@xsnews.nl> <20120615001602.GF7339@dastard>
Mime-Version: 1.0
In-Reply-To: <20120615001602.GF7339@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com
Cc: Matthew Whittaker-Williams <matthew@xsnews.nl>

On 06/15/2012 02:16 AM, Dave Chinner wrote:
> Oh, I just noticed you are might be using CFQ (it's the default in
> dmesg). Don't - CFQ is highly unsuited for hardware RAID - it's
> hueristically tuned to work well on sngle SATA drives. Use deadline,
> or preferably for hardware RAID, noop.

I'm not sure if noop is really a good recommendation even with hw raid, 
especially if the the request queue size is high. This week I did some 
benchmarks with a high rq write size (triggered with 
sync_file_range(..., SYNC_FILE_RANGE_WRITE) ) and with noop concuring 
reads then almost entirely got stalled.
With deadline read/write balance was much better, although writes still 
had been preferred (with sync_file_range() and without). I always 
thought deadline prefers reads and I hope I find some time later on to 
investigate further what was going on.
Test had been on a netapp E5400 hw raid, so rather high end hw raid.


Cheers,
Bernd



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
