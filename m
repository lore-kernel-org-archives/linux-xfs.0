Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A79B7F55
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 15:38:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8086AC00F
	for <xfs@oss.sgi.com>; Thu,  1 Oct 2015 13:38:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id slEnFTWHxqwig63R (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 01 Oct 2015 13:38:54 -0700 (PDT)
Date: Thu, 1 Oct 2015 16:38:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 02/12] libxfs: track largest metadata LSN in use via
	verifiers
Message-ID: <20151001203851.GA3349@bfoster.bfoster>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-3-git-send-email-bfoster@redhat.com>
	<20150923034406.GR3902@dastard>
	<20150923131831.GB37210@bfoster.bfoster>
	<20150923223625.GR19114@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150923223625.GR19114@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 24, 2015 at 08:36:25AM +1000, Dave Chinner wrote:
> On Wed, Sep 23, 2015 at 09:18:31AM -0400, Brian Foster wrote:
> > On Wed, Sep 23, 2015 at 01:44:06PM +1000, Dave Chinner wrote:
> > > On Fri, Sep 11, 2015 at 02:55:32PM -0400, Brian Foster wrote:
> > > > +
> > > > +	pthread_mutex_lock(&libxfs_max_lsn_lock);
> > > > +
> > > > +	max_cycle = CYCLE_LSN(libxfs_max_lsn);
> > > > +	max_block = BLOCK_LSN(libxfs_max_lsn);
> > > > +
> > > > +	if ((cycle > max_cycle) ||
> > > > +	    (cycle == max_cycle && block > max_block))
> > > > +		libxfs_max_lsn = lsn;
> 
> Actually, we have XFS_LSN_CMP(lsn1, lsn2) for this. i.e.
> 
> 	if (XFS_LSN_CMP(lsn, libxfs_max_lsn) > 0)
> 		libxfs_max_lsn = lsn;
> 
> > > > +
> > > > +	pthread_mutex_unlock(&libxfs_max_lsn_lock);
> > > 
> > > This will have the same lock contention problems that the kernel
> > > code would have had - my repair scalablity tests regularly reach
> > > over 1GB/s of metadata being prefetched through tens of threads, so
> > > this is going have a significant impact on performance in those
> > > tests....
> > > 
> > 
...
> 
> > I'll have to think about this some more and see what's effective. I'd
> > also like to quantify the effect the current locking has on performance
> > if possible. Can you provide a brief description of your typical repair
> > test that you would expect this to hurt? E.g., a large fs, many AGs,
> > populated with fs_mark and repaired with many threads..? Any special
> > storage configuration? Thanks.
> 
> Just my usual 500TB fs_mark test...
> 

Thanks for the test information and sample results. I wasn't able to get
close enough to the base numbers you mentioned on IRC with the spinning
rust storage I have available. Instead, I tried running something
similar using a large ramdisk as a backing store. I have a 500T sparse
file formatted with XFS and populated with ~25m inodes that uses roughly
~16GB of the backing store (leaving another 16GB of usable RAM for the
server).

I run xfs_repair[1] against that 500TB fs and see spikes of throughput up
over 2GB/s and get repair result reports like the following:

Phase           Start           End             Duration
Phase 1:        10/01 13:03:44  10/01 13:03:45  1 second
Phase 2:        10/01 13:03:45  10/01 13:03:46  1 second
Phase 3:        10/01 13:03:46  10/01 13:05:01  1 minute, 15 seconds
Phase 4:        10/01 13:05:01  10/01 13:05:14  13 seconds
Phase 5:        10/01 13:05:14  10/01 13:05:15  1 second
Phase 6:        10/01 13:05:15  10/01 13:05:50  35 seconds
Phase 7:        10/01 13:05:50  10/01 13:05:50

The numbers don't change that much on repeated runs and if I do a quick
and dirty average of the duration of phases 3, 4 and 6 and compare with
results from the for-next branch, the runtime degradation is on the
order of tenths of a second. Here's a for-next (e.g., no max lsn
tracking) run for reference:

