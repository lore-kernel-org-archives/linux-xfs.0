Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 162477F54
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 18:56:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC4A18F8059
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 16:56:07 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mbnmxGl1a7XAcun3 for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 16:56:06 -0700 (PDT)
Date: Wed, 18 Jun 2014 09:55:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/013: allow non-write fsstress operations in
	background workload
Message-ID: <20140617235546.GY4453@dastard>
References: <1401820129-6543-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1401820129-6543-1-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jun 03, 2014 at 02:28:49PM -0400, Brian Foster wrote:
> It has been reported that test xfs/013 probably uses more space than
> necessary, exhausting space if run against a several GB sized ramdisk.
> xfs/013 primarily creates, links and removes inodes. Most of the space
> consumption occurs via the background fsstress workload.
> 
> Remove the fsstress -w option that suppresses non-write operations. This
> slightly reduces the storage footprint while still providing a
> background workload for the test.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

This change makes the runtime blow out on a ramdisk from 4s to over
ten minutes on my test machine. Non-ramdisk machines seem to be
completely unaffected.

I was going to say "no, bad change", but I noticed that my
spinning disk VMs weren't affected at all. Looking more closely,
xfs/013 is now pegging all 16 CPUs on the VM. The profile:

-  60.73%  [kernel]  [k] do_raw_spin_lock
   - do_raw_spin_lock
      - 99.98% _raw_spin_lock
         - 99.83% sync_inodes_sb
              sync_inodes_one_sb
              iterate_supers
              sys_sync
              tracesys
              sync
-  32.76%  [kernel]  [k] delay_tsc
   - delay_tsc
      - 98.43% __delay
           do_raw_spin_lock
         - _raw_spin_lock
            - 99.99% sync_inodes_sb
                 sync_inodes_one_sb
                 iterate_supers
                 sys_sync
                 tracesys
                 sync

OK, that's a kernel problem, not a problem with the change in the
test...

/me goes and dusts off his "concurrent sync scalability" patches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
