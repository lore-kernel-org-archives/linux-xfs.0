Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:36934 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdCQMGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 08:06:46 -0400
Received: by mail-it0-f47.google.com with SMTP id g138so22757266itb.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2017 05:06:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170316232000.GW28800@wotan.suse.de>
References: <20170315160017.27805-1-jtulak@redhat.com> <20170315160017.27805-15-jtulak@redhat.com>
 <20170316232000.GW28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 17 Mar 2017 13:06:24 +0100
Message-ID: <CACj3i727bsYTcUYtEw1DJnNJCZURxuArACc1wNZUFOC=1UOKSw@mail.gmail.com>
Subject: Re: [PATCH 14/22] mkfs: rename defaultval to flagval in opts
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 17, 2017 at 12:20 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Wed, Mar 15, 2017 at 05:00:09PM +0100, Jan Tulak wrote:
>> The old name 'defaultval' was misleading - it is not the default value,
>> but the value the option has when used as a flag by an user.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -189,7 +189,7 @@ unsigned int              sectorsize;
>> @@ -223,7 +223,7 @@ struct opt_params {
>>               }               conflicts [MAX_CONFLICTS];
>>               long long       minval;
>>               long long       maxval;
>> -             long long       defaultval;
>> +             long long       flagval;
>
> David suggested that in the future the config value(mkfs.xfs.conf) will override
> the defaultval, in this case since you are renaming this, just want to be sure
> the new name we choose can fit its later use also with the config. Perhaps
> userval ?
>
>   Luis

Your question is exactly why I'm renaming it. :-) This is not the
value that is used when no option is passed, but when an option
doesn't have an argument. So we don't require "-m crc=0|1", but "-m
crc" is enough.

Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
