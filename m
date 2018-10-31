Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43959 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729014AbeJaKId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 06:08:33 -0400
Date: Wed, 31 Oct 2018 12:12:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: manual merge of the vfs tree with the xfs tree
Message-ID: <20181031011241.GV19305@dastard>
References: <20181031115247.6adcb659@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031115247.6adcb659@canb.auug.org.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>

On Wed, Oct 31, 2018 at 11:52:47AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> [I don't understand why all this new work turned up in the xfs tree
> during the merge window ...]
> 
> Today's linux-next merge of the vfs tree got a conflict in:
> 
>   fs/read_write.c
> 
> between commits:
> 
>   42ec3d4c0218 ("vfs: make remap_file_range functions take and return bytes completed")
>   eca3654e3cc7 ("vfs: enable remap callers that can handle short operations")
> 
> from the xfs tree and commit:
> 
>   5de4480ae7f8 ("vfs: allow dedupe of user owned read-only files")
> 
> from the vfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Looks ok. I didn't expect this conflict, but looks simple enough
to resolve. Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
