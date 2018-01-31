Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:46904 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbeAaHey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jan 2018 02:34:54 -0500
MIME-Version: 1.0
In-Reply-To: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
References: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Jan 2018 09:34:52 +0200
Message-ID: <CAOQ4uxhYrpY=POeATvh6GOJLNEwDrsQhvAKvyZzwcUQXGwLvDA@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>

On Wed, Jan 31, 2018 at 5:56 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> Hi everyone!
>

Hi Allison!

> Recently I have been working towards adding a new parent pointer patch set
> to xfs.  Briefly summarized, goal of the feature is to enable an application
> to quickly derive an inodes path from the mount point by storing information
> about the inodes parent(s) in an extended attribute.  Currently, I am aware
> of the intent to use the feature as part of an online scrub and repair
> feature.  Looking forward however, I would like to know about any other
> future coding intents that might make use of this feature.  For example,
> optimizing file system shrink or exportfs operations?  Are there certain
> interfaces or test cases that would be helpful to have?

Parent pointers are going to be useful for exportfs reconnect operations.

The interesting test cases are decoding of directory file handles with
cold inode cache, where the decoded file handle is of a directory that
is nested inside a deep and wide directory tree.

Similarly, decoding a 'connectable' non-dir file handle for nfs export
of type 'subtree_check' also requires reconnecting the parent dir.

As far as I can tell, there are two relevant interfaces that could be improved
by parent pointers.

1. get_parent()+get_name()
These methods are used to get subdir's name in parent dir.
get_name() is not currently implemented in xfs.
get_name() has a default implementation of linear search on parent
directory entries.
parent pointers could improve this implementation from O(# parent entries)
to O(# parent xattrs), without the need to change the interface.
I advocated storing directory parent pointer also with a constant key (without
parent inode and offset), so that get_name() could be improved to O(1).

2. fh_to_parent()+get_name()
These methods are used to get a non-dir name in parent dir.
fh_to_parent() is implemented in xfs only if file handle was encoded as
'connectable' (FILEID_INO32_GEN_PARENT).
The problem with 'connectable' file handles from nfsd perspective is that
are not unique in some filesystems (xfs included).
With parent pointers, there is a potential to implement 'connectable' and
unique file handles, but that requires improving the interface.

If filesystem were to provide a parents iterator interface, something like:
get_acceptable_parent(child, acceptable, context)
then xfs could iterate inode parents and call the nfsd_acceptable() callback.
For filesystems that support get_acceptable_parent(), there is no need to
encode a 'connectable' non unique file handle.

I am not sure how much of a problem the 'subtree_check' and non-unique
file handle is for nfsd (CC nfsd folks for that), but I know I can make good use
of that in overlayfs, as well as with an optimized get_name() implementation.

Cheers,
Amir.
