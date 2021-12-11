Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599CEC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 05:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhLKFuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Dec 2021 00:50:46 -0500
Received: from sandeen.net ([63.231.237.45]:52326 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229502AbhLKFup (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Dec 2021 00:50:45 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B117E15B3D;
        Fri, 10 Dec 2021 23:46:55 -0600 (CST)
Message-ID: <a194a662-ff48-9ffc-a8ef-ad2c3726b878@sandeen.net>
Date:   Fri, 10 Dec 2021 23:47:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-2-git-send-email-sandeen@sandeen.net>
 <20211211001518.GA1218082@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/4] xfs_quota: document unit multipliers used in limit
 command
In-Reply-To: <20211211001518.GA1218082@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/10/21 6:15 PM, Darrick J. Wong wrote:
> On Fri, Dec 10, 2021 at 02:21:34PM -0600, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> The units used to set limits are never specified in the xfs_quota
>> man page, and in fact for block limits, the standard k/m/g/...
>> units are accepted. Document all of this.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>   man/man8/xfs_quota.8 | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
>> index 59e603f..f841e3f 100644
>> --- a/man/man8/xfs_quota.8
>> +++ b/man/man8/xfs_quota.8
>> @@ -446,7 +446,13 @@ option reports state on all filesystems and not just the current path.
>>   .I name
>>   .br
>>   Set quota block limits (bhard/bsoft), inode count limits (ihard/isoft)
>> -and/or realtime block limits (rtbhard/rtbsoft). The
>> +and/or realtime block limits (rtbhard/rtbsoft) to N, where N is a bare
> 
> What is a 'bare' number?
> 
> How about (shortened so I don't have to retype the whole thing):
> 
> "Set quota block limits...to N.  For block limits, N is a number
> with a s/b/k/m/g/t/p/e multiplication suffix..."

it's also allowed w/o the suffix. so I propose ...

Set quota block limits (bhard/bsoft), inode count limits (ihard/isoft)
+and/or realtime block limits (rtbhard/rtbsoft) to N, where N is a
number representing bytes or inodes.
+For block limits, a number with a s/b/k/m/g/t/p/e multiplication suffix
+as described in
+.BR mkfs.xfs (8)
+is also accepted.
For inode limits, no suffixes are allowed.

(I thought about adding suffix support to inodes but meh, that's confusing,
what is 1 block's worth of inodes?)

> 
> "For inode limits, N is a bare number; no suffixes are allowed."
> 
> ?
> 
> --D
> 
>> +number representing bytes or inodes.
>> +For block limits, a number with a s/b/k/m/g/t/p/e multiplication suffix
>> +as described in
>> +.BR mkfs.xfs (8)
>> +is also accepted.
>> +The
>>   .B \-d
>>   option (defaults) can be used to set the default value
>>   that will be used, otherwise a specific
>> -- 
>> 1.8.3.1
>>
> 
