Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35374 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176465AbdDYIL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Apr 2017 04:11:28 -0400
Received: by mail-vk0-f44.google.com with SMTP id 198so29752218vkk.2
        for <linux-xfs@vger.kernel.org>; Tue, 25 Apr 2017 01:11:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170425034055.GJ28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-7-jtulak@redhat.com>
 <20170425034055.GJ28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 25 Apr 2017 10:11:06 +0200
Message-ID: <CACj3i71hapihKEMet5Z_wxqEA-OLh064g0wncaet8=XrwADUTw@mail.gmail.com>
Subject: Re: [PATCH 06/12] mkfs: create get/set functions for opts table
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 5:40 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Sun, Apr 23, 2017 at 08:54:57PM +0200, Jan Tulak wrote:
>> Add functions that can be used to get/set values to opts table.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>>
>> ---
>>  mkfs/xfs_mkfs.c | 32 ++++++++++++++++++++++++++++++++
>>  1 file changed, 32 insertions(+)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index c2ffd91..4caf93c 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -786,6 +786,38 @@ get_conf_raw(int opt, int subopt)
>>       return opts[opt].subopt_params[subopt].raw_input;
>>  }
>>
>> +static uint64_t getnum(const char *str, struct opt_params *opts, int index);
>
> Why not just move getnum() above here. Forward declarations IMHO should not be
> needed unless we have odd inclusion issues and I don't think that's the case
> here ?

Getnum requires set_conf_raw and illegal_option, but it seems that
they could be moved too. I think there is no circle dependency, I just
didn't want to move so many lines when I can do one declaration. But
if the declaration is an issue, I can shuffle the ~80 lines the three
functions takes.

Jan

>
>> +
>> +/*
>> + * Get and set values to the opts table.
>> + */
>> +static inline uint64_t
>> +get_conf_val(int opt, int subopt)
>> +{
>> +     return opts[opt].subopt_params[subopt].value;
>> +}
>> +
>> +static void
>> +set_conf_val(int opt, int subopt, uint64_t val)
>> +{
>> +     struct subopt_param *sp = &opts[opt].subopt_params[subopt];
>> +
>> +     sp->value = val;
>> +}
>> +
>> +/*
>> + * A wrapper for getnum and set_conf_val.
>> + */
>> +static inline uint64_t
>> +parse_conf_val(int opt, int subopt, char *value)
>> +{
>> +     uint64_t num = getnum(value, &opts[opt], subopt);
>> +
>> +     set_conf_val(opt, subopt, num);
>> +     return num;
>> +}
>
> Very nice thanks!
>
>   Luis



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
