Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:41440 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932598AbdDESOK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 14:14:10 -0400
Date: Wed, 5 Apr 2017 14:14:09 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Message-ID: <20170405181409.GC28681@fieldses.org>
References: <1490122013.2593.1.camel@redhat.com>
 <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com>
 <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com>
 <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
 <20170404183138.GC14303@fieldses.org>
 <878tnfiq7v.fsf@notabene.neil.brown.name>
 <20170405080551.GC8899@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170405080551.GC8899@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: NeilBrown <neil@brown.name>, Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Apr 05, 2017 at 10:05:51AM +0200, Jan Kara wrote:
> 1) Keep i_version as is, make clients also check for i_ctime.

That would be a protocol revision, which we'd definitely rather avoid.

But can't we accomplish the same by using something like

	ctime * (some constant) + i_version

?

>    Pro: No on-disk format changes.
>    Cons: After a crash, i_version can go backwards (but when file changes
>    i_version, i_ctime pair should be still different) or not, data can be
>    old or not.

This is probably good enough for NFS purposes: typically on an NFS
filesystem, results of a read in the face of a concurrent write open are
undefined.  And writers sync before close.

So after a crash with a dirty inode, we're in a situation where an NFS
client still needs to resend some writes, sync, and close.  I'm OK with
things being inconsistent during this window.

I do expect things to return to normal once that client's has resent its
writes--hence the worry about actually resuing old values after boot
(such as if i_version regresses on boot and then increments back to the
same value after further writes).  Factoring in ctime fixes that.

> 2) Fsync when reporting i_version.
>    Pro: No on-disk format changes, strong consistency of i_version and
>         data.
>    Cons: Difficult to implement for filesystems due to locking constrains.
>          High performance overhead or i_version reporting.

Sounds painful.

> 3) Some variant of crash counter.
>    Pro: i_version cannot go backwards.
>    Cons: Requires on-disk format changes. After a crash data can be old
>          (however i_version increased).

Also, some unnecessary invalidations.  Which maybe can be mostly avoided
by some variation of Neil's scheme.

It looks to me like option (1) is doable now and introduces no
regressions compared to the current situation.  (2) and (3) are more
copmlicated and involve some tradeoffs.

Also, we can implement (1) and switch to (2) or (3) later.  We'd want to
do it without reported i_versions decreasing on kernel upgrade, but
there are multiple ways of handling that.  (Worst case, just restrict
the change to newly created filesystems.)

--b.
