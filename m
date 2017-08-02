Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:38358 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdHBPvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2017 11:51:51 -0400
Received: by mail-wr0-f172.google.com with SMTP id f21so20318393wrf.5
        for <linux-xfs@vger.kernel.org>; Wed, 02 Aug 2017 08:51:50 -0700 (PDT)
Subject: Re: [PATCH 1/7] mkfs: Save raw user input field to the opts struct
From: Jan Tulak <jtulak@redhat.com>
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-2-jtulak@redhat.com>
 <20170727162752.GK18884@wotan.suse.de>
 <0c34504a-923a-20ac-9f03-6972e38bbfde@redhat.com>
 <20170729171207.GN18884@wotan.suse.de>
 <723e3733-0a80-1bf2-89ed-e80b914037ed@redhat.com>
Message-ID: <8374a422-83e6-1426-1548-721da2cb8782@redhat.com>
Date: Wed, 2 Aug 2017 17:51:47 +0200
MIME-Version: 1.0
In-Reply-To: <723e3733-0a80-1bf2-89ed-e80b914037ed@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

An addendum to the previous email.

On 02/08/2017 16:30, Jan Tulak wrote:
> On 29/07/2017 19:12, Luis R. Rodriguez wrote:
>> On Fri, Jul 28, 2017 at 04:45:58PM +0200, Jan Tulak wrote:
>>>
>>> On 27/07/2017 18:27, Luis R. Rodriguez wrote:
>>>> On Thu, Jul 20, 2017 at 11:29:26AM +0200, Jan Tulak wrote:
>>>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>>>> index a69190b9..4b030101 100644
>>>>> --- a/mkfs/xfs_mkfs.c
>>>>> +++ b/mkfs/xfs_mkfs.c
>>>>> @@ -107,6 +107,11 @@ unsigned int        sectorsize;
>>>>>     *     sets what is used with simple specifying the subopt (-d 
>>>>> file).
>>>>>     *     A special SUBOPT_NEEDS_VAL can be used to require a 
>>>>> user-given
>>>>>     *     value in any case.
>>>>> + *
>>>>> + *   raw_input INTERNAL
>>>>> + *     Filled raw string from the user, so we never lose that 
>>>>> information e.g.
>>>>> + *     to print it back in case of an issue.
>>>>> + *
>>>>>     */
>>>>>    struct opt_params {
>>>>>        const char    name;
>>>>> @@ -122,6 +127,7 @@ struct opt_params {
>>>>>            long long    minval;
>>>>>            long long    maxval;
>>>>>            long long    defaultval;
>>>>> +        const char    *raw_input;
>>>>>        }        subopt_params[MAX_SUBOPTS];
>>>>>    };
>>>>> @@ -729,6 +735,18 @@ struct opt_params mopts = {
>>>>>     */
>>>>>    #define WHACK_SIZE (128 * 1024)
>>>>> +static inline void
>>>>> +set_conf_raw(struct opt_params *opt, int subopt, const char *value)
>>>>> +{
>>>>> +    opt->subopt_params[subopt].raw_input = value;
>>>>> +}
>>>> There are no bounds check on the array here, I think set_conf_raw()
>>>> should return int and we would check the return value. It could
>>>> return -EINVAL if the subopt is invalid for instance.
>>> Good idea. The only issue is with the return code, that causes some 
>>> issues
>>> when we are also returning values - I wanted the values to be turned 
>>> into
>>> uint64. But do we need to return an error? I don't see what usecase 
>>> there
>>> would be for it, other than detecting a bug. So an assert might be a 
>>> better
>>> solution - then it can't happen that a wrong index is used and 
>>> result not
>>> tested.
>> The setting of the value can be done by using an extra argument 
>> pointer. Then
>> if its set it be assigned. Otherwise it would be left alone. The 
>> return value
>> would return 0 on success, otherwise a standard return value 
>> indicating the
>> cause of the error.
> I strongly prefer to return the value, not an error code. We can do 
> the other way around, put the error code into an argument to get 
> roughly the same result, while constructions like set_conf_raw(FOO, 
> BAR, baz * get_conf_raw(FOO, BAR)) will continue to work without the 
> need for intermediate variables.
>
> The *_raw functions are used on few places only, so it would be only a 
> small issue there, but for consistency, (get|set)_conf_val should have 
> the same behavior and an intermediate variable for every use of those 
> would be really annoying. So, how about this?
>
> static inline void
> set_conf_raw(struct opt_params *opt, int subopt, const char *value, 
> int *err)
> {
>     if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>         if (err != NULL) *err = EINVAL;
>         return;
>     }
>     opt->subopt_params[subopt].raw_input = value;
> }
>
I just realized that there is probably no reason for set_conf_raw to 
expect invalid subopt - that's clearly a bug and we should just print a 
message and die, because who knows what happened... But for errors that 
can arose from user input, the style presented above is still valid.

Jan
>> I don't think we need the too small or too big, a simple range issue 
>> should
>> suffice and we have -ERANGE.
>>
> At this moment, we are telling if it is too small or too big, but when 
> there is no standard error code for that, ERANGE has to suffice.
>
> Cheers,
> Jan

