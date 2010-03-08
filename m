Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o28NstEm083938 for <xfs@oss.sgi.com>; Mon, 8 Mar 2010 17:54:55 -0600
Received: from rcsinet12.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4ACC4225E13
	for <xfs@oss.sgi.com>; Mon,  8 Mar 2010 15:56:23 -0800 (PST)
Received: from rcsinet12.oracle.com (rcsinet12.oracle.com [148.87.113.124]) by
	cuda.sgi.com with ESMTP id mXogPHuDWxitY8TZ for
	<xfs@oss.sgi.com>; Mon, 08 Mar 2010 15:56:23 -0800 (PST)
Subject: Re: What are the correct mkfs.xfs parameters for a lying WD-EARS HDD?
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20100308221044.GA17830@citd.de> <4B957E03.9090000@sandeen.net>
Date: Mon, 08 Mar 2010 18:55:55 -0500
In-Reply-To: <4B957E03.9090000@sandeen.net> (Eric Sandeen's message of "Mon,
	08 Mar 2010 16:45:23 -0600")
Message-ID: <yq1vdd68j1w.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

>>>>> "Eric" == Eric Sandeen <sandeen@sandeen.net> writes:

Eric> Make sure your partitions, if any, are on 4k boundaries.(*) older
Eric> fdisk at least won't do this by default, not sure about parted.

You can use the expert mode in fdisk to ensure that the partition begins
on a 4KB boundary.


Eric> (*)unless the drive has an offset to make 512-sector 63 line up on
Eric> a nice boundary... in which case I guess you could experiment with
Eric> perf both ways to be sure...

EARS is the one that's lying about the physical block size.  It's
zero-aligned unless somebody messed with the jumper.

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
