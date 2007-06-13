Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 16:09:24 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5DN9HWt031391
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 16:09:19 -0700
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Date: Thu, 14 Jun 2007 01:15:57 +0200
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140115.58733.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Greaves <david@dgreaves.com>, David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>

On Thursday, 14 June 2007 00:12, Linus Torvalds wrote:
> 
> On Wed, 13 Jun 2007, David Greaves wrote:
> >
> > > I'm not seeing anything really obvious. The traces would probably look
> > > better if you enabled CONFIG_FRAME_POINTER, though. That should cut down on
> > > some of the noise and make the traces a bit more readable.
> > 
> > I can do that...
> 
> Thanks. That makes a big difference to the readability of the traces.
> 
> That said, I'm so used to reading even the messy ones that this didn't 
> actually tell me anything new (it made it clear that the SCSI error 
> handler noise was just noise), but for people who aren't quite as used to 
> seeing crap backtraces, your new trace might hopefully put them on the 
> right track.
> 
> I threw out the parts that didn't look all that relevant, and left the
> ata_aux/md0_raid5/hibernate traces here for others to look at without all 
> the other noise. Those _seem_ to be the primary suspects in this saga.

Hmm, it looks like both hibernate and ata_aux are waiting for the same
completion.  I wonder who's supposed to complete it.

Greetings,
Rafael


> ---
> > ata_aux       D F7945000     0   122      2 (L-TLB)
> >        c19f7ce0 00000046 f7ea23b8 f7945000 c19f7ca0 c0121d67 c198d800 f7ea23b8
> >        c19f7cb0 c02261b7 f6af7964 f7ea23b8 c19f7cc0 c0293942 f7e865d0 c1a026bc
> >        c19f7cf0 000003ae 2dae0756 00000009 c19f7cf0 c19f7dc8 f6af7964 c19f7cfc
> > Call Trace:
> >  [<c0364fa4>] wait_for_completion+0x64/0xa0
> >  [<c021bb7d>] blk_execute_rq+0x8d/0xb0
> >  [<c02b7a88>] scsi_execute+0xb8/0x110
> >  [<c02b7b48>] scsi_execute_req+0x68/0x90
> >  [<c02bdefd>] sd_spinup_disk+0x6d/0x400
> >  [<c02bf25b>] sd_revalidate_disk+0x6b/0x160
> >  [<c02bdc1f>] sd_rescan+0x1f/0x30
> >  [<c02bb002>] scsi_rescan_device+0x42/0x50
> >  [<c02c9e10>] ata_scsi_dev_rescan+0x60/0x70
> >  [<c0127ebd>] run_workqueue+0x4d/0xf0
> >  [<c012806d>] worker_thread+0xcd/0xf0
> >  [<c012b247>] kthread+0x67/0x70
> >  [<c01049fb>] kernel_thread_helper+0x7/0x4c
> 
> > md0_raid5     D F7F4D000     0   836      2 (L-TLB)
> >        f78a3da0 00000046 f7f4d000 f7f4d000 f78a3da0 c01454b6 c048b0e0 f6ba0ad0
> >        f78a3d70 c0116be1 00010ad0 d5658227 f78a3d90 f7853000 f70c4ae0 f7f5617c
> >        f78a3de0 00003440 1be4a921 00000009 00000246 f7853000 f78a3dc8 f785313c
> > Call Trace:
> >  [<c02f1287>] md_super_wait+0x77/0xc0
> >  [<c02f993f>] write_sb_page+0x4f/0x80
> >  [<c02f9a72>] write_page+0x102/0x110
> >  [<c02f9db9>] bitmap_update_sb+0x89/0x90
> >  [<c02f3353>] md_update_sb+0x123/0x2a0
> >  [<c02f93c2>] md_check_recovery+0x302/0x340
> >  [<c02ec1f2>] raid5d+0x12/0xf0
> >  [<c02f7746>] md_thread+0x56/0x110
> >  [<c012b247>] kthread+0x67/0x70
> >  [<c01049fb>] kernel_thread_helper+0x7/0x4c
> 
> > hibernate     D F7945000     0  3874   2622 (NOTLB)
> >        f6723c60 00000086 f7ea23b8 f7945000 f6723c20 c0121d67 c198d800 f7ea23b8
> >        f6723c30 c02261b7 28ccc170 00000009 00003a03 00000000 c19615d0 f6ba0bdc
> >        0000006e 0006a677 28ccc170 00000009 f6723c70 f6723d48 f6af7804 f6723c7c
> > Call Trace:
> >  [<c0364fa4>] wait_for_completion+0x64/0xa0
> >  [<c021bb7d>] blk_execute_rq+0x8d/0xb0
> >  [<c02b7a88>] scsi_execute+0xb8/0x110
> >  [<c02b7b48>] scsi_execute_req+0x68/0x90
> >  [<c02bf80f>] sd_start_stop_device+0x6f/0x120
> >  [<c02bfb9a>] sd_resume+0x6a/0xa0
> >  [<c02bbe59>] scsi_bus_resume+0x69/0x80
> >  [<c0299932>] resume_device+0x132/0x190
> >  [<c0299aab>] dpm_resume+0xbb/0xc0
> >  [<c0299ace>] device_resume+0x1e/0x40
> >  [<c013bfd6>] hibernate+0x106/0x1a0
> >  [<c013b193>] state_store+0xc3/0xf0
> >  [<c019353b>] subsys_attr_store+0x3b/0x40
> >  [<c019370e>] flush_write_buffer+0x2e/0x40
> >  [<c0193781>] sysfs_write_file+0x61/0x70
> >  [<c015e858>] vfs_write+0x88/0x110
> >  [<c015e991>] sys_write+0x41/0x70
> >  [<c0103ee0>] syscall_call+0x7/0xb
> >  =======================
> > 
> 
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
