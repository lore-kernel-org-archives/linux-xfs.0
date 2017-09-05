Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34505 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751149AbdIEHg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2017 03:36:29 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v857XbZN007741
        for <linux-xfs@vger.kernel.org>; Tue, 5 Sep 2017 03:36:28 -0400
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2csq86hm3a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 05 Sep 2017 03:36:28 -0400
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 5 Sep 2017 17:36:25 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical sectorsize
Date: Tue, 05 Sep 2017 13:07:07 +0530
In-Reply-To: <20170905064208.GB15686@vader>
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com> <20170905063139.GA679@infradead.org> <20170905064208.GB15686@vader>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2656563.n056MvCHVb@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, linux-xfs@vger.kernel.org, sandeen@sandeen.net, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org

On Tuesday, September 5, 2017 12:12:08 PM IST Omar Sandoval wrote:
> On Mon, Sep 04, 2017 at 11:31:39PM -0700, Christoph Hellwig wrote:
> > On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
> > > Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
> > > physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
> > > physical sector size of loop devices. On ppc64, this causes loop devices
> > > to have 64k as the physical sector size.
> > 
> > Eek.  We'll need to revert the loop change ASAP!
> 
> Most annoying patch series ever. It hasn't made it to Linus' tree yet,
> right? We can revert (although the later change depends on that), fold
> in a fix, or apply a fix on top of it, whatever Jens prefers.
> 
> 

My bad. 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 is the commit id from 
Linux-next. I don't see this commit in Linus's git tree.

-- 
chandan

