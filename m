Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:33298 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdDFUAJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 16:00:09 -0400
Received: by mail-vk0-f43.google.com with SMTP id d188so52854426vka.0
        for <linux-xfs@vger.kernel.org>; Thu, 06 Apr 2017 13:00:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6c83318d-ef75-4dc2-e366-d50d74fb71e6@sandeen.net>
References: <20170406143426.19727-1-jtulak@redhat.com> <6c83318d-ef75-4dc2-e366-d50d74fb71e6@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 6 Apr 2017 21:59:47 +0200
Message-ID: <CACj3i73Mh1eW=M2xk0AKS12GCHcJkK6hRdMg_f2BLKMpWSryfA@mail.gmail.com>
Subject: Re: [PATCH] mkfs: rtinherit minval should be 0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 6, 2017 at 6:58 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 4/6/17 9:34 AM, Jan Tulak wrote:
>> As with any other option, rtinherit=[0|1], but minval was incorrectly
>> set to 1, so it was not possible to disable this option.
>
> Long ago, when this option was added, it was simply a flag with
> no option parsing, i.e. "-d rtinherit"
>
> so I just want to double check ...
>
> 1) was it intentional that this turned into a "=0/=1" type option,
>    i.e. an option which can be specified as disabled, essentially restating
>    the default?  Is it the intent that every flag option must now take a
>    value, and that it must take both "off" and "on" values?  Just checking
>    that I haven't lost the thread, here.
>
> IOWS: we used to have only "-d rtinherit"  But I think now we accept
> -d rtinherit, -d rtinherit=0, and -d rtinherit=1.  Maybe it's water
> under the bridge, I don't see the use in adding value parsing to
> something that was just a simple flag before.  Can you enlighten
> me?
>

(Sending again, mailing list refuses emails with html part outright
and it looks like gmail for ios can't sent plaintext only. Sorry if
you got this twice, Eric.)

It is using the same framework as all other options, so it got the 0/1
for free by simply being in the opts table (assuming the min/max
values are set to 0/1 respectively). We need this behaviour for
options like crc anyway, so why not standardize it, if all it costs
you is to set minval to 0?

This behaviour was added in the previous part of my/Dave's cleaning work.

Jan

> 2) really, this and projinherit and, um, extszinherit should
>    probably all go away.  They were written for testing, nothing
>    tests them, and they aren't documented.  Any volunteers for
>    that?  It actually finds its way outside of pure mkfs code,
>    so it's a little tricky to completely eradicate it, but it
>    could be done in 2 steps I think.
>
> thanks,
> -Eric
>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> ---
>>  mkfs/xfs_mkfs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 6fedc05c..5aac4d1b 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -290,7 +290,7 @@ struct opt_params dopts = {
>>               },
>>               { .index = D_RTINHERIT,
>>                 .conflicts = { LAST_CONFLICT },
>> -               .minval = 1,
>> +               .minval = 0,
>>                 .maxval = 1,
>>                 .defaultval = 1,
>>               },
>>



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
