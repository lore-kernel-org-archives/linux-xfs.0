Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33491 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752725AbdHOJsP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 05:48:15 -0400
Received: by mail-wr0-f181.google.com with SMTP id b65so1592234wrd.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 02:48:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170814225609.GE4796@magnolia>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170811123037.15962-2-jtulak@redhat.com>
 <20170814225609.GE4796@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 15 Aug 2017 11:47:53 +0200
Message-ID: <CACj3i73h67AxoZcDoCOHrFwAwmXjJTZ7getCC=BC9Xhb+g8m7g@mail.gmail.com>
Subject: Re: [PATCH 1/6] mkfs: Save raw user input field to the opts struct
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 15, 2017 at 12:56 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Aug 11, 2017 at 02:30:32PM +0200, Jan Tulak wrote:
>> Save exactly what the user gave us for every option.  This way, we will
>> never lose the information if we need it to print back an issue.
>> (Just add the infrastructure now, used in the next patches.)
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>
>> ---
>> CHANGE:
>> * added strdup
>> * added boundary checks to set/get functions
>> ---
>>  mkfs/xfs_mkfs.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 69 insertions(+)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 7bb6408f..fa0b475c 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -107,6 +107,11 @@ unsigned int             sectorsize;
>>   *     sets what is used with simple specifying the subopt (-d file).
>>   *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
>>   *     value in any case.
>> + *
>> + *   raw_input INTERNAL
>> + *     Filled raw string from the user, so we never lose that information e.g.
>> + *     to print it back in case of an issue.
>> + *
>>   */
>>  struct opt_params {
>>       const char      name;
>> @@ -122,6 +127,7 @@ struct opt_params {
>>               long long       minval;
>>               long long       maxval;
>>               long long       defaultval;
>> +             char            *raw_input;
>>       }               subopt_params[MAX_SUBOPTS];
>>  };
>>
>> @@ -730,6 +736,69 @@ struct opt_params mopts = {
>>  #define WHACK_SIZE (128 * 1024)
>>
>>  /*
>> + * Return 0 on success, -ENOMEM if it could not allocate enough memory for
>> + * the string to be saved.
>> + */
>> +static int
>> +set_conf_raw(struct opt_params *opt, const int subopt, const char *value)
>> +{
>> +     if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>> +             fprintf(stderr,
>> +             "This is a bug: set_conf_raw called with invalid opt/subopt: %c/%d\n",
>> +             opt->name, subopt);
>
> ASSERT?  Or, if I'm just foolishly restarting an old bikeshed and the
> fprintf/-EINVAL should stay, then the indentation of the arguments needs
> fixing.

It stays, so I'm fixing the indentation for the fprintf.

>
>> +             return -EINVAL;
>> +     }
>> +     if (value == NULL) {
>> +             if (opt->subopt_params[subopt].raw_input != NULL)
>> +                     free(opt->subopt_params[subopt].raw_input);
>> +             opt->subopt_params[subopt].raw_input = NULL;
>> +     } else {
>> +             opt->subopt_params[subopt].raw_input = strdup(value);
>> +             if (opt->subopt_params[subopt].raw_input == NULL)
>> +                     return -ENOMEM;
>> +     }
>> +     return 0;
>> +}
>> +
>> +/*
>> + * Return 0 on success, -ENOMEM if it could not allocate enough memory for
>> + * the string to be saved into the out pointer.
>> + */
>> +static int
>> +get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
>> +{
>> +     if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>> +             fprintf(stderr,
>> +             "This is a bug: get_conf_raw called with invalid opt/subopt: %c/%d\n",
>> +             opt->name, subopt);
>> +             return -EINVAL;
>
> (Same here)
>
>> +     }
>> +     *out = strdup(opt->subopt_params[subopt].raw_input);
>
> Given that raw_input can be set to NULL and strdup(NULL) segfaults on
> glibc 2.23, do we need a null check of raw_input here?  Is it the case
> that get_conf_raw is only called if we (somehow) know that there's a
> value to get later?

We need it here, when I added the check to set_conf_raw somehow didn't
realise that it could fail on the other side as well.

Thanks,
Jan
