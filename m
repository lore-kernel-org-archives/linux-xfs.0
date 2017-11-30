Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43128 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750932AbdK3TFw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 14:05:52 -0500
Date: Thu, 30 Nov 2017 20:05:48 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 03/11] fs: add frozen sb state helpers
Message-ID: <20171130190548.GJ729@wotan.suse.de>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-4-mcgrof@kernel.org>
 <20171130171310.GG28180@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130171310.GG28180@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 30, 2017 at 06:13:10PM +0100, Jan Kara wrote:
> ... I dislike the _by_user() suffix as there may be different places that
> call freeze_super() (e.g. device mapper does this during some operations).
> Clearly we need to distinguish "by system suspend" and "the other" cases.
> So please make this clear in the naming.

Ah. How about sb_frozen_by_cb() ?

> In fact, what might be a cleaner solution is to introduce a 'freeze_count'
> for superblock freezing (we already do have this for block devices). Then
> you don't need to differentiate these two cases - but you'd still need to
> properly handle cleanup if freezing of all superblocks fails in the middle.
> So I'm not 100% this works out nicely in the end. But it's certainly worth
> a consideration.

Ah, there are three important reasons for doing it the way I did it which are
easy to miss, unless you read the commit log message very carefully.

0) The ioctl interface causes a failure to be sent back to userspace if
you issue two consecutive freezes, or two thaws. Ie, once a filesystem is
frozen, a secondary call will result in an error. Likewise for thaw.

1) The new iterate supers stuff I added bail on the first error and return that
error. If we kept the ioctl() interface error scheme we'd be erroring out
if on suspend if userspace had already frozen a filesystem. Clearly that'd
be silly so we need to distinguish between the automatic kernel freezing
and the old userspace ioctl initiated interface, so that we can keep the
old behaviour but allow in-kernel auto freeze on suspend to work properly.

2) If we fail to suspend we need to then thaw up all filesystems. The order
in which we try to freeze is in reverse order on the super_block list. If we
fail though we iterate in proper order on the super_block list and thaw. If
you had two filesystems this means that if a failure happened on freezing
the first filesystem, we'd first thaw the other filesystem -- and because of
0) if we don't distinguish between the ioctl interface or auto freezing, we'd
also fail on thaw'ing given the other superblock wouldn't have been frozen.

So we need to keep two separate approaches. The count stuff would not suffice
to distinguish origin of source for freeze call.

Come to think of it, I think I forgot to avoid thaw if the freeze was ioctl
initiated..

thaw_unlocked(bool cb_call)
{
  if (sb_frozen_by_cb(sb) && !cb_call)
    return 0; /* skip as the user wanted to keep this fs frozen */
  ...
}

Even though the kernel auto call is new I think we need to keep ioctl initiated
frozen filesystems frozen to not break old userspace assumptions.

So, keeping all this in mind, does a count method still suffice?

  Luis
