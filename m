Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56410 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbeDEMhA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Apr 2018 08:37:00 -0400
Subject: Re: [PATCH 5/6] xfs: factor out quota time limit initialization
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <2d87ba58-f713-6326-8683-29185155ee58@sandeen.net>
 <20180405071533.GE17256@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0ca4f6ed-00db-ba87-c0ea-43c6f15068fa@sandeen.net>
Date: Thu, 5 Apr 2018 07:36:58 -0500
MIME-Version: 1.0
In-Reply-To: <20180405071533.GE17256@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 4/5/18 2:15 AM, Christoph Hellwig wrote:
> On Wed, Apr 04, 2018 at 02:10:20PM -0500, Eric Sandeen wrote:
>> Factor out the time limit initialization from
>> xfs_qm_init_quotainfo so that we can delay it until
>> after quotacheck - it requires reading the default disk
>> quotas, which may need repair.
>>
>> No functional changes in this patch.
> 
> You have 75 characters per line for your changelog, use them!

Sorry, bad habit.  I never remember exactly how many and sometimes I just
keep shortening...
 
The public shaming should help, I'll try to do better.  :)

-Eric

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
