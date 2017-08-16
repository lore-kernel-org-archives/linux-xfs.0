Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:37771 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbdHPJMQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 05:12:16 -0400
Received: by mail-wr0-f169.google.com with SMTP id z91so983308wrc.4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 02:12:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <806d4e0b-587c-4c12-db45-3942b4ab0753@sandeen.net>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170815150812.32237-1-jtulak@redhat.com>
 <806d4e0b-587c-4c12-db45-3942b4ab0753@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 16 Aug 2017 11:11:54 +0200
Message-ID: <CACj3i72UC1vc9LD_JymfovkgnUkEdDt98=S5u9JSPUS=goiO=w@mail.gmail.com>
Subject: Re: [PATCH 1/6 v2] mkfs: Save raw user input field to the opts struct
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 16, 2017 at 1:07 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 8/15/17 10:08 AM, Jan Tulak wrote:
>> Save exactly what the user gave us for every option.  This way, we will
>> never lose the information if we need it to print back an issue.
>> (Just add the infrastructure now, used in the next patches.)
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>
> Sorry for not getting to the V1 review, catching up from a week off.

I hope you enjoyed your holiday. :-)

>
>> ---
>> CHANGE:
>> * test for NULL before strdup in get_conf_raw
>> * Translation and indentation for fprints
>> * add set_conf_raw_safe
>> ---
>>  mkfs/xfs_mkfs.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 88 insertions(+)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 7bb6408f..adfbd376 100644
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
>> @@ -730,6 +736,88 @@ struct opt_params mopts = {
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
>> +                     _("This is a bug: set_conf_raw called with invalid "
>> +                       "opt/subopt: %c/%d\n"),
>
> Usually best to just out-dent these long strings to column zero:
>
> _("This is a bug: set_conf_raw called with invalid opt/subopt: %c/%d\n"),
>
> and that makes them super grep-able.  Other places in xfsprogs do that.

True, I will change it.

>
>> +                     opt->name, subopt);
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
>> + * Same as set_conf_raw(), except if any error occurs, return NULL.
>> + */
>
> Hm, that's not what this void function does.

copypasta of comment :(

>
>> +static void
>> +set_conf_raw_safe(struct opt_params *opt, const int subopt, const char *value)
>> +{
>> +     if (set_conf_raw(opt, subopt, value) != 0) {
>> +             exit(1);
>> +     }
>
> So on -ENOMEM error, we get a silent exit()?
>
> Also, not sure about the point of the wrapper.  Nothing in this series
> calls set_conf_raw() directly - do later patches use it?  If not,
> just lose the wrapper, I'd say, and roll up the behavior in set_conf_raw.
>
>> +}
>> +
>> +/*
>> + * Return 0 on success, -ENOMEM if it could not allocate enough memory for
>> + * the string to be saved into the out pointer.
>
> ..., or -EINVAL if ___?  I guess this is the downside of excessive commenting ;)
>
>> + */
>> +static int
>> +get_conf_raw(const struct opt_params *opt, const int subopt, char **out)
>> +{
>> +     if (subopt < 0 || subopt >= MAX_SUBOPTS) {
>> +             fprintf(stderr,
>> +                     _("This is a bug: get_conf_raw called with invalid "
>> +                       "opt/subopt: %c/%d\n"),
>
> Again I'd outdent this error string.
>
>> +                     opt->name, subopt);
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (opt->subopt_params[subopt].raw_input == NULL) {
>> +             *out = NULL;
>> +             return 0;
>> +     }
>> +
>> +     *out = strdup(opt->subopt_params[subopt].raw_input);
>> +     if (*out == NULL)
>> +             return -ENOMEM;
>> +     return 0;
>> +
>> +}
>> +
>> +/*
>> + * Same as get_conf_raw(), except it returns the string through return.
>> + * If any error occurs, return NULL.
>> + */
>> +static char *
>> +get_conf_raw_safe(const struct opt_params *opt, const int subopt)
>> +{
>> +     char *str;
>> +
>> +     str = NULL;
>> +
>> +     if (get_conf_raw(opt, subopt, &str) == -ENOMEM) {
>> +             fprintf(stderr, "Out of memory!");
>
> Seems like using strerror() would be better than a hand-rolled, un-
> translatable string?

Every day there is something new. :-)

>
>> +             return NULL;
>> +     }
>
> Again, I don't see that any subsequent patches ever call get_conf_raw();
> is there any reason to even have this wrapper now?

Luis had a pretty strong opinion about having them there when he will
need them in his own patches later on and I saw no reason why not to
add them right now when the functions are created. After all, they
will be useful later on also for me, when I want to limit the amount
of asserts and be more return-oriented. It's just not in this
patchset.

Jan
