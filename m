Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936426AbdADPr4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 10:47:56 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6F524AD223C
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2017 09:45:48 -0600 (CST)
Subject: Re: [PATCH] Fix max_retries _show and _store functions
References: <20170103175331.8089-1-cmaiolino@redhat.com>
 <7818525d-fd15-d245-a958-1648b5df3ecd@sandeen.net>
 <20170104105840.mr54e3ypljphb2pd@eorzea.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6f9fcef4-bb02-148f-a339-d5b7396726b8@sandeen.net>
Date: Wed, 4 Jan 2017 09:46:21 -0600
MIME-Version: 1.0
In-Reply-To: <20170104105840.mr54e3ypljphb2pd@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 1/4/17 4:58 AM, Carlos Maiolino wrote:
> On Tue, Jan 03, 2017 at 12:19:53PM -0600, Eric Sandeen wrote:
>> On 1/3/17 11:53 AM, Carlos Maiolino wrote:
>>> max_retries _show and _store functions should test against cfg->max_retries,
>>> not cfg->retry_timeout
>>>
>>> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
>>
>> Whoever made those mistakes should be very ashamed.  ;)
>> I guess it was a cut and paste error.  :(
>>
>> This should probably cc: stable, too.
> 
> Yeah, I believe so,
> 
> maybe if I just forward the patch to stable might work? 

if cc: stable gets added when it's committed, that'll suffice.

-Eric

>>
>> Thanks,
>>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>>
>>> ---
>>>  fs/xfs/xfs_sysfs.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
>>> index 276d302..de6195e 100644
>>> --- a/fs/xfs/xfs_sysfs.c
>>> +++ b/fs/xfs/xfs_sysfs.c
>>> @@ -396,7 +396,7 @@ max_retries_show(
>>>  	int		retries;
>>>  	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
>>>  
>>> -	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
>>> +	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
>>>  		retries = -1;
>>>  	else
>>>  		retries = cfg->max_retries;
>>> @@ -422,7 +422,7 @@ max_retries_store(
>>>  		return -EINVAL;
>>>  
>>>  	if (val == -1)
>>> -		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
>>> +		cfg->max_retries = XFS_ERR_RETRY_FOREVER;
>>>  	else
>>>  		cfg->max_retries = val;
>>>  	return count;
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
