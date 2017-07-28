Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:37902 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752070AbdG1Oox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jul 2017 10:44:53 -0400
Received: by mail-wr0-f179.google.com with SMTP id f21so99577134wrf.5
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jul 2017 07:44:52 -0700 (PDT)
Subject: Re: [PATCH 6/7] mkfs: extend opt_params with a value field
References: <20170720092932.32580-1-jtulak@redhat.com>
 <20170720092932.32580-7-jtulak@redhat.com>
 <20170727161806.GJ18884@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <30eae9db-14fd-b245-3aab-5c1670894b44@redhat.com>
Date: Fri, 28 Jul 2017 16:44:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170727161806.GJ18884@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On 27/07/2017 18:18, Luis R. Rodriguez wrote:
> On Thu, Jul 20, 2017 at 11:29:31AM +0200, Jan Tulak wrote:
>> +/*
>> + * Get and set values to the opts table.
>> + */
>> +static inline uint64_t
>> +get_conf_val(int opt, int subopt)
>> +{
>> +	return opts[opt].subopt_params[subopt].value;
>> +}
>> +
>> +static void
>> +set_conf_val(int opt, int subopt, uint64_t val)
>> +{
>> +	struct subopt_param *sp = &opts[opt].subopt_params[subopt];
> These are pass by value so its fine to do it this way.
>
>> +
>> +	sp->value = val;
>> +}
>> +
>>   static inline void
>>   set_conf_raw(int opt, int subopt, const char *value)
>>   {
>> @@ -880,6 +905,18 @@ getnum(
>>   }
>>   
>>   /*
>> + * A wrapper for getnum and set_conf_val.
>> + */
>> +static inline uint64_t
>> +parse_conf_val(int opt, int subopt, char *value)
>> +{
>> +	uint64_t num = getnum(value, &opts[opt], subopt);
>> +
>> +	set_conf_val(opt, subopt, num);
>> +	return num;
>> +}
> A good comment explaining getnum() will abort if parsing for some reasons fails
> is worth it given the way you use parse_conf_val() is rather inconsistent -- in
> some places you use the return value, in some other you do not, and someone
> reading the code should hopefully get a sense of a relief that error checking
> is *not* required given it is already built-in to the helpers used by
> parse_conf_val().
Good idea.
>
> This also limits the use of parse_conf_val() in that we won't be able to
> customize error messages with better context, so its a good time to evaluate
> if we want to continue with that tradition or let parse_conf_val() return
> int and if it returns 0 it was successful, otherwise an error value.
Quoting also the other email (Re: [PATCH 1/5 v2] mkfs: replace variables 
with opts table: -b,d,s options):
> Here parse_conf_val() is used only to update D_AGCOUNT based on the parsed
> value. But note that the return value is ignored. In some other places the
> return value is used. This is inconsistent, and I realize that the reason
> we ignore errors is that getnum() is used, however now is a good time to
> consider if we should just allow the caller to check the error value and
> return a proper error message and bail on their own. This would allow for
> better contextual error messages as the code grows. We can discuss this in
> the patch that adds parse_conf_val().

And do we need better messages? If some value is out of range, or it is 
a conflict, there is not much context needed, and better to not have to 
care about these errors... Do you have an example when it would be 
helpful? If it just spits out a return code, you have to add a check to 
every use and you will have many times the same code like what is in 
getnum() at this moment:


     /* Validity check the result. */
     if (c == E_SMALL)
         illegal_option(str, opts, index, _("value is too small"));
     else if (c == E_BIG)
         illegal_option(str, opts, index, _("value is too large"));
     else if (c == E_PO2)
         illegal_option(str, opts, index, _("value must be a power of 2"));
     ... and other checks for conflicts, etc...

I think this goes exactly against what I'm trying to do...

Jan
>
> Making this return an int and have the return value checked makes this code
> IMHO cleaner and subject to growth. Right now this sort of hack IMHO limits
> the code to growth, despite the fact that I know this would create more work
> at the moment.
>

