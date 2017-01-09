Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47494 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdAIVcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 16:32:33 -0500
Date: Mon, 9 Jan 2017 13:32:28 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/7] common: add leading underscore to get_block_size
Message-ID: <20170109213228.GE14038@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
 <148357828858.7677.1046746692994559684.stgit@birch.djwong.org>
 <20170109102044.GE1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170109102044.GE1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Jan 09, 2017 at 06:20:44PM +0800, Eryu Guan wrote:
> On Wed, Jan 04, 2017 at 05:04:48PM -0800, Darrick J. Wong wrote:
> > Add a leading underscore to the get_block_size helper since it's a
> > common function.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's a new user of get_block_size, after latest fstests update,
> btrfs/012. I can fold the btrfs/012 update to this patch.

Ok.  Assuming you've already done this, I won't repost this patch.

(Though if I end up reposting the whole series then the patch in the new
series will of course have a diff for btrfs/012.)

--D

> 
> Thanks for doing this!
> 
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
