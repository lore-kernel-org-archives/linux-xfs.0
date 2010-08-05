Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o75KsYHE104159 for <xfs@oss.sgi.com>; Thu, 5 Aug 2010 15:54:34 -0500
Received: from linta.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58AF01E40A47
	for <xfs@oss.sgi.com>; Thu,  5 Aug 2010 13:54:54 -0700 (PDT)
Received: from linta.de (isilmar-3.linta.de [188.40.101.200]) by cuda.sgi.com
	with ESMTP id 0cqRXy2JVxfCaEhX for <xfs@oss.sgi.com>;
	Thu, 05 Aug 2010 13:54:54 -0700 (PDT)
Date: Thu, 5 Aug 2010 22:47:49 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Performance impact of CONFIG_DEBUG? direct-io test case
Message-ID: <20100805204749.GA6318@comet.dominikbrodowski.net>
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


How large is the performance impact of CONFIG_DEBUG? Well, for the test
workload I've been working with lately,

dd if=<device> of=/dev/zero bs=8k count=100000 iflag=direct

where <device> is a dm-crypted LVM volume consisting of several
partitions on a notebook pata harddisk, I get the following results:

1) best results are ~ 28 MB/s

2) Enabling CONFIG_DEBUG_LOCK_ALLOC, which also means CONFIG_LOCKDEP
   being enabled, causes the transfer rate to decrease by ~ 1.2 MB/s

3) Enabling CONFIG_DEBUG_SPINLOCK && CONFIG_DEBUG_MUTEXTES or
   CONFIG_DEBUG_SPINLOCK_SLEEP=y costs about ~ 0.4 MB/s each

4) Enabling all of the following options:
	CONFIG_DEBUG_RT_MUTEXES
	CONFIG_DEBUG_PI_LIST
	CONFIG_PROVE_LOCKING
	CONFIG_LOCK_STAT
	CONFIG_DEBUG_LOCKDEP
   costs another ~ 5 MB/s.

So, for this test case, the performance impact of (some) CONFIG_DEBUG
options is highly significant, here by about 25 %.

Best,
	Dominik

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
