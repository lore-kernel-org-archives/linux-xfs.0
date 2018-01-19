Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:51322 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753332AbeASOnv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jan 2018 09:43:51 -0500
Date: Fri, 19 Jan 2018 09:43:51 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v5 02/19] fs: don't take the i_lock in inode_inc_iversion
Message-ID: <20180119144351.GA11735@fieldses.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
 <20180109141059.25929-3-jlayton@kernel.org>
 <20180118214534.GB5299@fieldses.org>
 <1516372594.3588.11.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516372594.3588.11.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

On Fri, Jan 19, 2018 at 09:36:34AM -0500, Jeff Layton wrote:
> Shrug...we have that problem with the spinlock in place too. The bottom
> line is that reads of this value are not serialized with the increment
> at all.

OK, so this wouldn't even be a new bug.

> I'm not 100% thrilled with this patch, but I think it's probably better
> not to add the i_lock all over the place, even as an interim step in
> cleaning this stuff up.

Makes sense to me.

I've got no comments on the rest of the series, except that I'm all for
it.

Thanks for persisting--it turned out to be more involved than I'd
imagined!

--b.
