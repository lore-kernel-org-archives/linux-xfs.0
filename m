Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94IS7eh191682 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 13:28:07 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id mvHWB9BBQHuGWkYR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 11:29:33 -0700 (PDT)
Message-ID: <506DD589.2010106@tlinx.org>
Date: Thu, 04 Oct 2012 11:29:29 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: get filename->inode mappings in bulk for a live fs?
References: <506DAB8C.9000601@tlinx.org>
	<CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
In-Reply-To: <CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Greg Freemyer wrote:
> > Is it possible to xfs-freeze a COW copy so access to the original FS isn't
> > suspended thus making the time period of an xfs_freeze/dump_names less
> > critical?
>
> I think you're missing some of the basics.
>
> Conceptually it is typically:
>
> - quiesce system
> - make snapshot
> - release system (to accept future filesystem changes)
> - use snapshot as a source of point-in-time data (often for backups)
>
> Since this solution is designed for Enterprise nightly backup use the
> various aspects are designed to have minimal impact on the user.  When
> Oracle as an example is quiesced it maintains a RAM based transaction
> log that it replays after it is released to talk to the filesystem
> again.
>
> So quiesce system is typically:
>    - quiesce apps (many enterprise apps provide a API call for this)
----
    Can you name 1 on linux that does?

    I can't think of any -- sendmail, imap, samba, squid, syslog...


>    - quiesce filesystem (xfs_freeze can do this, but I'm pretty sure
> the kernel freeze is also automatically called by lvm's snapshot
> function.)
----
    Yeah... I understand this part -- in a few emails that follow the one you 
are responding
to, I showed where I tried exactly this... and either I 'm missing something (which
wouldn't be hard, given my vast knowledge (*cough*) in this area), or it's not 
working.
I hope it is the former, as my own ignorance is usually easier to address than 
the latter.

>
> make snapshot:
>      - If you're using LVM, you can do this with it,
>      - or many raid arrays have API's to do this at your command
>      - or some filesystems (not xfs) have snapshot functionality built-in
----
    The *purpose* of an lvm snapshot -- supposedly, is to create a stable (as in
it's not going to be changing underneath you) file system to backup from.  It 
doesn't
guarantee that the filesystem is in a consistent state -- but it will prevent future
modifications....)...

    It sounds like -- I'm using the wrong 'order' ...

    It sounds more like I need to xfs_freeze the live volume, 'home'
create a snapshot of that (lvm) - which hopefully won't try to write to the 
xfs-frozen
volume, -- once that is done, xfs-unfreeze....

Irck....

>
> release system:
>      - if you called xfs_freeze, you need to call it again to release
> the file i/o to occur again.
>      - Release any apps you quiesced (again enterprise apps may have
> an API for this).
>
> FYI: I have seen ext4 maintainer Ted T'so recommend that with ext4 you
> occasionally make a snapshot like the above and then do fsck on the
> snapshot to see if the snapshot filesystem structure is valid.  If
> errors are detect, then have the cron script send a e-mail to the
> admin so he/she can schedule downtime to run fsck on the main
> filesystem.  I don't know if xfs maintainers have a similar
> recommendation for xfs.
----
    xfs doesn't really have an fsck -- one was added to dot some
'i' or cross some 't', but it's more of a bother than anything, as
it just checks to see if the file system is there.  If it is, pass,
else, fail.  I don't need mkfs to cause my system boot to fail
due to a missing disk -- as the system "will or won't" come up
in some form, without that disk, regardless. 

    In the past, in rare instances where something was offline
(just messed w/disks or deliberately have a disk offline and
want to boot), a pure xfs system would just "work" (with
the assumption that the offline disk wasn't critical in order
to boot).  Then I could log-in and continue (or do) whatever
maintenance was necessary to restore normalcy.  But with
the new scripts, the system is guaranteed to fail and not
come up except to the console.  Certainly not my idea of
a robust system.

    But for some perfection is more important than robust.

I usually try change xfs.fsck into a link to /bin/true after
updates...
>
> FYI2: I think opensuse's snapper app has a framework to support a lot
> of the above built in, but I'm not sure it supports anything but btrfs
> snapshots.
---
    You are correct -- I was surprised to see them call an app 'snapper'
when it doesn't even support lvm snapshots, but only the non-stable
and non-production-ready 'btrfs'.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
