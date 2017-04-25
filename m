Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33233 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1171284AbdDYMHY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2017 08:07:24 -0400
Received: by mail-vk0-f51.google.com with SMTP id j127so53413364vkh.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 Apr 2017 05:07:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170425013721.GE28800@wotan.suse.de>
References: <20170419153025.10368-1-jtulak@redhat.com> <20170420135839.22102-1-jtulak@redhat.com>
 <20170425013721.GE28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 25 Apr 2017 14:07:02 +0200
Message-ID: <CACj3i70Niht-0FJSyVp2iOpKssTnz=LmryJMLQKiX=hHm6d+-A@mail.gmail.com>
Subject: Re: [PATCH 1/2 v3] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 3:37 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Thu, Apr 20, 2017 at 03:58:39PM +0200, Jan Tulak wrote:
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 7a5c49f..40a32be 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -3431,17 +3431,17 @@ unknown(
>>       usage();
>>  }
>>
>> -long long
>> +uint64_t
>>  cvtnum(
>>       unsigned int    blksize,
>>       unsigned int    sectsize,
>>       const char      *s)
>>  {
>> -     long long       i;
>> +     uint64_t        i;
>>       char            *sp;
>>       int             c;
>>
>> -     i = strtoll(s, &sp, 0);
>> +     i = strtoull(s, &sp, 0);
>>       if (i == 0 && sp == s)
>>               return -1LL;
>>       if (*sp == '\0')
>
> I'm afraid this will not cut it, you see before we accepted negative values
> and used it as mechanism to catch errors, see the above return -1LL; with this
> change we'd only catch an error in parsing if the subopt's maxval happens to be
> smaller than -1LL which in turn will be returned as a positive value.
>
> Two more issues I spotted:
>
> a) the else condition on getnum() to use for when !sp->convert was left in your
> patch with strtoll() and I think you meant to convert that as well to
> strtoull()?
>
> b) I noted the existing cvtnum() code does not check for wrap arounds in its
> extra conversions.
>
> At first glance it may seem the best option is to modify the prototype of
> cvtnum() to return int to interpret errors, and have it set the uint64_t
> through a parameter pointer. The wrap around issue is orthogonal and would
> be an old issue, but such a change would help treat these as follows but
> as I will explain below this is perhaps not best for now.
>
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ef40c9a36e40..5995245e471d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1410,6 +1410,7 @@ getnum(
>  {
>         struct subopt_param     *sp = &opts->subopt_params[index];
>         uint64_t                c;
> +       int ret;
>
>         check_opt(opts, index, false);
>         set_conf_raw(opts->index, index, str);
> @@ -1434,13 +1435,16 @@ getnum(
>          * convert it ourselves to guarantee there is no trailing garbage in the
>          * number.
>          */
> -       if (sp->convert)
> -               c = cvtnum(get_conf_val(OPT_B, B_SIZE),
> -                          get_conf_val(OPT_D, D_SECTSIZE), str);
> -       else {
> +       if (sp->convert) {
> +               ret = cvtnum(get_conf_val(OPT_B, B_SIZE),
> +                            get_conf_val(OPT_D, D_SECTSIZE), str, &c);
> +               if (ret)
> +                       illegal_option(str, opts, index,
> +                                      _("Parse error, ret: %d", ret));

This printing won't work - we would have to use a sprintf, with all
the prealocation for the new string and so on. Or as I'm modifying it,
replace the if (ret) with a switch(ret) a print directly EINVAL/ERANGE
as part of the string.

> +       } else {
>                 char            *str_end;
>
> -               c = strtoll(str, &str_end, 0);
> +               c = strtoull(str, &str_end, 0);
>                 if (c == 0 && str_end == str)
>                         illegal_option(str, opts, index, NULL);
>                 if (*str_end != '\0')
> @@ -3814,24 +3818,25 @@ unknown(
>         usage();
>  }
>
> -uint64_t
> +int
>  cvtnum(
>         unsigned int    blksize,
>         unsigned int    sectsize,
> -       const char      *s)
> +       const char      *s,
> +       uint64_t *val)
>  {
>         uint64_t        i;
>         char            *sp;
>         int             c;
> +       uint64_t        orig_val;
>
>         i = strtoull(s, &sp, 0);
>         if (i == 0 && sp == s)
> -               return -1LL;
> +               return -EINVAL;
>         if (*sp == '\0')
> -               return i;
> -
> +               return -EINVAL;
This has to be *val = i; return 0;
Otherwise, we would report numbers without any suffix as an error. ;-)

>         if (sp[1] != '\0')
> -               return -1LL;
> +               return -EINVAL;
>
>         if (*sp == 'b') {
>                 if (!blksize) {
> @@ -3839,7 +3844,10 @@ cvtnum(
>  _("Blocksize must be provided prior to using 'b' suffix.\n"));
>                         usage();
>                 } else {
> -                       return i * blksize;
> +                       *val = i * blksize;
> +                       if (*val < i || *val < blksize)
> +                               return -ERANGE;
> +                       return 0;
>                 }
>         }
>         if (*sp == 's') {
> @@ -3848,11 +3856,15 @@ _("Blocksize must be provided prior to using 'b' suffix.\n"));
>  _("Sectorsize must be specified prior to using 's' suffix.\n"));
>                         usage();
>                 } else {
> -                       return i * sectsize;
> +                       *val = i * sectsize;
> +                       if (*val < i || *val < sectsize)
> +                               return -ERANGE;
> +                       return 0;
>                 }
>         }
>
>         c = tolower(*sp);
> +       orig_val = i;
>         switch (c) {
>         case 'e':
>                 i *= 1024LL;
> @@ -3870,11 +3882,14 @@ _("Sectorsize must be specified prior to using 's' suffix.\n"));
>                 i *= 1024LL;
>                 /* fall through */
>         case 'k':
> -               return i * 1024LL;
> +               *val = i * 1024LL;
> +               if (*val < orig_val)
> +                       return -ERANGE;
> +               return 0;
>         default:
>                 break;
>         }
> -       return -1LL;
> +       return -EINVAL;
>  }
>
>  static void __attribute__((noreturn))
>
> The issue with this of course is everyone and their mom calls cvtnum() and the
> amount of collateral for such type of change is significant for your patch series.
> One option may just be to bail on error within cvtnum() with a usage() call on
> error, as a temporary compromise, this way we only chug on *iff* the value was
> accepted and proper, and non-wrap-around, up to you.
>
>   Luis

Ehh, it is not really an issue.. cvtnum is called only on two places
in the whole xfsprogs. Changing mkfs/proto.c is just few lines added
to this patch and the changes in xfs_mkfs.c do cause few conflicts,
but it is nothing terrific, I rebased all my further changes in about
three minutes. I pushed it into the git tree, check it now...

And thanks for this patch for the patch. :-)

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
