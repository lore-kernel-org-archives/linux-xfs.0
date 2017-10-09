Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:49240 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbdJIIoz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 04:44:55 -0400
Received: by mail-wm0-f52.google.com with SMTP id b189so20242168wmd.4
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2017 01:44:54 -0700 (PDT)
Date: Mon, 9 Oct 2017 10:44:51 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Questions about backups with XFS
Message-ID: <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>
References: <20171007114343.3bd42f98@lubh.lubhome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171007114343.3bd42f98@lubh.lubhome>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: linux-xfs@vger.kernel.org

Hi.


On Sat, Oct 07, 2017 at 02:43:43PM +0000, Luciano ES wrote:
> I have a few questions and I was torn between asking them separately 
> and putting them all in one message. I decided for the latter and I 
> hope this is not a problem.
> 
> Once upon a time, many many years ago, I used to make backup copies 
> of my file systems with the 'cp -aux' command, including my live 
> root file system. Luckily, I never had to restore any live root file 
> system from those backups. They probably would never have worked.
> 
> Later on, someone taught me to do it like this:
> 
> find /source -xdev -print0 | cpio -pa0V /target
> 
> That command is supposed to copy everything, including special files 
> (not really sure which) that mere cp or even rsync would not copy. 
> I actually used that approach several times, including restoration, 
> and it always worked.
> 
> For some reason, I stopped making backups of my live root file 
> system, but I still backup other partitions with rsync, always with 
> the --delete-before parameter, so the target is always an exact copy 
> of the source.
> 
> I have been using XFS for a few years and thought that maybe it's 
> time I enjoyed all the benefits of the XFS management tools.
> However, I am uncertain about things I haven't been able to find in 
> the documentation or even on the Web:
> 
> Question #1:
> Does xfsdump really copy EVERYTHING? Can I backup a full live root 
> file system with it and expect a restored copy to boot and run 
> uneventfully? Or should I rather do a 'hard' image with xfs_copy? 

xfs_copy must only be used an unmounted filesystem (or read-only, frozen, etc),
so, unless you want to freeze/unmount your FS everytime you do a xfs_copy, then
xfs_copy is not what you are looking for

xfsdump though will certainly backup everything you have in the filesystem you
specify.

Regarding the "restore everything and expect the system to boot", I think you
are forgetting a few things here:

	1 - xfsdump will backup the filesystem, not the device, so, MBR for
	    example is not backed up
	2 - Is a bad idea to try to backup /dev for several reasons, like device
	    names can change.


So, IMHO, if you want to plan a disaster recovery, you need first to identify
all the configuration files you need to recover after a disaster :) instead of
expecting that a full "/" backup-restore will bring your system back from ashes.

 
> Question #2:
> By the way, I see that pcmanfm can mount an xfs_copy image quite 
> easily, but how do I mount it on the command line, and can I mount 
> it in rw mode?
> 
As you mount any filesystem. If you xfs_copy it to an image, a `mount <image>
<mpoint> should work.

I've never worked on xfs_copy, but IIRC, the biggest difference from using
xfs_copy and a simple `dd` is that xfs_copy will update the filesystem uuid so
you won't have problems mounting the new image.

> Question #3:
> If I make incremental backups with several levels then perform a 
> restore, I know that files added in subsequent levels will be added 
> to the dump, but what happens with files that have been deleted in 
> the source file system? Will they be removed from the dump? In other 
> words, is there something analogous to rsync's --delete-before in 
> xfsdump/xfsrestore?
> 

I don't know the answer for this :( but most likely it doesn't have.

> Question #4:
> Is there any benefit to making incremental backups of a small file 
> system? I mean, it's just 10GB, and deleting the old backup and 
> doing a level 0 dump from scratch would take what, 3 minutes.

I'm not quite sure if xfsdump/xfsrestore you can restore backups between the
increments (like you do a full backup, then do an incremental backup, then
another, etc and you can chose from which incremental backup you want to
restore). But this might one reason.

The another one is, why would you hammer your disk with a whole 10GiB rewrite if
you can simply rewrite a few MiB?

> 
> Please note that my goal is disaster recovery. I am planning to run 
> a few experiments on my live root file and must be able to restore 
> it to a certain state whenever necessary.
> 

I think you are looking more for something like snapshots than a backup tool.
Having a full root directory backed up, restore it and simply expect the system
will be alive again, without any problems is not a good idea IMHO. It might even
work, but still, there are several things that can go wrong and you end up with
system in a dubious state.

-- 
Carlos
