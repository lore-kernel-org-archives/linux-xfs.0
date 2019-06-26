Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58644 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfFZC4w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jun 2019 22:56:52 -0400
Subject: Re: [PATCH] mkfs: remove useless log options in usage
References: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
 <20190612150155.GA3773859@magnolia> <5D12CD78.8080208@cn.fujitsu.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <173a9f33-57b9-91c3-ea35-f965e5a62643@sandeen.net>
Date: Tue, 25 Jun 2019 21:56:49 -0500
MIME-Version: 1.0
In-Reply-To: <5D12CD78.8080208@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>



On 6/25/19 8:42 PM, Yang Xu wrote:
> on 2019/06/12 23:01, Darrick J. Wong wrote:
> 
>> On Wed, Jun 12, 2019 at 05:09:35PM +0800, Yang Xu wrote:
>>> Since commit 2cf637cf(mkfs: remove logarithm based CLI options),
>>> xfsprogs has discarded log options in node_options, remove it in usage.
>>>
>>> Signed-off-by: Yang Xu<xuyang2018.jy@cn.fujitsu.com>
>> Looks ok,
>> Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
>>
>> --D
>>
> Hi sandeen
> 
> My patch missed for xfsprogs for-next branch 8bfb5eac.
> By the way, the patch only removes useless log usage in inode option.
> So I think we don't need to resubmit it again.

Thanks for the reminder and sorry for missing it.  Funny, I tried to fix
this too but missed some ;)

I'll get it in the next push.

commit c66bd30ed7aecb429cfe3400c32892d7bc78e75b
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Jan 4 13:56:29 2018 -0600

    mkfs: un-document removed logarithm based CLI options
    
    Remove logarithm-based options from usage() and manpage.
    
    Fixes: 70f72d5 "mkfs: remove logarithm based CLI options"
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
