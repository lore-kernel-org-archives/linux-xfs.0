Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35995 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752310AbdG1OqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2017 10:46:01 -0400
Received: by mail-wr0-f169.google.com with SMTP id y43so155970474wrd.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2017 07:46:00 -0700 (PDT)
Subject: Re: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-2-jtulak@redhat.com>
 <20170727162752.GK18884@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <0c34504a-923a-20ac-9f03-6972e38bbfde@redhat.com>
Date: Fri, 28 Jul 2017 16:45:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170727162752.GK18884@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org



On 27/07/2017 18:27, Luis R. Rodriguez wrote:
> On Thu, Jul 20, 2017 at 11:29:26AM +0200, Jan Tulak wrote:
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index a69190b9..4b030101 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -107,6 +107,11 @@ unsigned int		sectorsize;
>>    *     sets what is used with simple specifying the subopt (-d file).
>>    *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
>>    *     value in any case.
>> + *
>> + *   raw_input INTERNAL
>> + *     Filled raw string from the user, so we never lose that information e.g.
>> + *     to print it back in case of an issue.
>> + *
>>    */
>>   struct opt_params {
>>   	const char	name;
>> @@ -122,6 +127,7 @@ struct opt_params {
>>   		long long	minval;
>>   		long long	maxval;
>>   		long long	defaultval;
>> +		const char	*raw_input;
>>   	}		subopt_params[MAX_SUBOPTS];
>>   };
>>   
>> @@ -729,6 +735,18 @@ struct opt_params mopts = {
>>    */
>>   #define WHACK_SIZE (128 * 1024)
>>   
>> +static inline void
>> +set_conf_raw(struct opt_params *opt, int subopt, const char *value)
>> +{
>> +	opt->subopt_params[subopt].raw_input = value;
>> +}
> There are no bounds check on the array here, I think set_conf_raw()
> should return int and we would check the return value. It could
> return -EINVAL if the subopt is invalid for instance.
Good idea. The only issue is with the return code, that causes some 
issues when we are also returning values - I wanted the values to be 
turned into uint64. But do we need to return an error? I don't see what 
usecase there would be for it, other than detecting a bug. So an assert 
might be a better solution - then it can't happen that a wrong index is 
used and result not tested.
>> +
>> +static inline const char *
>> +get_conf_raw(const struct opt_params *opt, int subopt)
>> +{
>> +	return opt->subopt_params[subopt].raw_input;
>> +}
>> +
>>   /*
>>    * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
> These are not pass by value.
>
> The usage of set_conf_raw() and get_conf_raw() therefore have strict
> constraints and can be only used within certain contexts:
>
>    o Since they are pointers the lifetime usage of these functions
>      are limited to the lifetime of the pointers
>    o Since they are *currently* used on main() this is fine but this would
>      limit its use. In the future if we want to defer access to these
>      pointers outside of main() or if main() uses a library which would
>      parse some string and free it we'd have to make another change
>      yet again.
>
> Even if its *OK* today, if some helpers are used later which for instance call
> set_conf_raw() and then free the passed pointer right away we are screwed,
> leading to potentially using random values.  An alternative to limiting the use
> of these routines would be to instead have set_conf_raw() to use strdup() and
> have it return an int in case of -ENOMEM.
>
>    Luis

Sounds reasonable.

Jan
