Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46259 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbdK3Tmx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 14:42:53 -0500
Date: Thu, 30 Nov 2017 20:42:49 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Message-ID: <20171130194249.GK729@wotan.suse.de>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <1512061271.2774.10.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512061271.2774.10.camel@wdc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jgross@suse.com" <jgross@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "yu.chen.surf@gmail.com" <yu.chen.surf@gmail.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>

On Thu, Nov 30, 2017 at 05:01:13PM +0000, Bart Van Assche wrote:
> It's great to see that you are making progress with this work :-) However,
> what's not clear to me is what your (long-term) plan is for freezing
> filesystems that e.g. exist on top of a md RAID1 block device?

The original approach of doing a full swing kill on kthread freezing helpers
in one shot was too much. We must therefore approach this turtle style and
carefully. This patch series currently only addresses filesystems which
have a freeze_fs() callback implemented, that's it. The rest of the kernel
needs more work.

So this work is far as I've gotten so far.

Note, it does *not* remove the kthread freezing API calls on any other drivers,
as such that should still work.

> The md resync
> thread must be stopped before a system is frozen. Today the md driver uses
> the kthread freezing mechanism for that purpose. Do you have a plan for
> handling the more complicated scenarios, e.g. a filesystem that exists on top
> of an md device where the md device uses one or more files as backing store
> and with the loop driver between the md device and the files?

Nope not yet. It seems you have given this some thought though so you're 
help here is greatly appreciated. In fact the way we should see the long
term 'kill kthread freezing' effort should be a collaborative one. I've
never touched md, so folks more familiar with md should give this some
thought.

Can for instance md register_pm_notifier() and register_syscore_ops()
and do handy work to pause some work to replace kthread freezing?
Note that I believe a pm notifier is needed in case syscore_suspend()
is not called, say on a suspend fail.

> How about filesystems implemented in user space using the FUSE driver?

Not sure, someone more familiar with FUSE drivers should chime in. Right
now all this does is leverage filesystems which *do* implement freeze_fs()
only, and removes the kthread freezing calls after that. That's all. It
should not affect any other filesystems

Likewise consider filesystems that implement freeze_super() instead (like gfs2)
which don't hold sb->s_umount -- see commit 48b6bca6b7b8309 ("fs: add
freeze_super/thaw_super fs hooks"). If its desirable to address those as well,
it would seem a pair of non-locking iters somehow are needed. More work to
be done.

This all needs to be considered for the future as well.

> Patch 6/11 of this series freezes user space processes before freezing
> filesystems. Will that work for FUSE filesystems?

It doesn't add new code which should negatively affect FUSE drivers.
Long term if we wanted to address FUSE, it may require other work.

In the future then fs_suspend_freeze() may need to work for different
types of filesystems. Right now only filesystems which implement freeze_fs()
are addressed.

  Luis
