Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751812AbeAJOMp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jan 2018 09:12:45 -0500
MIME-Version: 1.0
In-Reply-To: <20180109141059.25929-20-jlayton@kernel.org>
References: <20180109141059.25929-1-jlayton@kernel.org> <20180109141059.25929-20-jlayton@kernel.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Wed, 10 Jan 2018 15:12:42 +0100
Message-ID: <CAJKOXPckGaNF0HTqLMzxJKg_r4r7HZy9GFoOUs_vxeZfa_kb=A@mail.gmail.com>
Subject: Re: [PATCH v5 19/19] fs: handle inode->i_version more efficiently
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Tue, Jan 9, 2018 at 3:10 PM, Jeff Layton <jlayton@kernel.org> wrote:
> From: Jeff Layton <jlayton@redhat.com>
>
> Since i_version is mostly treated as an opaque value, we can exploit that
> fact to avoid incrementing it when no one is watching. With that change,
> we can avoid incrementing the counter on writes, unless someone has
> queried for it since it was last incremented. If the a/c/mtime don't
> change, and the i_version hasn't changed, then there's no need to dirty
> the inode metadata on a write.
>
> Convert the i_version counter to an atomic64_t, and use the lowest order
> bit to hold a flag that will tell whether anyone has queried the value
> since it was last incremented.
>
> When we go to maybe increment it, we fetch the value and check the flag
> bit.  If it's clear then we don't need to do anything if the update
> isn't being forced.
>
> If we do need to update, then we increment the counter by 2, and clear
> the flag bit, and then use a CAS op to swap it into place. If that
> works, we return true. If it doesn't then do it again with the value
> that we fetch from the CAS operation.
>
> On the query side, if the flag is already set, then we just shift the
> value down by 1 bit and return it. Otherwise, we set the flag in our
> on-stack value and again use cmpxchg to swap it into place if it hasn't
> changed. If it has, then we use the value from the cmpxchg as the new
> "old" value and try again.
>
> This method allows us to avoid incrementing the counter on writes (and
> dirtying the metadata) under typical workloads. We only need to increment
> if it has been queried since it was last changed.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/fs.h       |   2 +-
>  include/linux/iversion.h | 210 ++++++++++++++++++++++++++++++++++-------------
>  2 files changed, 155 insertions(+), 57 deletions(-)

Works fine on my nfsroot configuration so looks like the issues from
v4 are gone. FWIW:
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
