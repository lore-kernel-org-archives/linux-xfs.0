Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:17707 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdAECDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 21:03:47 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v05237es028127
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 5 Jan 2017 02:03:07 GMT
Date: Wed, 4 Jan 2017 18:01:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: minleft fixes V2
Message-ID: <20170105020105.GC17846@birch.djwong.org>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <20170105012159.GS1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170105012159.GS1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jan 05, 2017 at 09:21:59AM +0800, Eryu Guan wrote:
> On Thu, Dec 22, 2016 at 09:00:17PM +0100, Christoph Hellwig wrote:
> > his is my attempt to fix the problems with rmap and reflink file system
> > running out of space during delayed extent conversions.  It turns out
> > the way minleft has been handled has always been bogus, but the rmap
> > enablement made it even worse..
> > 
> > This has survived xfstests xfs/109 on a 2k fs for a couple hours now
> > but Eryu was much better than me at reproducing the problems, so it could
> > use some further testing.
> 
> I applied this patchset on top of v4.10-rc2 kernel and ran xfs/109 with
> my xfs_2k_reflink test config for 200 iterations, and all passed.

Ok, sounds good.  I just sent out my first attempt at a pull request to Linus,
so I'll queue this series for another pull req. after that.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
