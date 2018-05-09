Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38954 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755400AbeEIBkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 21:40:15 -0400
Date: Tue, 8 May 2018 18:39:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] vfs: skip extra attributes check on removal for symlinks
Message-ID: <20180509013944.GE11261@magnolia>
References: <20180426234639.12480-1-mcgrof@kernel.org>
 <20180501172319.GK4127@magnolia>
 <20180501174512.GA27853@wotan.suse.de>
 <20180508003055.GC11261@magnolia>
 <20180509000327.GJ27853@wotan.suse.de>
 <20180509001741.GB11261@magnolia>
 <20180509003855.GK27853@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509003855.GK27853@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, sandeen@sandeen.net, dhowells@redhat.com, tytso@mit.edu, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 09, 2018 at 12:38:55AM +0000, Luis R. Rodriguez wrote:
> On Tue, May 08, 2018 at 05:17:41PM -0700, Darrick J. Wong wrote:
> > On Wed, May 09, 2018 at 12:03:28AM +0000, Luis R. Rodriguez wrote:
> > > Groovy, thanks, let's not forget the xfs_repair respective fix :) let me know
> > > if you have any feedback on that.
> > 
> > TBH I've lost any proposed xfs_repair patches to the mists of time
> > because some patch volcano keeps erupting on the lists. :P
> > 
> > Uh... I think it's fine for xfs_{repair,scrub} to clear the immutable
> > and append flags on any special inodes it finds, particularly since
> > neither flag has any real meaning for block/char/fifo/socket/symlinks
> > anyway.
> 
> Sure, my point during review of that series for xfs_repair in particular
> though was that for symlinks the justification is different (half of the
> commit log in this new patch), as such I'd prefer to deal with them in a
> separate follow up patch.

Ah, found it again finally[1].  ISTR the discussion petered out after
Dave asked if you had a map of inode mode
(file/dir/bdev/cdev/fifo/socket/symlink) to allowable flags.  That would
be a good general way to detect and clear stray flags.

--D

[1] https://marc.info/?l=linux-xfs&m=150948985429374&w=4

>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
