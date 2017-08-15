Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36998 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753860AbdHOKmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 06:42:53 -0400
Received: by mail-wm0-f48.google.com with SMTP id i66so6893277wmg.0
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2017 03:42:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170814231553.GJ4796@magnolia>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170811123037.15962-7-jtulak@redhat.com>
 <20170814231553.GJ4796@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 15 Aug 2017 12:42:31 +0200
Message-ID: <CACj3i71yx1tfDjf__=m=tzLPC77NdbC-vKZ8yr3YUCThcwQuTw@mail.gmail.com>
Subject: Re: [PATCH 6/6] mkfs: extend opt_params with a value field
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 15, 2017 at 1:15 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Aug 11, 2017 at 02:30:37PM +0200, Jan Tulak wrote:
>> This patch adds infrastructure that will be used in subsequent patches.
>>
>> The Value field is the actual value used in computations for creating
>> the filesystem.  This is initialized with sensible default values. If
>> initialized to 0, the value is considered disabled. User input will
>> override default values.  If the field is a string and not a number, the
>> value is set to a positive non-zero number when user input has been
>> supplied.
>>
>> Add functions that can be used to get/set values to opts table.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>
>> ---
>> Change:
>> * make the value type to be long long instead of uint64 for now
>> * add collateral updates
>> * add bounds to get/set functions
>> * update the description of commit/in code
>> * merge with another patch, which adds the get/set functions.
>> ---
>>  mkfs/xfs_mkfs.c | 194 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 194 insertions(+)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 3e7ba5f0..61ef09e8 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -117,6 +117,13 @@ unsigned int             sectorsize;
>>   *     Filled raw string from the user, so we never lose that information e.g.
>>   *     to print it back in case of an issue.
>>   *
>> + *   value OPTIONAL
>> + *     The actual value used in computations for creating the filesystem.
>> + *     This is initialized with sensible default values. If initialized to 0,
>> + *     the value is considered disabled. User input will override default
>> + *     values. If the field is a string and not a number, the value is set to
>> + *     a positive non-zero number when user input has been supplied.
>> + *
>>   */
>>  struct opt_params {
>>       int             index;
>> @@ -134,6 +141,7 @@ struct opt_params {
>>               long long       maxval;
>>               long long       flagval;
>>               char            *raw_input;
>> +             long long       value;
>
> I think this is less sensitive for mkfs options, but for structures
> please keep variables of the same type together to reduce memory usage.
> That (char *) between the (long long) creates a 4-byte padding hole on
> 32-bit machines.  I recommend pahole for things like this.

Fixing.. I'm theoretically aware of this issue, but I don't have it
under my skin yet. And thanks for the tool, I didn't knew about it.

>
>>       }               subopt_params[MAX_SUBOPTS];
>>  } opts[MAX_OPTS] = {
>>  #define OPT_B        0
>> @@ -750,6 +758,180 @@ struct opt_params {
>>  #define WHACK_SIZE (128 * 1024)
>>
>>  /*
>> + * Get and set values to the opts table.
>> + */
>> +static int
>> +get_conf_val_unsafe(int opt, int subopt, uint64_t *output)
>> +{
>> +     if (subopt < 0 || subopt >= MAX_SUBOPTS ||
>> +         opt < 0 || opt >= MAX_OPTS) {
>> +             fprintf(stderr,
>> +             "This is a bug: get_conf_val called with invalid opt/subopt: %d/%d\n",
>
> Oh yeah, I forgot to mention this a few patches back -- if these remain
> fprintfs, then shouldn't the string be enclosed in _() so that strings
> can be localized?

Sure, I realised that as well when fixing the indentation in the first patch.

>
>> +             opt, subopt);
>> +             return -EINVAL;
>> +     }
>> +     *output = opts[opt].subopt_params[subopt].value;
>> +     return 0;
>> +}
>> +
>> +static long long
>> +get_conf_val(int opt, int subopt)
>> +{
>> +     uint64_t res;
>> +     if (get_conf_val_unsafe(opt, subopt, &res) != 0)
>> +         exit(1);
>
> Tab then space indentation problem here.
>
>> +     return res;
>> +}
>> +
>> +static int
>> +set_conf_val_unsafe(int opt, int subopt, uint64_t val)
>> +{
>> +     if (subopt < 0 || subopt >= MAX_SUBOPTS ||
>> +         opt < 0 || opt >= MAX_OPTS) {
>> +             fprintf(stderr,
>> +             "This is a bug: set_conf_val called with invalid opt/subopt: %d/%d\n",
>> +             opt, subopt);
>> +             return -EINVAL;
>> +     }
>> +     struct subopt_param *sp = &opts[opt].subopt_params[subopt];
>> +     sp->value = val;
>> +
>> +     return 0;
>> +}
>> +
>> +static void
>> +set_conf_val(int opt, int subopt, uint64_t val)
>> +{
>> +     if (set_conf_val_unsafe(opt, subopt, val) != 0)
>> +             exit(1);
>> +}
>> +
>> +/*
>> + * A wrapper around set_conf_val which updates also connected/collateral values.
>> + * E.g. when changing S_LOG, update S_SIZE too.
>> + */
>> +static void
>> +set_conf_val_collateral(int opt, int subopt, uint64_t val)
>
> "collateral"... I hope we're not trying to secure a loan here. :)
>
> I suggest using "connected" (or "correlated") here instead.

OK, thanks. :-)

>
>> +{
>> +     set_conf_val(opt, subopt, val);
>> +
>> +     switch (opt) {
>> +     case OPT_B:
>> +             switch (subopt) {
>> +             case B_LOG:
>> +                     set_conf_val(OPT_B, B_SIZE, 1 << val);
>> +                     break;
>> +             case B_SIZE:
>> +                     set_conf_val(OPT_B, B_LOG,
>> +                             libxfs_highbit32(val));
>> +                     break;
>> +             }
>> +             break;
>> +     case OPT_D:
>> +             switch (subopt) {
>> +             case D_SECTLOG:
>> +                     set_conf_val(OPT_S, S_LOG, val);
>> +                     set_conf_val(OPT_S, S_SECTLOG, val);
>> +                     set_conf_val(OPT_D, D_SECTSIZE,
>> +                                     1 << val);
>> +                     set_conf_val(OPT_S, S_SECTSIZE,
>> +                                     1 << val);
>> +                     set_conf_val(OPT_S, S_SIZE,
>> +                                     1 << val);
>> +                     break;
>> +             case D_SECTSIZE:
>> +                     set_conf_val(OPT_S, S_SIZE, val);
>> +                     set_conf_val(OPT_S, S_SECTSIZE, val);
>> +                     set_conf_val(OPT_D, D_SECTLOG,
>> +                             libxfs_highbit32(val));
>> +                     set_conf_val(OPT_S, S_LOG,
>> +                             libxfs_highbit32(val));
>> +                     set_conf_val(OPT_S, S_SECTLOG,
>> +                             libxfs_highbit32(val));
>> +                     break;
>> +             }
>> +             break;
>> +     case OPT_I:
>> +             switch (subopt) {
>> +             case I_LOG:
>> +                     set_conf_val(OPT_I, I_SIZE, 1 << val);
>> +                     break;
>> +             case I_SIZE:
>> +                     set_conf_val(OPT_I, I_LOG,
>> +                             libxfs_highbit32(val));
>> +                     break;
>> +             }
>> +             break;
>> +     case OPT_L:
>> +             switch (subopt) {
>> +             case L_SECTLOG:
>> +                     set_conf_val(OPT_L, L_SECTSIZE,
>> +                                     1 << val);
>> +                     break;
>> +             case L_SECTSIZE:
>> +                     set_conf_val(OPT_L, L_SECTLOG,
>> +                          libxfs_highbit32(val));
>
> Tab/space indentation problem here too.
>
> (Wondering if the calls here are short enough for a single line?)

Some of them yes, I will fix that.

Jan
