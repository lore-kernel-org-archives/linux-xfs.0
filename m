Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D75D7F37
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 11:37:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11DD0AC003
	for <xfs@oss.sgi.com>; Tue, 17 Nov 2015 09:37:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GXrCRbqnruhfMV56 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 17 Nov 2015 09:37:26 -0800 (PST)
Date: Tue, 17 Nov 2015 12:37:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Disk error, then endless loop
Message-ID: <20151117173724.GA18963@bfoster.bfoster>
References: <20151117080332.GA28936@onthe.net.au>
	<20151117124148.GA20118@bfoster.bfoster>
	<20151117162802.GA28374@onthe.net.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151117162802.GA28374@onthe.net.au>
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
To: Chris Dunlop <chris@onthe.net.au>
Cc: xfs@oss.sgi.com

On Wed, Nov 18, 2015 at 03:28:02AM +1100, Chris Dunlop wrote:
> G'day Brian,
> 
> Thanks for your response...
> 
> On Tue, Nov 17, 2015 at 07:41:48AM -0500, Brian Foster wrote:
> > On Tue, Nov 17, 2015 at 07:03:33PM +1100, Chris Dunlop wrote:
> >> Hi,
> >> 
...
> 
> >> I tried to umount the filesystem but the umount is now hung and unkillable:
> >> 
> >> # ps -ostat,wchan='WCHAN-xxxxxxxxxxxxxxxxxx',cmd -C umount
> >> STAT WCHAN-xxxxxxxxxxxxxxxxxx CMD
> >> D+   xfs_ail_push_all_sync    umount /var/lib/ceph/osd/ceph-18
> > 
> > ... but it appears you still have something pending in the AIL which is
> > holding everything up. The most likely case is an EFI/EFD item hanging
> > around from an extent free operation, as this was a known issue,
> > particularly on fs shutdowns. Fixes for this went into the v4.3 kernel.
> 
> Any chance of these fixes getting into -stable, or are they too intrusive
> and/or depend on other intrusive changes?
> 

I don't think so... it was a multi-patch series and a rework of the
EFI/EFD reference counting as opposed to an isolated bug fix. For
reference, it was commits 5e4b538 through f0b2efa or so.