Phase           Start           End             Duration
Phase 1:        10/01 13:19:53  10/01 13:19:53
Phase 2:        10/01 13:19:53  10/01 13:19:56  3 seconds
Phase 3:        10/01 13:19:56  10/01 13:21:11  1 minute, 15 seconds
Phase 4:        10/01 13:21:11  10/01 13:21:22  11 seconds
Phase 5:        10/01 13:21:22  10/01 13:21:23  1 second
Phase 6:        10/01 13:21:23  10/01 13:21:57  34 seconds
Phase 7:        10/01 13:21:57  10/01 13:21:57

So I'm not seeing much difference here with the max lsn tracking as it
is implemented in this series. Out of curiosity, I ran a v3.2.2
xfs_repair binary that happened to be installed on this host, got a much
faster result than even the current master, and via perf diff discovered
that the biggest difference between the runs was actual CRC calculation.
Based on that, I ran the same crc=0 test against the current code with
the following results:

Phase           Start           End             Duration
Phase 1:        10/01 13:53:49  10/01 13:53:49
Phase 2:        10/01 13:53:49  10/01 13:53:50  1 second
Phase 3:        10/01 13:53:50  10/01 13:54:52  1 minute, 2 seconds
Phase 4:        10/01 13:54:52  10/01 13:55:01  9 seconds
Phase 5:        10/01 13:55:01  10/01 13:55:01
Phase 6:        10/01 13:55:01  10/01 13:55:35  34 seconds
Phase 7:        10/01 13:55:35  10/01 13:55:35

... so that knocks off another 15s or so from the test. Note that the
lsn lock is irrelevant in the crc=0 case as there are no metadata LSNs,
thus no verification occurs.

All in all, I can't really reproduce any tangible degradation due to the
maxlsn lock and I don't really want to prematurely optimize it if it's
not a contention point in practice. Thoughts? If you get a chance, care
to give this code a quick run under your xfs_repair test environment? If
you can reproduce something there, I can continue to try and figure out
what might be different in my test.

Brian

[1] xfs_repair -o bhash=100101 -v -v -t 1 -f <file>

> $ cat ~/tests/fsmark-50-test-xfs.sh 
> #!/bin/bash
> 
> QUOTA=
> MKFSOPTS=
> NFILES=100000
> DEV=/dev/vdc
> LOGBSIZE=256k
> 
> while [ $# -gt 0 ]; do
>         case "$1" in
>         -q)     QUOTA="uquota,gquota,pquota" ;;
>         -N)     NFILES=$2 ; shift ;;
>         -d)     DEV=$2 ; shift ;;
>         -l)     LOGBSIZE=$2; shift ;;
>         --)     shift ; break ;;
>         esac
>         shift
> done
> MKFSOPTS="$MKFSOPTS $*"
> 
> echo QUOTA=$QUOTA
> echo MKFSOPTS=$MKFSOPTS
> echo DEV=$DEV
> 
> sudo umount /mnt/scratch > /dev/null 2>&1
> sudo mkfs.xfs -f $MKFSOPTS $DEV
> sudo mount -o nobarrier,logbsize=$LOGBSIZE,$QUOTA $DEV /mnt/scratch
> sudo chmod 777 /mnt/scratch
> cd /home/dave/src/fs_mark-3.3/
> sudo sh -c "echo 1 > /proc/sys/fs/xfs/stats_clear"
> time ./fs_mark  -D  10000  -S0  -n  $NFILES  -s  0  -L  32 \
>         -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
>         -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
>         -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
>         -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
>         -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
>         -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
>         -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
>         -d  /mnt/scratch/14  -d  /mnt/scratch/15 \
>         | tee >(stats --trim-outliers | tail -1 1>&2)
> sync
> 
> echo Repair
> sudo umount /mnt/scratch
> time sudo xfs_repair -o bhash=100101 -v -v -t 1 $DEV
> time sudo mount -o nobarrier,logbsize=$LOGBSIZE,$QUOTA $DEV /mnt/scratch
> 
> echo bulkstat files
> 
> time (
>         sudo ~/src/xfstests-dev/src/bstat  -q /mnt/scratch 1024 | wc -l
> )
> 
> echo walking files
> ~/tests/walk-scratch.sh
> 
> echo removing files
> for f in /mnt/scratch/* ; do time rm -rf $f &  done
> wait
> 
> sudo umount /mnt/scratch
> $
> 
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
