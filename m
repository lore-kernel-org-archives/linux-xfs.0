Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33300 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934808AbcKJQlw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Nov 2016 11:41:52 -0500
Subject: Re: [PATCH] xfs: add XBF_XBF_NO_IOACCT to buf trace output
References: <4074f575-f4cf-e8ee-7c79-0bbc45333f5d@redhat.com>
 <20161003153137.GA19245@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b972af02-9782-f63a-1b43-c84a7bed2fd3@sandeen.net>
Date: Thu, 10 Nov 2016 10:41:50 -0600
MIME-Version: 1.0
In-Reply-To: <20161003153137.GA19245@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On 10/3/16 10:31 AM, Brian Foster wrote:
> On Thu, Sep 08, 2016 at 04:53:28PM -0500, Eric Sandeen wrote:
>> When XBF_NO_IOACCT got added, it missed the translation
>> in XFS_BUF_FLAGS, so we see "0x8" in trace output rather
>> than the flag name.  Fix it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
> 
> Thought I caught that, apparently not. Thanks!
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Dave, ping on a merge for this?  It has Brian's review.

Thanks,
-Eric
 
>>
>> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
>> index 1c2e52b..424f6b0 100644
>> --- a/fs/xfs/xfs_buf.h
>> +++ b/fs/xfs/xfs_buf.h
>> @@ -71,6 +71,7 @@ typedef unsigned int xfs_buf_flags_t;
>>  	{ XBF_READ,		"READ" }, \
>>  	{ XBF_WRITE,		"WRITE" }, \
>>  	{ XBF_READ_AHEAD,	"READ_AHEAD" }, \
>> +	{ XBF_NO_IOACCT,	"NO_IOACCT" }, \
>>  	{ XBF_ASYNC,		"ASYNC" }, \
>>  	{ XBF_DONE,		"DONE" }, \
>>  	{ XBF_STALE,		"STALE" }, \
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
