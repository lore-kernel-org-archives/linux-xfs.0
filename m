Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58167 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbfCOGlp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Mar 2019 02:41:45 -0400
Date: Fri, 15 Mar 2019 17:41:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 6ef50fe9afae
Message-ID: <20190315064141.GM23020@dastard>
References: <20190313163243.GI4359@magnolia>
 <20190315035036.GN7200@dhcp-12-102.nay.redhat.com>
 <20190315053423.GH4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315053423.GH4929@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Zorro Lang <zlang@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 14, 2019 at 10:34:23PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 15, 2019 at 11:50:36AM +0800, Zorro Lang wrote:
> > On Wed, Mar 13, 2019 at 09:32:43AM -0700, Darrick J. Wong wrote:
> > [3]
> > And Hit once generic/475 dmesg error on x86_64:
> > [29451.222118] XFS (dm-0): xfs_dabuf_map: bno 16777216 dir: inode 16797760
> > [29451.222123] XFS (dm-0): [00] br_startoff 16777216 br_startblock -2 br_blockcount 2 br_state 0
> 
> Hmm, a directory missing its bestfree blocks?
> 
> /me vaguely recalls arekm or someone had this failure a couple of weeks
> ago, but I've never seen 475 do this to me.

No, that was missing a the hash index tree root (block at 8MiFSB,
not 16MiFSB). Similar, but not the same.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
