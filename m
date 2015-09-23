Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CC6197F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 17:45:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F7A2304032
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 15:45:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TKTo5Nt5RPE7RlmF for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 15:45:27 -0700 (PDT)
Date: Thu, 24 Sep 2015 08:36:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 02/12] libxfs: track largest metadata LSN in use via
	verifiers
Message-ID: <20150923223625.GR19114@dastard>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-3-git-send-email-bfoster@redhat.com>
	<20150923034406.GR3902@dastard>
	<20150923131831.GB37210@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150923131831.GB37210@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

On Wed, Sep 23, 2015 at 09:18:31AM -0400, Brian Foster wrote:
> On Wed, Sep 23, 2015 at 01:44:06PM +1000, Dave Chinner wrote:
> > On Fri, Sep 11, 2015 at 02:55:32PM -0400, Brian Foster wrote:
> > > +
> > > +	pthread_mutex_lock(&libxfs_max_lsn_lock);
> > > +
> > > +	max_cycle = CYCLE_LSN(libxfs_max_lsn);
> > > +	max_block = BLOCK_LSN(libxfs_max_lsn);
> > > +
> > > +	if ((cycle > max_cycle) ||
> > > +	    (cycle == max_cycle && block > max_block))
> > > +		libxfs_max_lsn = lsn;

Actually, we have XFS_LSN_CMP(lsn1, lsn2) for this. i.e.

	if (XFS_LSN_CMP(lsn, libxfs_max_lsn) > 0)
		libxfs_max_lsn = lsn;

> > > +
> > > +	pthread_mutex_unlock(&libxfs_max_lsn_lock);
> > 
> > This will have the same lock contention problems that the kernel
> > code would have had - my repair scalablity tests regularly reach
> > over 1GB/s of metadata being prefetched through tens of threads, so
> > this is going have a significant impact on performance in those
> > tests....
> > 
> 
> Hmm, Ok. I initially didn't have locking here (by accident) but
> reproduced some breakage for which the exact details escape me. I
> suspect it was a test and set race.
> 
> I suppose we could try doing something like what we plan to do on the
> kernel side in terms of a racy check followed by the locked check so the
> lock contention goes away once we find the max lsn. The context here is
> different, however, in that we're using a 64-bit LSN rather than
> independently updated cycle and block fields. It could also take a while
> to stabilize the max lsn depending on the fs. (There are some details on
> the kernel side I'd like to get worked out first as well).

It still has to work on 32 bit machines, where 64 bit operations are
not atomic....

> Perhaps we could try to make this smarter... in the case where either
> the log has been zeroed or we've identified an LSN beyond the current
> log state, we only really need to track the max cycle value since a log
> format is imminent at that point. In the case where the fs is
> consistent, we could seed the starting value with the current log lsn,
> or track per-ag max LSNs without locking and compare them at at the end,
> etc.

Yes, we should seen the initial "max lsn" with whatever we find in
the log, regardless of whether the fs is consistent or not...

Also, per-ag max lsn tracking would break the lock up - that will
bring scope down to the point where contention won't be a problem...

> I'll have to think about this some more and see what's effective. I'd
> also like to quantify the effect the current locking has on performance
> if possible. Can you provide a brief description of your typical repair
> test that you would expect this to hurt? E.g., a large fs, many AGs,
> populated with fs_mark and repaired with many threads..? Any special
> storage configuration? Thanks.

Just my usual 500TB fs_mark test...

$ cat ~/tests/fsmark-50-test-xfs.sh 
#!/bin/bash

QUOTA=
MKFSOPTS=
NFILES=100000
DEV=/dev/vdc
LOGBSIZE=256k

while [ $# -gt 0 ]; do
        case "$1" in
        -q)     QUOTA="uquota,gquota,pquota" ;;
        -N)     NFILES=$2 ; shift ;;
        -d)     DEV=$2 ; shift ;;
        -l)     LOGBSIZE=$2; shift ;;
        --)     shift ; break ;;
        esac
        shift
done
MKFSOPTS="$MKFSOPTS $*"

echo QUOTA=$QUOTA
echo MKFSOPTS=$MKFSOPTS
echo DEV=$DEV

sudo umount /mnt/scratch > /dev/null 2>&1
sudo mkfs.xfs -f $MKFSOPTS $DEV
sudo mount -o nobarrier,logbsize=$LOGBSIZE,$QUOTA $DEV /mnt/scratch
sudo chmod 777 /mnt/scratch
cd /home/dave/src/fs_mark-3.3/
sudo sh -c "echo 1 > /proc/sys/fs/xfs/stats_clear"
time ./fs_mark  -D  10000  -S0  -n  $NFILES  -s  0  -L  32 \
        -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
        -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
        -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
        -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
        -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
        -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
        -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
        -d  /mnt/scratch/14  -d  /mnt/scratch/15 \
        | tee >(stats --trim-outliers | tail -1 1>&2)
sync

echo Repair
sudo umount /mnt/scratch
time sudo xfs_repair -o bhash=100101 -v -v -t 1 $DEV
time sudo mount -o nobarrier,logbsize=$LOGBSIZE,$QUOTA $DEV /mnt/scratch

echo bulkstat files

time (
        sudo ~/src/xfstests-dev/src/bstat  -q /mnt/scratch 1024 | wc -l
)

echo walking files
~/tests/walk-scratch.sh

echo removing files
for f in /mnt/scratch/* ; do time rm -rf $f &  done
wait

sudo umount /mnt/scratch
$

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
