Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:36048 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbeEKCmj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 22:42:39 -0400
Date: Fri, 11 May 2018 03:42:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] vfs: skip extra attributes check on removal for symlinks
Message-ID: <20180511024234.GA30522@ZenIV.linux.org.uk>
References: <20180426234639.12480-1-mcgrof@kernel.org>
 <20180510204807.GV30522@ZenIV.linux.org.uk>
 <20180510230551.GE27853@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510230551.GE27853@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, sandeen@sandeen.net, darrick.wong@oracle.com, dhowells@redhat.com, tytso@mit.edu, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, May 10, 2018 at 11:05:51PM +0000, Luis R. Rodriguez wrote:
> On Thu, May 10, 2018 at 09:48:07PM +0100, Al Viro wrote:
> > On Thu, Apr 26, 2018 at 04:46:39PM -0700, Luis R. Rodriguez wrote:
> > 
> > > Since we cannot set these attributes we should special-case the
> > > immutable/append on delete for symlinks, this would be consistent with
> > > what we *do* allow on Linux for all filesystems.
> > 
> > Er...  So why not simply sanity-check it in places that set it on
> > inodes? 
> 
> The patch is not about sanity-checks on setters though as *that* is in place
> already. Its about the case where the filesystem gets corrupted and the VFS
> *still* does process these attributes for symlinks and still prevents
> deletion because of these attributes.

... and this corrupted fs ends up setting those flags on in-core inodes.
Which is where we ought to block that.  Seriously, let's make sure that
->i_flags manipulations are done by inode_set_flags() (e.g. btrfs open-codes
that, apparently) and let's make _that_ check and reject those.
