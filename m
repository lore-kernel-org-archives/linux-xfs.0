Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60170 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750717AbdCBGtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2017 01:49:01 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v226mf0g144574
        for <linux-xfs@vger.kernel.org>; Thu, 2 Mar 2017 01:49:00 -0500
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28wxrc15vh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2017 01:49:00 -0500
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <khandual@linux.vnet.ibm.com>;
        Thu, 2 Mar 2017 16:48:57 +1000
Subject: Re: mm allocation failure and hang when running xfstests generic/269
 on xfs
References: <20170301044634.rgidgdqqiiwsmfpj@XZHOUW.usersys.redhat.com>
 <20170302003731.GB24593@infradead.org>
 <20170302051900.ct3xbesn2ku7ezll@XZHOUW.usersys.redhat.com>
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Thu, 2 Mar 2017 12:17:47 +0530
MIME-Version: 1.0
In-Reply-To: <20170302051900.ct3xbesn2ku7ezll@XZHOUW.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Message-Id: <d4c2cf89-8d82-ea78-b742-5bf6923a69c1@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiong Zhou <xzhou@redhat.com>, Christoph Hellwig <hch@infradead.org>, mhocko@suse.com
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 03/02/2017 10:49 AM, Xiong Zhou wrote:
> On Wed, Mar 01, 2017 at 04:37:31PM -0800, Christoph Hellwig wrote:
>> On Wed, Mar 01, 2017 at 12:46:34PM +0800, Xiong Zhou wrote:
>>> Hi,
>>>
>>> It's reproduciable, not everytime though. Ext4 works fine.
>> On ext4 fsstress won't run bulkstat because it doesn't exist.  Either
>> way this smells like a MM issue to me as there were not XFS changes
>> in that area recently.
> Yap.
> 
> First bad commit:
> 
> commit 5d17a73a2ebeb8d1c6924b91e53ab2650fe86ffb
> Author: Michal Hocko <mhocko@suse.com>
> Date:   Fri Feb 24 14:58:53 2017 -0800
> 
>     vmalloc: back off when the current task is killed
> 
> Reverting this commit on top of
>   e5d56ef Merge tag 'watchdog-for-linus-v4.11'
> survives the tests.

Does fsstress test or the system hang ? I am not familiar with this
code but If it's the test which is getting hung and its hitting this
new check introduced by the above commit that means the requester is
currently being killed by OOM killer for some other memory allocation
request. Then is not this kind if memory alloc failure expected ?

