Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753100AbcLNKvF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 05:51:05 -0500
Date: Wed, 14 Dec 2016 18:51:01 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: minleft fixes
Message-ID: <20161214105101.GD28577@eguan.usersys.redhat.com>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481644767-9098-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Dec 13, 2016 at 04:59:23PM +0100, Christoph Hellwig wrote:
> [now to the correct list address]
> 
> This is my attempt to fix the problems with rmap and reflink file system
> running out of space during delayed extent conversions.  It turns out
> the way minleft has been handled has always been bogus, but the rmap
> enablement made it even worse..
> 
> This has survived xfstests xfs/109 on a 2k fs for 2 1/2 hour here now,
> but Eryu was much better than me at reproducing the problems, so it could
> use some further testing.
> 

Test results looked good to me so far. It passed 200 iterations of
xfs/109 with both xfs_2k_reflink and xfs_1k_reflink test configs. 

Thanks,
Eryu
