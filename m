Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37080 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932707AbdIRRSv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 13:18:51 -0400
Subject: Re: [PATCH] xfs_repair: handle missing extent states
From: Eric Sandeen <sandeen@sandeen.net>
References: <20170918163944.GC6540@magnolia>
 <f19ea1b1-c86c-d745-b725-ac3befa5e0a3@sandeen.net>
Message-ID: <ffab0b07-0bdb-8514-dd20-2c1136ff5580@sandeen.net>
Date: Mon, 18 Sep 2017 12:18:50 -0500
MIME-Version: 1.0
In-Reply-To: <f19ea1b1-c86c-d745-b725-ac3befa5e0a3@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, amir73il@gmail.com



On 9/18/17 12:16 PM, Eric Sandeen wrote:
>> @@ -812,6 +813,12 @@ _("%s fork in %s inode %" PRIu64 " claims used block %" PRIu64 "\n"),
>>  					forkname, ftype, ino, b);
>>  				goto done;
>>  
>> +			case XR_E_COW:
>> +				do_warn(
>> +_("%s fork in %s inode %" PRIu64 " claims CoW block %" PRIu64 "\n"),
>> +					forkname, ftype, ino, b);
>> +				goto done;
>> +
> why do cow blocks get a special case and custom warning vs the above cases
> that just say "metadata?"
> 
> Obviously it's just nitpicking over the do_warn message string, just
> double checking on the consistency front. 

And this was also found via the rmap, but that fact isn't printed like
it is for every other type.  For that reason I'd probably rather just add
XR_RE_COW above the /* fallthrough */ too, for consistency.  Thoughts?

Thanks,
-Eric
