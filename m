Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751133AbdINGzS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2017 02:55:18 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8E6s4WH076902
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2017 02:55:17 -0400
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cygduayxk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2017 02:55:17 -0400
Received: from localhost
        by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 14 Sep 2017 16:55:14 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [BUG] xfs/104 triggered NULL pointer dereference in iomap  based dio
Date: Thu, 14 Sep 2017 12:25:57 +0530
In-Reply-To: <20170913165546.GA18388@lst.de>
References: <20170913105823.GD8034@eguan.usersys.redhat.com> <8010113.2DyTjQuL2r@localhost.localdomain> <20170913165546.GA18388@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1565818.oNrvGvf46j@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Wednesday, September 13, 2017 10:25:46 PM IST Christoph Hellwig wrote:
> Does it work fine if you call sb_init_dio_done_wq unconditionally?
> 
> 

Yes, The issue isn't recreated when sb_init_dio_done_wq() is 
invoked unconditionally.

-- 
chandan

