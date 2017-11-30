Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25064 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750968AbdK3VEa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Nov 2017 16:04:30 -0500
Date: Fri, 1 Dec 2017 08:03:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Message-ID: <20171130210312.GN5858@dastard>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <1512061271.2774.10.camel@wdc.com>
 <20171130194249.GK729@wotan.suse.de>
 <1512075231.2774.17.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512075231.2774.17.camel@wdc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "bmarzins@redhat.com" <bmarzins@redhat.com>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "yu.chen.surf@gmail.com" <yu.chen.surf@gmail.com>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

On Thu, Nov 30, 2017 at 08:53:52PM +0000, Bart Van Assche wrote:
> On Thu, 2017-11-30 at 20:42 +0100, Luis R. Rodriguez wrote:
> > On Thu, Nov 30, 2017 at 05:01:13PM +0000, Bart Van Assche wrote:
> > > The md resync
> > > thread must be stopped before a system is frozen. Today the md driver uses
> > > the kthread freezing mechanism for that purpose. Do you have a plan for
> > > handling the more complicated scenarios, e.g. a filesystem that exists on top
> > > of an md device where the md device uses one or more files as backing store
> > > and with the loop driver between the md device and the files?
> > 
> > Nope not yet. It seems you have given this some thought though so you're 
> > help here is greatly appreciated. In fact the way we should see the long
> > term 'kill kthread freezing' effort should be a collaborative one. I've
> > never touched md, so folks more familiar with md should give this some
> > thought.
> > 
> > Can for instance md register_pm_notifier() and register_syscore_ops()
> > and do handy work to pause some work to replace kthread freezing?
> > Note that I believe a pm notifier is needed in case syscore_suspend()
> > is not called, say on a suspend fail.
> 
> Sorry but I don't think that a solution can be based on a notifier mechanism.
> Freezing has to happen in the order in which drivers and filesystems have
> been stacked (filesystem > md device > filesystem for the above example).

Yup, we need top down stack freezing. We get that at the filesystem
layer by the reverse order superblock iteration - that freezes newer
mounts before older mounts, so things like filesystems on loopback
freeze before the lower filesystem that hosts the loopback image.

I think what we need is the opposite of the "freeze_bdev()" interface.
That allows a block device to freeze the superblock on the block
device. i.e. when the block device needs to quiesce (e.g. for a
snapshot to be taken) it locks the filesystem and waits for it to
quiesce, then does what it needs to and unlocks the filesystem.

ISTM that you're asking for the opposite of this - a call that
allows the superblock to quiesce the underlying block device into a
known, unchanging state.  This would allow MD/dm to suspend whatever
on-going maintenance operations it has in progress until the
filesystem says "we need you to start again" when it gets a thaw
call....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
