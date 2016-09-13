Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5106 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750940AbcIMVPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Sep 2016 17:15:07 -0400
Date: Wed, 14 Sep 2016 07:15:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: make xfs btree stats less huge
Message-ID: <20160913211502.GH30497@dastard>
References: <1473755322-883-1-git-send-email-david@fromorbit.com>
 <20160913090657.gz75xuhjhb6645sd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160913090657.gz75xuhjhb6645sd@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 13, 2016 at 11:06:57AM +0200, Carlos Maiolino wrote:
> On Tue, Sep 13, 2016 at 06:28:42PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Embedding a switch statement in every btree stats inc/add adds a lot
> > of code overhead to the core btree infrastructure paths. Stats are
> > supposed to be small and lightweight, but the btree stats have
> > become big and bloated as we've added more btrees. It needs fixing
> > because the reflink code will just add more overhead again.
> 
> Talking about stats, is there any documentation for that? I was using the log
> stats while working on the fail_at_unmount hang, and I couldn't find anything
> other than looking into the code to see what each number means.

Most XFS stats are documented in PCP. IIRC, this page was originally
pulled from the PCP metric info but is now (like most stuff in
wikis) is out of date: http://xfs.org/index.php/Runtime_Stats

$ pminfo -T xfs.log

xfs.log.writes
Help:
This variable counts the number of log buffer writes going to the
physical log partitions of all XFS filesystems. Log data traffic is
proportional to the level of meta-data updating. Log buffer writes
get generated when they fill up or external syncs occur.

xfs.log.blocks
Help:
This variable counts the number of Kbytes of information being
written to the physical log partitions of all XFS filesystems. Log
data traffic is proportional to the level of meta-data updating. The
rate with which log data gets written depends on the size of
internal log buffers and disk write speed. Therefore, filesystems
with very high meta-data updating may need to stripe the log
partition or put the log partition on a separate drive.

xfs.log.write_ratio
Help:
The ratio of log blocks written to log writes.  If block count isn't
a "reasonable" multiple of writes, then many small log writes are
being performed - this is suboptimal.  Perfection is 64.  Fine-grain
control can be obtained when this metric is used in conjuntion with
pmstore(1) and the xfs.control.reset metric.

xfs.log.noiclogs
Help:
This variable keeps track of times when a logged transaction can not
get any log buffer space. When this occurs, all of the internal log
buffers are busy flushing their data to the physical on-disk log.

xfs.log.force
Help:
The number of times the in-core log is forced to disk.  It is
equivalent to the number of successful calls to the function
xfs_log_force().

xfs.log.force_sleep
Help:
This metric is exported from the xs_log_force_sleep field of struct
xfsstats
-- 
Dave Chinner
david@fromorbit.com
