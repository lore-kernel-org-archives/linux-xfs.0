Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32992 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbeD1Gie (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Apr 2018 02:38:34 -0400
Date: Fri, 27 Apr 2018 23:38:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
Message-ID: <20180428063827.GD1661@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440961880.29601.15798100669042989214.stgit@magnolia>
 <20180423173257.GI834@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423173257.GI834@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 07:32:57PM +0200, Christoph Hellwig wrote:
> On Sun, Apr 22, 2018 at 08:06:58AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the _qm_dqread functionality to _qm_dqensure, then remove the flags
> > argument from xfs_qm_dqread since the only DQALLOC users were internal
> > to xfs_dquot.c anyway.
> 
> Unless this makes something much easier later in the series I'd rather
> not change the names and calling conventions here.  dqensure just sounds
> very weird, and having dqread is a trivial wrapper for it also doesn't
> seem to be very intuitive.

How about xfs_dquot_setup for a name instead of dqensure?

The purpose of making dqread a trivial wrapper is so that we can drop
the flags parameter from dqread which is always zero.  Later on in the
quotacheck repair patch I'll have a repair-specific use of the _setup
function and friends.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
