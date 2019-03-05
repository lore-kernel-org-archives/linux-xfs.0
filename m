Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56818 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbfCEDF5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Mar 2019 22:05:57 -0500
Subject: Re: [PATCH] Add xfs_only flag to fs_table_initialise_mounts()
 function
References: <20190304213124.552-1-tgill@redhat.com>
 <20190304234512.GZ23020@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <49bacedd-ade9-ed6e-4efa-0271babfbc6d@sandeen.net>
Date: Mon, 4 Mar 2019 21:05:56 -0600
MIME-Version: 1.0
In-Reply-To: <20190304234512.GZ23020@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, tgill@redhat.com
Cc: linux-xfs@vger.kernel.org



On 3/4/19 5:45 PM, Dave Chinner wrote:
> On Mon, Mar 04, 2019 at 04:31:24PM -0500, tgill@redhat.com wrote:
>> From: Todd Gill <tgill@redhat.com>
>>
>> The xfs_only flag will allow the caller to request only XFS filesystems are
>> added to the fs table.
>>
>> For commands that are XFS specific (xfs_fsr, xfs_growfs, xfs_scrub) - pass
>> the flag as 1.
>>
>> The change avoids a hang when remote filesystem (like NFS) are non
>> responsive.
> 
> I have the nagging feeling that this has been proposed, discussed
> and rejected previously. However, my search skills are sadly lacking
> today, because I can't find it in my local archive. Probably worth
> doing some more searching rather than repeating the discussion over
> again...

FWIW, this problem is relatively new.  It crept in when we decided that
xfs_quota should work on ext4, and so we had to slurp in non-xfs
mountpoints.  Yay.

Dave, I'm wondering if I didn't discuss this on IRC briefly and that's
what's triggering your memory...

May 03 17:32:07 <sandeen>       dchinner, i'm not sure waht to do about our crazy is-it-mounted checks w.r.t. your subvols at this point.
May 03 17:32:18 <sandeen>       I Kinda need to fix the "mkfs.xfs hangs on stuck nfs mounts, wut?!" problem
May 03 17:34:54 <djwong>        check fsname[0] == '/' like e2fsprogs does :D
May 03 17:35:34 <sandeen>       I pointed and laughed at that, but actually ...
May 03 17:35:46 <sandeen>       dave's fs/volume paths will be full paths from /
May 03 17:36:12 <sandeen>       you ... can't really get an actual device node in /proc/mounts w/ a relative path either, right?
May 03 17:36:15 <sandeen>       maybe that's not so bad.
May 03 17:37:00 <sandeen>       see if the "device" contains a : and then try to ping the stuff before it ;)
May 03 17:37:07 <sandeen>       (I AM KIDDING)
May 03 17:37:44 <sandeen>       anyway, skipping anything that doesn't start with '/' might actually be smart/ok
May 03 17:40:33 <sandeen>       if youv'e somehow contrived an actual device that doesn't have a path in /proc/mounts and you go to try to mkfs it while mounted I think you get to keep all the explody bits.
May 03 17:53:00 <dchinner>      sandeen: just ignore them - I'll do whatever I need to do to make them work again when your code hits the tree...

but ... I don't know if anything ever got sent.

I had also mused about something like:

May 02 14:36:27 <sandeen>       I wonder if this is safe in the "is it mounted" loop:
May 02 14:36:27 <sandeen>               while ((mnt = getmntent(f)) != NULL) {
May 02 14:36:27 <sandeen>                       /* If the "fsname" is't a stat-able device, skip it */
May 02 14:36:27 <sandeen>                       if (stat(mnt->mnt_fsname, &mst) < 0)
May 02 14:36:27 <sandeen>                               continue;
May 02 14:37:01 <sandeen>       i.e. don't bother checking every procfs, nfs mount, tmpfs, cgroup, etc.

-Eric
