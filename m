Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751523AbeGAJ2Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Jul 2018 05:28:16 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w619Ns2G142029
        for <linux-xfs@vger.kernel.org>; Sun, 1 Jul 2018 05:28:15 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2jxqcpeqjy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sun, 01 Jul 2018 05:28:15 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 1 Jul 2018 10:28:13 +0100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: xfs: Deadlock between fs_reclaim and sb_internal
Date: Sun, 01 Jul 2018 15:00:01 +0530
In-Reply-To: <1583499.AKrs7invYa@localhost.localdomain>
References: <ee795573-6ab3-361a-d076-b464293bdcc4@linux.ibm.com> <1583499.AKrs7invYa@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1635784.85vFEPy9OU@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: darrick.wong@oracle.com, lkml <linux-kernel@vger.kernel.org>, allison.henderson@oracle.com, hch@lst.de, Michael Ellerman <mpe@ellerman.id.au>, linux-xfs@vger.kernel.org

On Friday, June 29, 2018 11:48:39 AM IST Chandan Rajendra wrote:
> On Thursday, June 28, 2018 9:31:32 AM IST Ravi Bangoria wrote:
> > Hello Darrick,
> > 
> > Lockdep is reporting a deadlock with following trace. Saw this on my
> > powerpc vm with 4GB of ram, running Linus/master kernel. Though, I
> > don't have exact testcase to reproduce it. Is this something known?
> 
> I am able to recreate this issue on a ppc64le guest. I will debug this
> and provide updates.
> 

Ravi,

The issue has already been reported earlier. See 
https://www.spinics.net/lists/linux-xfs/msg20036.html.
I am not familiar with Lockdep code and hence won't be able to help here.

-- 
chandan

