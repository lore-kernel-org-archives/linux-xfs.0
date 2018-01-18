Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:49802 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753791AbeARViW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 16:38:22 -0500
Date: Thu, 18 Jan 2018 16:38:21 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v5 01/19] fs: new API for handling inode->i_version
Message-ID: <20180118213821.GA5299@fieldses.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
 <20180109141059.25929-2-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109141059.25929-2-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

On Tue, Jan 09, 2018 at 09:10:41AM -0500, Jeff Layton wrote:
> --- /dev/null
> +++ b/include/linux/iversion.h
> @@ -0,0 +1,236 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_IVERSION_H
> +#define _LINUX_IVERSION_H
> +
> +#include <linux/fs.h>
> +
> +/*
> + * The change attribute (i_version) is mandated by NFSv4 and is mostly for
> + * knfsd, but is also used for other purposes (e.g. IMA). The i_version must
> + * appear different to observers if there was a change to the inode's data or
> + * metadata since it was last queried.
> + *
> + * Observers see the i_version as a 64-bit number that never changes.

I don't understand that sentence.

> If it
> + * remains the same since it was last checked, then nothing has changed in the
> + * inode. If it's different then something has changed. Observers cannot infer
> + * anything about the nature or magnitude of the changes from the value, only
> + * that the inode has changed in some fashion.

As we've discussed before, there may be brief windows where the first
two statements aren't quite correct.  I think that would be worth a
mention if we can keep it concise.  Maybe add something like this?:

	It may be impractical for filesystems to keep i_version updates
	atomic with respect to the changes that cause them.  They
	should, however, guarantee that i_version updates are never
	visible before the changes that caused them.  Also, i_version
	updates should never be delayed longer than it takes the
	original change to reach disk.

Or maybe those details are best left to documentation on the relevant
parts of the api below (maybe inode_maybe_inc_iversion?).

I dunno if it's also worth mentioning that nfsd doesn't actually use the
raw i_version--it mixes it with ctime to prevent i_version reuse after
reboot.  Presumably that doesn't matter to IMA since it doesn't compare
i_version across reboots.

The documentation here is all very helpful, thanks.

--b.
