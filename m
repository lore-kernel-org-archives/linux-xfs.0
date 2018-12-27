Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43372 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbeL0NrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Dec 2018 08:47:12 -0500
Date: Thu, 27 Dec 2018 16:40:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 00/20] drop useless LIST_HEAD
Message-ID: <20181227134055.GA2272@kadam>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <CAKR_QVJefW1vxYb7-qiU8=0YdbFghYo15SK2eGjOC-dntRfyYA@mail.gmail.com>
 <alpine.DEB.2.21.1812232304130.2940@hadrien>
 <CAKR_QVLeZBL43W4x1mzcfcakSZyyh9L81vgUMxfnSccKawEfdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVLeZBL43W4x1mzcfcakSZyyh9L81vgUMxfnSccKawEfdg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-janitors@vger.kernel.org, dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>, xen-devel@lists.xenproject.org, linux-wireless@vger.kernel.org

On Tue, Dec 25, 2018 at 11:12:20PM +0100, Tom Psyborg wrote:
> there was discussion about this just some days ago. CC 4-5 lists is
> more than enough
> 

I don't know who you were discussing this with...

You should CC the 0th patch to all the mailinglists.  That much is a
clear rule.

For the rest, Julia's position is the more conservative one.  I was in
a conversation in RL and they were like, "CC everyone for all the
patches".  It depends on the context, of course.  If the patches are
dependent on each other then you *have* to CC everyone for everything.

If we really have other clear rules, then it should be encoded into
get_maintainer.pl so that it's automatic.

My other question is why do the linux-arm-kernel@lists.infradead.org
people feel like they need to be CC'd about every driver???  I always
remove them from the CC list unless it's an arch/arm issue.

regards,
dan carpenter

PS:  Please, no more top posting.
