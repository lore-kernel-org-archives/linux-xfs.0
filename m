Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75KsYmk104158 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 15:54:34 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D85E1E40A49
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 13:54:54 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id QDHksjO6vZUllQZq for <xfs@oss.sgi.com>;
	Thu, 05 Aug 2010 13:54:54 -0700 (PDT)
Date: Thu, 5 Aug 2010 22:54:48 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Performance impact of CONFIG_SCHED_MC? direct-io test case
Message-ID: <20100805205448.GB6318@comet.dominikbrodowski.net>
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
	<20100805113240.GA29846@think>
	<20100805153519.GA7242@comet.dominikbrodowski.net>
	<20100805163519.GA6604@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100805163519.GA6604@comet.dominikbrodowski.net>
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
To: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, Valdis.Kletnieks@vt.edu, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Chris Mason <chris.mason@oracle.com>, josef@redhat.com


How large is the performance impact of CONFIG_SCHED_MC -- for which there
is a warning that it comes "at a cost of slightly increased overhead in
some places."? Well, for the test workload I've been working with lately,

dd if=<device> of=/dev/zero bs=8k count=100000 iflag=direct

where <device> is a dm-crypted LVM volume consisting of several
partitions on a notebook pata harddisk, and all this runs on a Core2 Duo,
I get a ~ 10 % performance reduction if CONFIG_SCHED_MC is enabled.

Combined with the CONFIG_DEBUG performance reduction mentioned in the other
message, all of the reduction from 28 MB/s to 18 MB/s is explained for.

Best,
	Dominik

PS: Ingo: you got both mingo@elte.hu and mingo@redhat.com in MAINTAINERS,
I suppose both are valid?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
