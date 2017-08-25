Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54370 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750751AbdHYEC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2017 00:02:28 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7P40NHe002957
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 00:02:27 -0400
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cjbscjfkc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2017 00:02:27 -0400
Received: from localhost
        by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <khandual@linux.vnet.ibm.com>;
        Fri, 25 Aug 2017 14:02:24 +1000
Subject: Re: [PATCH] xfs: Drop setting redundant PF_KSWAPD in kswapd context
References: <20170824104247.8288-1-khandual@linux.vnet.ibm.com>
 <20170824105635.GA5965@dhcp22.suse.cz> <20170825000137.GI21024@dastard>
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Fri, 25 Aug 2017 09:32:14 +0530
MIME-Version: 1.0
In-Reply-To: <20170825000137.GI21024@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Message-Id: <f60c57f4-c7e2-9ae0-38e8-80c3f77f65e0@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>, linux-mm@kvack.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, dchinner@redhat.com, bfoster@redhat.com, sandeen@sandeen.net

On 08/25/2017 05:31 AM, Dave Chinner wrote:
> On Thu, Aug 24, 2017 at 12:56:35PM +0200, Michal Hocko wrote:
>> On Thu 24-08-17 16:12:47, Anshuman Khandual wrote:
>>> xfs_btree_split() calls xfs_btree_split_worker() with args.kswapd set
>>> if current->flags alrady has PF_KSWAPD. Hence we should not again add
>>> PF_KSWAPD into the current flags inside kswapd context. So drop this
>>> redundant flag addition.
>>
>> I am not familiar with the code but your change seems incorect. The
>> whole point of args->kswapd is to convey the kswapd context to the
>> worker which is obviously running in a different context. So this patch
>> loses the kswapd context.
> 
> Yup. That's what the code does, and removing the PF_KSWAPD from it
> will break it.

The worker thread need to inherit these flags. Thanks for pointing out.

