Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94I0otO187653 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 13:00:50 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	szaKFH2dU2XgZQZS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 11:02:15 -0700 (PDT)
Received: by mail-vc0-f181.google.com with SMTP id n11so933772vch.26
	for <xfs@oss.sgi.com>; Thu, 04 Oct 2012 11:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506DAB8C.9000601@tlinx.org>
References: <506DAB8C.9000601@tlinx.org>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 4 Oct 2012 14:01:43 -0400
Message-ID: <CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
Subject: Re: get filename->inode mappings in bulk for a live fs?
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 4, 2012 at 11:30 AM, Linda Walsh <xfs@tlinx.org> wrote:
> I notice that attempts to use utils to get name->inode mappings
> (xfs_ncheck) seem to have no option to operate on a mounted filesystem.
>
> Is it practical to xfs_freeze such a file system and then ncheck it? or
> would
> freezing it simply freeze the fact that it is open and provide no benefit?
>
> So how can I get an inode->block mapping on a live fs.
>
> I'm not worried about some smallish number of cases that might be
> inaccurate.
>
> Out of ~5M files on my most populous volume, having even 1000 files w/wrong
> info would be less than .02% -- which would be bad if I wanted an exact
> backup,
> but for purposes a quick-fuzzy look at files that have changed and are
> finished
> being changed (vs. the ones being changed right now),
>
> The man page for xfs_freeze mentions using it to make snapshots -- how long
> does such a snapshot usually take?  I.e. how long would a file system be
> frozen?
> Is it something that would take a few ms, few seconds, or multiple minutes?
>
> This may be a weird idea, but I seem to remember when lvm takes a snapshot
> it moves the live volume aside and begins to use COW segments to hold
> changes.
>
> Is it possible to xfs-freeze a COW copy so access to the original FS isn't
> suspended thus making the time period of an xfs_freeze/dump_names less
> critical?

I think you're missing some of the basics.

Conceptually it is typically:

- quiesce system
- make snapshot
- release system (to accept future filesystem changes)
- use snapshot as a source of point-in-time data (often for backups)

Since this solution is designed for Enterprise nightly backup use the
various aspects are designed to have minimal impact on the user.  When
Oracle as an example is quiesced it maintains a RAM based transaction
log that it replays after it is released to talk to the filesystem
again.

So quiesce system is typically:
   - quiesce apps (many enterprise apps provide a API call for this)
   - quiesce filesystem (xfs_freeze can do this, but I'm pretty sure
the kernel freeze is also automatically called by lvm's snapshot
function.)

make snapshot:
     - If you're using LVM, you can do this with it,
     - or many raid arrays have API's to do this at your command
     - or some filesystems (not xfs) have snapshot functionality built-in

release system:
     - if you called xfs_freeze, you need to call it again to release
the file i/o to occur again.
     - Release any apps you quiesced (again enterprise apps may have
an API for this).

Now you can take as long as you want to dump the names from the snapshot.

At least for me none of the above takes longer than a few seconds
each.  If you have lots of data-in-flight (or write-cache) I could
imagine the freeze taking longer since it has to ensure that all
filesystem caches and buffers have been fully written to the lower
level.

FYI: I have seen ext4 maintainer Ted T'so recommend that with ext4 you
occasionally make a snapshot like the above and then do fsck on the
snapshot to see if the snapshot filesystem structure is valid.  If
errors are detect, then have the cron script send a e-mail to the
admin so he/she can schedule downtime to run fsck on the main
filesystem.  I don't know if xfs maintainers have a similar
recommendation for xfs.

FYI2: I think opensuse's snapper app has a framework to support a lot
of the above built in, but I'm not sure it supports anything but btrfs
snapshots.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
