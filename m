Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756897AbdAEBWB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 20:22:01 -0500
Date: Thu, 5 Jan 2017 09:21:59 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: minleft fixes V2
Message-ID: <20170105012159.GS1859@eguan.usersys.redhat.com>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482436822-31546-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Thu, Dec 22, 2016 at 09:00:17PM +0100, Christoph Hellwig wrote:
> his is my attempt to fix the problems with rmap and reflink file system
> running out of space during delayed extent conversions.  It turns out
> the way minleft has been handled has always been bogus, but the rmap
> enablement made it even worse..
> 
> This has survived xfstests xfs/109 on a 2k fs for a couple hours now
> but Eryu was much better than me at reproducing the problems, so it could
> use some further testing.

I applied this patchset on top of v4.10-rc2 kernel and ran xfs/109 with
my xfs_2k_reflink test config for 200 iterations, and all passed.

Thanks,
Eryu
