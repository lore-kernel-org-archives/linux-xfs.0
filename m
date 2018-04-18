Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f44.google.com ([209.85.160.44]:33372 "EHLO
        mail-pl0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbeDRA7l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 20:59:41 -0400
Date: Tue, 17 Apr 2018 17:59:36 -0700
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 03/11] fs: add frozen sb state helpers
Message-ID: <20180418005936.j3fa5rogfm353clf@garbanzo.do-not-panic.com>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-4-mcgrof@kernel.org>
 <20171130171310.GG28180@quack2.suse.cz>
 <20171130190548.GJ729@wotan.suse.de>
 <20171201114724.GC8365@quack2.suse.cz>
 <20171201211327.GQ729@wotan.suse.de>
 <20171221110329.GG31584@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221110329.GG31584@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, jlayton@redhat.com

On Thu, Dec 21, 2017 at 12:03:29PM +0100, Jan Kara wrote:
> Hello,
> 
> I think I owe you a reply here... Sorry that it took so long.

Took me just as long :)

> On Fri 01-12-17 22:13:27, Luis R. Rodriguez wrote:
> > 
> > I'll note that its still not perfectly clear if really the semantics behind
> > freeze_bdev() match what I described above fully. That still needs to be
> > vetted for. For instance, does thaw_bdev() keep a superblock frozen if we
> > an ioctl initiated freeze had occurred before? If so then great. Otherwise
> > I think we'll need to distinguish the ioctl interface. Worst possible case
> > is that bdev semantics and in-kernel semantics differ somehow, then that
> > will really create a holy fucking mess.
> 
> I believe nobody really thought about mixing those two interfaces to fs
> freezing and so the behavior is basically defined by the implementation.
> That is:
> 
> freeze_bdev() on sb frozen by ioctl_fsfreeze() -> EBUSY

Note below as well on your *future* freeze_super() implementation.

> freeze_bdev() on sb frozen by freeze_bdev() -> success
> ioctl_fsfreeze() on sb frozen by freeze_bdev() -> EBUSY
> ioctl_fsfreeze() on sb frozen by ioctl_fsfreeze() -> EBUSY
> 
> thaw_bdev() on sb frozen by ioctl_fsfreeze() -> EINVAL

Phew, so this is what we want for the in-kernel freezing so we're good
and *can* combine these then.

> ioctl_fsthaw() on sb frozen by freeze_bdev() -> success
> 
> What I propose is the following API:
> 
> freeze_super_excl()
>   - freezes superblock, returns EBUSY if the superblock is already frozen
>     (either by another freeze_super_excl() or by freeze_super())
> freeze_super()
>   - this function will make sure superblock is frozen when the function
>     returns with success. 

That's straight forward.

>     It can be nested with other freeze_super() or
>     freeze_super_excl() calls 

This is where it can get hairy. More below.

>     (this second part is different from how
>     freeze_bdev() behaves currently but AFAICT this behavior is actually
>     what all current users of freeze_bdev() really want - just make sure
>     fs cannot be written to)

If we can agree to this, then sure. However there are two types of
possible nested calls to consider, one where the sb was already frozen
by an IOCTL, and the other where it was initiated by either another
freeze_super_excl() or another freeze_super() call which is currently
being processed. For the first type, its easy to say the device is
already frozen as such return success. If the freezing is ongoing,
we may want to wait or not wait, and this will depend on our current
use cases for freeze_bdev().

As you noted above, freeze_bdev() currently returns EBUSY if we had
the sb already frozen by ioctl_fsfreeze(). It may be a welcomed
enhancement to correct the semantics first to address the first case,
but keep the EBUSY for the other case. A secondary patch could then
add a completion mechanism and let callers decide to either wait or not.
*Iff* the caller did not opt-in to wait we keep the EBUSY return.

Seem reasonable?

I'll address the rest of the mail later.

  Luis
