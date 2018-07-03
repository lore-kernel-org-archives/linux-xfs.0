Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:38626 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934156AbeGCRFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 13:05:23 -0400
Subject: Re: [PATCH 1/2] fs: ext4: use BUG_ON if writepage call comes from
 direct reclaim
References: <1530591079-33813-1-git-send-email-yang.shi@linux.alibaba.com>
 <20180703103948.GB27426@thunk.org>
From: Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <6c305241-d502-b8ea-a187-54c33e4ca692@linux.alibaba.com>
Date: Tue, 3 Jul 2018 10:05:04 -0700
MIME-Version: 1.0
In-Reply-To: <20180703103948.GB27426@thunk.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, mgorman@techsingularity.net, adilger.kernel@dilger.ca, darrick.wong@oracle.com, dchinner@redhat.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



On 7/3/18 3:39 AM, Theodore Y. Ts'o wrote:
> On Tue, Jul 03, 2018 at 12:11:18PM +0800, Yang Shi wrote:
>> direct reclaim doesn't write out filesystem page, only kswapd could do
>> it. So, if the call comes from direct reclaim, it is definitely a bug.
>>
>> And, Mel Gormane also mentioned "Ultimately, this will be a BUG_ON." In
>> commit 94054fa3fca1fd78db02cb3d68d5627120f0a1d4 ("xfs: warn if direct
>> reclaim tries to writeback pages").
>>
>> Although it is for xfs, ext4 has the similar behavior, so elevate
>> WARN_ON to BUG_ON.
>>
>> And, correct the comment accordingly.
>>
>> Cc: Mel Gorman <mgorman@techsingularity.net>
>> Cc: "Theodore Ts'o" <tytso@mit.edu>
>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> What's the upside of crashing the kernel if the file sytsem can handle it?

I'm not sure if it is a good choice to let filesystem handle such vital 
VM regression. IMHO, writing out filesystem page from direct reclaim 
context is a vital VM bug. It means something is definitely wrong in VM. 
It should never happen.

It sounds ok to have filesystem throw out warning and handle it, but I'm 
not sure if someone will just ignore the warning, but it should *never* 
be ignored.

Yang

>
>         	   	     	      	  	    - Ted

