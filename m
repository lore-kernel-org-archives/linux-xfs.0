Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q920iKIt220517 for <xfs@oss.sgi.com>; Mon, 1 Oct 2012 19:44:20 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YoBMPfUTKpavZF4Q for
	<xfs@oss.sgi.com>; Mon, 01 Oct 2012 17:45:43 -0700 (PDT)
Message-ID: <506A38D1.6090204@redhat.com>
Date: Mon, 01 Oct 2012 20:44:01 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com> <20121002001021.GJ23520@dastard>
In-Reply-To: <20121002001021.GJ23520@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/01/2012 08:10 PM, Dave Chinner wrote:
> Hi, Brian.
> 
> On Mon, Oct 01, 2012 at 04:14:40PM -0400, Brian Foster wrote:
>> Warning: This message has had one or more attachments removed
>> Warning: (273.out.bad).
>> Warning: Please read the "boprocket-Attachment-Warning.txt" attachment(s) for more information.
> 
> Which says:
> 
>> At Mon Oct  1 20:14:58 2012 the virus scanner said:                
>>    MailScanner: Attempt to hide real filename extension (273.out.bad)
> 
> Looks like your mailer did something wrong with the attachment....
> 

Ugh, sorry. The output file was filled with messages like so:

_porter 31 not complete
_porter 79 not complete
_porter 149 not complete
_porter 74 not complete
_porter 161 not complete
_porter 54 not complete
_porter 98 not complete
_porter 99 not complete
...

> 
>> Heads up... I was doing some testing against my eofblocks set rebased
>> against this patchset and I'm reproducing a new 273 failure. The failure
>> bisects down to this patch.
>>
>> With the bisection, I'm running xfs top of tree plus the following patch:
>>
>> xfs: only update the last_sync_lsn when a transaction completes
>>
>> ... and patches 1-6 of this set on top of that. i.e.:
>>
>> xfs: xfs_sync_data is redundant.
>> xfs: Bring some sanity to log unmounting
>> xfs: sync work is now only periodic log work
>> xfs: don't run the sync work if the filesystem is read-only
>> xfs: rationalise xfs_mount_wq users
>> xfs: xfs_syncd_stop must die
>> xfs: only update the last_sync_lsn when a transaction completes
>> xfs: Make inode32 a remountable option
>>
>> This is on a 16p (according to /proc/cpuinfo) x86-64 system with 32GB
>> RAM. The test and scratch volumes are both 500GB lvm volumes on top of a
>> hardware raid.
>> I haven't looked into this at all yet but I wanted to
>> drop it on the list for now. The 273 output is attached.
> 
> I bet you had writes fail with ENOSPC - 201 * 426
> = 85626 files of 8k each, that gives 685MB. When the test is
> running, I see upwards of 1.5GB of space consumed, which then slowly
> drops again as data files are closed and data is written.
> 
> Some of that space is specualtive preallocation (4k per file, I
> think), but also a significant amount of it is metadata reservation
> for delayed allocation (4 blocks per file, IIRC). If I've only got
> 2GB RAM on my machine, then writeback starts at 200MB written, and
> so well before the fs runs out of space the metadata reservations
> are being released.
> 
> I just upped the VM to 8GB RAM, and immediately I see the test
> starting to fail. And this is in 273.full:
> 
> cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_141': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_142': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_1cp: cannot create regular filcp: cannot create regular file `/mnt/scratch/sub_198/origin/file_147': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_198/origin/file_1cp: cannot create regular filcp: writing `/mnt/scratch/sub_198/origin/file_149': No space left cp: writing `/mnt/scratch/sub_156/origin/file_275': No space left on device
> cp: failed to extencp: writing `/mnt/scratch/sub_198/origin/file_150': No space left cp: writing `/mnt/scratch/sub_156/origin/file_276': No space left on device
> cp: failed to extencp: cannot create regular file `/mnt/scratch/sub_124/origin/file_3cp: cannot create regular filcp: writing `/mnt/scratch/sub_124/origin/file_378': No space left cp: writing `/mnt/scratch/sub_173/origin/file_250': No space left on device
> cp: failed to extencp: writing `/mnt/scratch/sub_124/origin/file_379': No space left cp: cannot create regular file `/mnt/scratch/sub_173/origin/file_2cp: cannot create regular file `/mnt/scratch/sub_134/origin/file_337': No space left on device
> cp: cannot create regular filcp: cannot create regular filcp: writing `/mnt/scratch/sub_159/origin/file_307': No space left on device
> cp: failed to extend `/mnt/scratch/sub_159/origin/file_307': No space left on device
> cp: writing `/mnt/scratch/sub_159/origin/file_308': No space left on device
> cp: failed to extend `/mnt/scratch/sub_159/origin/file_308': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_309': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_310': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_311': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_312': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_313': No space left on device
> cp: cannot create regular file `/mnt/scratch/sub_159/origin/file_314': No space left on device
> .....
> 

Yep, I see the same thing...

> So, turning off speculative preallocation via the allocsize mount
> option doesn't fix the problem. IOWs, the problem is too much active
> metadata reservation.  If we are caching 685MB, that's less than the
> writeback thresholds of a large memory machine, so the metadata
> reservations won't be trimmed at all until ENOSPC actually occurs
> and writeback is then started.
> 
> The problem is that writeback_inodes_sb_if_idle() does not block if
> there is already writeback in progress, so the callers just keep
> hitting ENOSPC rather than being throttled waiting for delalloc
> conversion.
> 
> The patch below should fix this - it changes xfs_flush_inodes() to
> us sync_inodes_sb(), which will issue IO and block waiting for it to
> complete, just like xfs_flush_inodes() used to. Indeed, it passes
> again on my VM with 8GB RAM....
> 

I gave this a quick couple runs against 273 and it passes (on top of the
entire die-xfssyncd-die patchset). I'll kick off another full run on
this box overnight. Thanks!

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
