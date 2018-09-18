Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbeISAWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 20:22:04 -0400
Date: Tue, 18 Sep 2018 11:48:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfsprogs libxfs-4.19-sync branch pushed
Message-ID: <20180918184800.GF20086@magnolia>
References: <d461e927-5b07-c72b-9dac-c82a4336a272@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d461e927-5b07-c72b-9dac-c82a4336a272@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Sep 17, 2018 at 09:16:10PM -0500, Eric Sandeen wrote:
> Hi all -
> 
> Sorry for the delay, but a preliminary libxfs-4.19-sync branch has
> been pushed up to the xfsprogs repository on kernel.org.  The 
> top commit is
> 
> The head of the libxfs-4.19-sync branch is commit:
> 
> b53f016 xfs: fix a null pointer dereference in xfs_bmap_extents_to_btree
> 
> This passed basic sanity checks, now I'll go see what all differs
> in Darrick's tree that he did similar work in ~1 month ago...

<urk> I had a bunch of cleanups for the userspace transaction code that
wanted to go in before the merge... sigh.

Well I guess I'll send them as a start and we can decide what to do about it.

--D

> Assuming it doesn't have any brown paper bags, I'd suggest basing any
> xfsprogs-4.19 patches on this branch now.
> 
> Thanks,
> -Eric
> 