> > Note that this won't address whatever is wrong with the disk in the
> > first place,
> 
> Bwaaaaahhhh, magic ponies!
> 
> > just (hopefully) the ability to unmount when it ultimately fails.
> 
> Yes, that's what I was hoping for.
> 
> > Does the umount process actually appear to be doing anything? E.g., are
> > you seeing noticeable CPU load or I/O errors continue to the logs, or
> > has everything pretty much locked up? You could also enable tracepoints
> > (trace-cmd start -e "xfs:*"; cat /sys/kernel/debug/tracing/trace_pipe)
> > to get a quick idea of what's going on.
> 
> No, the umount hasn't done anything noticable in the past 6.5 hours:
> 
> b2# date; ps -opid,lstart,time,stat,wchan='WCHAN-xxxxxxxxxxxxxxxxxx',cmd -C umount
> Wed Nov 18 03:08:30 AEDT 2015
>   PID                  STARTED     TIME STAT WCHAN-xxxxxxxxxxxxxxxxxx CMD
> 23946 Tue Nov 17 17:30:41 2015 00:00:00 D+   xfs_ail_push_all_sync    umount /var/lib/ceph/osd/ceph-18
> 
> I don't know how to interpret the tracepoints, but there are other busy
> XFS filesystems on the box so that's cluttering things up. For what it's
> worth, it appears the original device (/dev/sdu1) was previously dev
> 65:65:
> 
> b2# ls -l /dev/sd[tuv]{,1}
> brw-rw---T 1 root disk 65, 48 Sep 16 17:11 /dev/sdt
> brw-rw---T 1 root disk 65, 49 Sep 16 17:11 /dev/sdt1
> brw-rw---T 1 root disk 65, 80 Oct 30 15:38 /dev/sdv
> brw-rw---T 1 root disk 65, 81 Oct 30 15:40 /dev/sdv1
> 
> ..and in 10 seconds of /sys/kernel/debug/tracing/trace_pipe we have:
> 
> # grep 'dev 65:65' /sys/kernel/debug/tracing/trace_pipe > /tmp/x1 & sleep 10; kill $!
> # wc -l /tmp/x1
> 181953 /tmp/x1
> # head /tmp/x1
>            <...>-7702  [012] .... 5392362.786946: xfs_buf_item_iodone_async: dev 65:65 bno 0x1828eed18 nblks 0x8 hold 2 pincount 0 lock 0 flags ASYNC|DONE|PAGES caller xfs_buf_ioend [xfs]
>            <...>-7702  [012] .... 5392362.786946: xfs_buf_ioerror: dev 65:65 bno 0x1828eed18 len 0x1000 hold 2 pincount 0 lock 0 error 0 flags ASYNC|DONE|PAGES caller xfs_buf_iodone_callbacks [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647059: xfs_buf_submit: dev 65:65 bno 0x27ffffff8 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller __xfs_buf_delwri_submit [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647059: xfs_buf_hold: dev 65:65 bno 0x27ffffff8 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller xfs_buf_submit [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647061: xfs_buf_rele: dev 65:65 bno 0x27ffffff8 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller xfs_buf_submit [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647061: xfs_buf_submit: dev 65:65 bno 0x280006398 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller __xfs_buf_delwri_submit [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647061: xfs_buf_hold: dev 65:65 bno 0x280006398 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller xfs_buf_submit [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647063: xfs_buf_rele: dev 65:65 bno 0x280006398 nblks 0x8 hold 3 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller xfs_buf_submit [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647063: xfs_buf_submit: dev 65:65 bno 0x2800063f8 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller __xfs_buf_delwri_submit [xfs]
>     xfsaild/sdu1-7991  [005] .N.. 5392363.647064: xfs_buf_hold: dev 65:65 bno 0x2800063f8 nblks 0x8 hold 2 pincount 0 lock 0 flags WRITE|ASYNC|DONE|PAGES caller xfs_buf_submit [xfs]
> 

Hmm, that is notably more activity than I recall when reproducing the
original AIL issue. Do we know whether the filesystem had actually shut
down or is in some intermediate state looping on errors? The fact that
it continues to try and submit I/O suggests that perhaps it hasn't shut
down for whatever reason.

If the device has already dropped and reconnected as a new dev node,
it's probably harmless at this point to just try to forcibly shut down
the fs on the old one. Could you try the following?

  xfs_io -x -c shutdown <mnt>

Can you unmount the fs after that? If not, is there still any tracepoint
activity on the old device?

Brian

> In the 181953 lines there's a set of 188 different block numbers
> appearing, ranging from 0x8 to 0x2900ffbd8:
> 
> # sed -rn 's/.*bno (0x[[:xdigit:]]+).*/\1/p' /tmp/x1 | sort -u > /tmp/x2
> # wc -l /tmp/x2
> 188 /tmp/x2
> # perl -pe 's/(.*)/hex($1)/e' /tmp/x2 | sort -n | perl -ne 'printf "0x%x\n",$_' > /tmp/x3
> # head /tmp/x3
> 0x8
> 0x10
> 0x20
> 0x28
> 0x3188
> 0x4a40
> 0x4a68
> 0x2b163a0
> 0x31fecd0
> 0x426e8f8
> b2# tail /tmp/x3
> 0x2900ffb78
> 0x2900ffb88
> 0x2900ffb98
> 0x2900ffba8
> 0x2900ffbb0
> 0x2900ffbb8
> 0x2900ffbc0
> 0x2900ffbc8
> 0x2900ffbd0
> 0x2900ffbd8
> 
> >> As previously mentioned, the disk has actually reappeared under a different
> >> /dev/sdXX name (it was sdu, now sdbh). Trying to mount the disk (read only)
> >> results in:
> >> 
> >> # mkdir /mnt/xfs && mount -ologdev=/dev/md8p5,ro /dev/sdbh1 /mnt/xfs
> >> mount: /dev/sdbh1 already mounted or /mnt/xfs busy
> > 
> > Probably due to either a uuid check or blocking on access to the
> > external log device. You'll probably need to clean up the stale mount
> > before this will work.
> > 
> > As it is, something is clearly wrong with the drive. I can't really
> > interpret the I/O errors and whatnot (linux-scsi?), but you probably
> > want to look into health assessment tools (e.g., smart) to get an idea
> > of what's wrong and/or replace the device and restore from backups (or
> > perhaps heal via the ceph cluster, in your case).
> 
> Sure. It's not the disk that's concerning me, they're expected to die,
> but it looks like the disk error has put XFS in a state where the only
> solution is a hard power cycle (after quiescing and cleaning up what I
> can): I haven't tried it yet, but I expect I won't be able reboot
> cleanly.
> 
> > 
> > Brian
> 
> Cheers,
> 
> Chris
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
