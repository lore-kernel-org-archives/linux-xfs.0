Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36116 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdJDQs7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Oct 2017 12:48:59 -0400
Date: Wed, 4 Oct 2017 12:48:39 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 4/5] ext4: add fs freezing support on suspend/hibernation
Message-ID: <20171004164839.zyfpx64qmmfv2jtx@thunk.org>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-5-mcgrof@kernel.org>
 <20171003195930.ivgaccdabxczar62@thunk.org>
 <20171003201321.GE2294@wotan.suse.de>
 <20171004014204.mztkdnm7wb7r6sl2@thunk.org>
 <20171004070523.GE3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004070523.GE3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 06:05:23PM +1100, Dave Chinner wrote:
> Basically, before thawing filesystems the rest of the kernel
> infrastructure needs to have been restarted. i.e. the order
> needs to be:
> 
> freeze userspace
> freeze filesystems
> freeze kernel threads
> freeze workqueues
> 
> thaw workqueues
> thaw kernel threads
> thaw filesystems
> thaw userspace
> 
> and it should end up that way.
> 
> > Or if we have a network block device, or
> > something else in the storage stack that needs to run a kernel thread
> > context (or a workqueue, etc.) --- is the fact that userspace is
> > frozen mean the scheduler is going to refuse to schedule()?
> 
> No.

Well, that's what the answer *should* be.  I was asking what this
patch series does, and given that Luis reported that with this patch
series ext4_commit_super(sb, 1) is hanging, I have my suspicions about
what the answer might be with this patch set.  (Especially since the
claimed goal of the patch set is, "kthread freezing with filesystem
freeze/thaw".

Cheers,

						- Ted
