Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60704 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164701AbeCBEFK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Mar 2018 23:05:10 -0500
Subject: Re: [PATCH] xfs_scrub: make interpreter explicit to python3
References: <20180224021512.23819-1-mcgrof@kernel.org>
 <20180224044018.GA19312@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4f0ac49f-8a87-4b69-8b06-43ca6b9930a0@sandeen.net>
Date: Thu, 1 Mar 2018 22:05:09 -0600
MIME-Version: 1.0
In-Reply-To: <20180224044018.GA19312@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org



On 2/23/18 10:40 PM, Darrick J. Wong wrote:
> On Fri, Feb 23, 2018 at 06:15:12PM -0800, Luis R. Rodriguez wrote:
>> Using #!/usr/bin/env makes some package dependency tools
>> such as rpm complain given that it cannot verify package
>> dependencies. Making it explicit resolves this lint rant.
>>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

intereting, my rpmbuild actually converts this on the fly.  ;)
But fine by me to hardcode it if Darrick says ok.  :)

Thanks,
-Eric

> --D
> 
>> ---
>>  scrub/xfs_scrub_all.in | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
>> index fff05da3ea7a..80f07d5c8b02 100644
>> --- a/scrub/xfs_scrub_all.in
>> +++ b/scrub/xfs_scrub_all.in
>> @@ -1,4 +1,4 @@
>> -#!/usr/bin/env python3
>> +#!/usr/bin/python3
>>  
>>  # Run online scrubbers in parallel, but avoid thrashing.
>>  #
>> -- 
>> 2.16.2
