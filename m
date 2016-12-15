Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757464AbcLOKYI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 05:24:08 -0500
Date: Thu, 15 Dec 2016 18:24:06 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: minleft fixes
Message-ID: <20161215102406.GJ28577@eguan.usersys.redhat.com>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <20161214105101.GD28577@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214105101.GD28577@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Dec 14, 2016 at 06:51:01PM +0800, Eryu Guan wrote:
> On Tue, Dec 13, 2016 at 04:59:23PM +0100, Christoph Hellwig wrote:
> > [now to the correct list address]
> > 
> > This is my attempt to fix the problems with rmap and reflink file system
> > running out of space during delayed extent conversions.  It turns out
> > the way minleft has been handled has always been bogus, but the rmap
> > enablement made it even worse..
> > 
> > This has survived xfstests xfs/109 on a 2k fs for 2 1/2 hour here now,
> > but Eryu was much better than me at reproducing the problems, so it could
> > use some further testing.
> > 
> 
> Test results looked good to me so far. It passed 200 iterations of
> xfs/109 with both xfs_2k_reflink and xfs_1k_reflink test configs. 

Results of full auto group runs with different test configs also look
good to me, I didn't notice any regression. Thanks!

Eryu
