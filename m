Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35380 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966999AbeE2Vlo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 17:41:44 -0400
Subject: Re: [PATCH] xfs_repair: fix libxfs api violations in quota repair
 code
References: <6aeb5192-00b5-175d-fa3d-7864a2ba2d27@redhat.com>
 <20180529211436.GI30110@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <93767fbe-5715-a46f-0ae9-036daaa96d28@sandeen.net>
Date: Tue, 29 May 2018 16:41:42 -0500
MIME-Version: 1.0
In-Reply-To: <20180529211436.GI30110@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 5/29/18 4:14 PM, Darrick J. Wong wrote:
>>   					do_warn(_("Corrected.\n"));
>> -					xfs_dquot_repair(mp, &dqb->dd_diskdq, dqid, quota_type);
>> +					libxfs_dquot_repair(mp, &dqb->dd_diskdq,
>> +							    dqid, quota_type);
> Repair ought to check that return value, right?
> 
> --D
> 

yeah, though it only return 0 today.

And I need to refactor this for 4.18 to match kernel changes anyhoo so
it might go away, not sure.

Thanks,
-Eric
