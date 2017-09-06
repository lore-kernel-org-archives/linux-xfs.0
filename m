Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754364AbdIFRFm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Sep 2017 13:05:42 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v86H56LX080392
        for <linux-xfs@vger.kernel.org>; Wed, 6 Sep 2017 13:05:42 -0400
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ctj634r5t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 06 Sep 2017 13:05:42 -0400
Received: from localhost
        by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 7 Sep 2017 03:05:39 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH] loop: set physical block size to logical block size
Date: Wed, 06 Sep 2017 22:36:19 +0530
In-Reply-To: <8b3faca77b098c23827e48fc8f5b2ad973f3c23d.1504646604.git.osandov@fb.com>
References: <8b3faca77b098c23827e48fc8f5b2ad973f3c23d.1504646604.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <3802744.FJbvtTQ0bG@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-block@vger.kernel.org, kernel-team@fb.com, Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>, Karel Zak <kzak@redhat.com>, Milan Broz <gmazyland@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Wednesday, September 6, 2017 2:54:47 AM IST Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Commit 6c6b6f28b333 ("loop: set physical block size to PAGE_SIZE")
> caused mkfs.xfs to barf on ppc64 [1]. Always using PAGE_SIZE as the
> physical block size still makes the most sense semantically, but let's
> just lie and always set it to the same value as the logical block size
> (same goes for io_min). In the future we might want to at least bump up
> io_min to PAGE_SIZE but I'm sick of these stupid changes so let's play
> it safe.
> 

With this patch applied, On ppc64 I get,

# blockdev --getss /dev/loop0    
512                                                           
# blockdev --getpbsz /dev/loop0  
512                                                           

i.e. we are back to what was being reported before commit 6c6b6f28b333 
was applied.

I also executed xfstests on xfs filesystems with 4k and 32k block sizes and 
did not notice any regressions.

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan

