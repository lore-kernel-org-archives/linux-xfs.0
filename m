Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q6357w102980 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 01:03:06 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22AB01629A31
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 23:06:07 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	nIwrnp4LhWRsESNn for <xfs@oss.sgi.com>;
	Sun, 25 Jul 2010 23:06:07 -0700 (PDT)
Date: Mon, 26 Jul 2010 16:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100726060604.GF7362@dastard>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
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
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

On Sun, Jul 25, 2010 at 09:04:03PM -0700, Eli Morris wrote:
> On Jul 25, 2010, at 8:45 PM, Dave Chinner wrote:
> > On Sun, Jul 25, 2010 at 08:20:44PM -0700, Eli Morris wrote:
> >> [root@nimbus vm]#  echo 3 > /proc/sys/vm/drop_caches
> >> [root@nimbus vm]# for ag in `seq 0 1 125`; do
> >>> xfs_db -r -c "sb $ag" -c "p agcount" -c "p dblocks" /dev/vg1/vol5
> >>> done
> >> agcount = 126
> >> dblocks = 13427728384
> >> agcount = 126
> >> dblocks = 13427728384
> > ....
> > 
> > All nice and consistent before.
> > 
> >> [root@nimbus vm]# umount /export/vol5
> >> [root@nimbus vm]#  echo 3 > /proc/sys/vm/drop_caches
> >> [root@nimbus vm]# for ag in `seq 0 1 125`; do
> >>> xfs_db -r -c "sb $ag" -c "p agcount" -c "p dblocks" /dev/vg1/vol5
> >>> done
> >> agcount = 156
> >> dblocks = 16601554944
> >> agcount = 126
> >> dblocks = 13427728384
> >> agcount = 126
> >> dblocks = 13427728384
> > .....
> > 
> > And after the grow only the primary superblock has the new size and
> > agcount, which is why repair is returning it back to the old size.
> > Can you dump the output after the grow for 155 AGs instead of 125
> > so we can see if the new secondary superblocks were written? (just
> > dumping `seq 125 1 155` will be fine.)

Which shows:

> agcount = 126
> dblocks = 13427728384
> agcount = 126
> dblocks = 13427728384
....

Well, that's puzzling. The in-memory superblock is written to each
of the secondary superblocks, and that _should_ match the primary
superblock. The in-memory superblock is what is modified
during the growfs transaction and it is them synchronously written
to each secondary superblock. Without any I/O errors, I'm not sure
what is happening here.

Oh, I just noticed this from your previous mail:

> [root@nimbus vm]# df -h
> Filesystem            Size  Used Avail Use% Mounted on
.....
> /dev/mapper/vg1-vol5   51T   51T   90M 100% /export/vol5
                         ^^^^^^^^^^^^^^^

> [root@nimbus vm]# umount /export/vol5
> [root@nimbus vm]#  echo 3 > /proc/sys/vm/drop_caches
> [root@nimbus vm]# for ag in `seq 0 1 125`; do
> > xfs_db -r -c "sb $ag" -c "p agcount" -c "p dblocks" /dev/vg1/vol5
> > done
> agcount = 156
> dblocks = 16601554944
  ^^^^^^^^^^^^^^^^^^^^^

These don't match up - we've got the situation where the on-disk
value for the primary superblock has changed, but the in-memory
value has not appeared to change.

And I note from the original email I asked for data from that the
filesystem did not show up as 62TB until you unmounted and mounted
it again, which would have read the 62TB size from the primary
superblock on disk during mount. You do not need to unmount and
remount to see the new size. This leads me to believe you are
hitting one (or more) of the growfs overflow bugs that was fixed a
while back.

I've just confirmed that the problem does not exist at top-of-tree.
The following commands gives the right output, and the repair at the
end does not truncate the filesystem:

xfs_io -f -c "truncate $((13427728384 * 4096))" fsfile
mkfs.xfs -f -l size=128m,lazy-count=0 -d size=13427728384b,agcount=126,file,name=fsfile
xfs_io -f -c "truncate $((16601554944 * 4096))" fsfile
mount -o loop fsfile /mnt/scratch
xfs_growfs /mnt/scratch
xfs_info /mnt/scratch
umount /mnt/scratch
xfs_db -c "sb 0" -c "p agcount" -c "p dblocks" -f fsfile
xfs_db -c "sb 1" -c "p agcount" -c "p dblocks" -f fsfile
xfs_db -c "sb 127" -c "p agcount" -c "p dblocks" -f fsfile
xfs_repair -f fsfile

So rather than try to triage this any further, can you upgrade your
kernel/system to something more recent?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
