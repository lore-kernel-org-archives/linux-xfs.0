Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752355AbcI2IAy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Sep 2016 04:00:54 -0400
Date: Thu, 29 Sep 2016 16:00:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: BUG: Internal error xfs_trans_cancel at line 984 of file
 fs/xfs/xfs_trans.c
Message-ID: <20160929080050.GY27776@eguan.usersys.redhat.com>
References: <20160829103754.GH27776@eguan.usersys.redhat.com>
 <20160830023905.GU19025@dastard>
 <20160929075414.GX27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929075414.GX27776@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-xfs@vger.kernel.org

On Thu, Sep 29, 2016 at 03:54:14PM +0800, Eryu Guan wrote:
> On Tue, Aug 30, 2016 at 12:39:05PM +1000, Dave Chinner wrote:
> > On Mon, Aug 29, 2016 at 06:37:54PM +0800, Eryu Guan wrote:
> > > Hi,
> > > 
> > > I've hit an XFS internal error then filesystem shutdown with 4.8-rc3
> > > kernel but not with 4.8-rc2
> > .....
> > > I attached a script too to reproduce it. Please note that the XFS
> > > partition needs about 40G frees space, and it may take hours to finish
> > > based on your memory setup on your host.
> > 
> > Ugh. can you try to narrow the cause so it takes less time to
> > reproduce? This is almost certainly one of two things:
> > 
> > 	1) a ENOSPC issue where an AG is almost-but-not-quite full,
> > 	but fixing up the freelist results in there being not enough
> > 	blocks left to allocate the data extent; or
> > 
> > 	2) we've split a delalloc extent so many times that we've
> > 	run out of indirect block reservation and we hit ENOSPC as a
> > 	result.
> 
> [Sorry for getting back on this after so long time..]
> 
> > 
> > For the latter, I suspect a test case where we take a large delalloc
> > range and use sync_file_range to do single page writeback to "binary
> > split" the delalloc range. i.e. start with a 128MB delalloc, then
> > sync a 4k block at offset 64MB, then 4k at 32MB, then 16MB, then
> > 8MB, ... all the way down to writing the first block in the file,
> > and also all the way up to the final block in the file.
> > 
> > Then write every second 4k block to cause worse case growth of the
> > bmbt and hopefully then exhaust the indirect block reservation for
> > that delalloc region...
> 
> Seems it's only reproducible on certain hosts, and I haven't been able
> to work out an efficient & reliable reproducer. I tried to tuned the
> parameters of bash-shared-mapping run, but failed to find a efficient
> parameter conbination. Also tried to write a script (attached, not sure
> if it's correct) based on the second case above, but still cannot
> reproduce it.

Test script:

#!/bin/bash
dev=/dev/mapper/systemvg-lv50g
mnt=/mnt/xfs
testfile=/mnt/xfs/testfile

umount $dev
mount $dev $mnt

rm -f $testfile.*

do_test()
{
        local testfile=$1
        echo "pwrite -b 128M 0 128M && sync_range 64M 4k"
        #xfs_io -fc "falloc 0 128M" -c "sync_range 64M 4k" $testfile >/dev/null
        #xfs_io -fc "pwrite $((128*1024*1024 - 4096)) 4096" -c "sync_range 64M 4k" $testfile >/dev/null
        xfs_io -fc "pwrite -b 128M 0 128M" -c "sync_range 64M 4k" $testfile >/dev/null
        step=33554432           # 32M
        off_down=67108864       # 64M
        off_up=67108864         # 64M
        while [ $off_down -gt 0 ]; do
                if [ $step -lt 4096 ]; then
                        step=4096
                fi
                off_down=$((off_down - step))
                off_up=$((off_up + step))
                step=$((step / 2))
                echo "sync_range $off_down 4k && sync_range $off_up 4k"
                xfs_io -c "sync_range $off_down 4k" -c "sync_range $off_up 4k" $testfile
        done

        offset=4096
        while [ $offset -lt 134217728 ]; do
        #       echo "pwrite $offset 4k"
                xfs_io -c "pwrite $offset 4k" $testfile >/dev/null
                offset=$((offset + 8192))
        done
}

for i in `seq 1 10`; do
        do_test $testfile.$i &
done
wait
