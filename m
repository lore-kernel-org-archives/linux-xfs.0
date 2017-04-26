Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36181 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037063AbdDZIvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 04:51:25 -0400
Received: by mail-oi0-f51.google.com with SMTP id w12so89039507oiw.3
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 01:51:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170426010457.GQ28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-6-jtulak@redhat.com>
 <20170425031326.GI28800@wotan.suse.de> <CACj3i70LFrv9HbMRYg7M8qutCfmhFHC8oCUtrkf3vP8kvKUw4Q@mail.gmail.com>
 <CACj3i71JaxqjZ_qUvZSOu6gTeZhjm86VfA2asNZNppV2t6_wDA@mail.gmail.com> <20170426010457.GQ28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 10:51:04 +0200
Message-ID: <CACj3i71SFU8VrUyrWwrYPCNB2pwH=D8_55D5g-v9JhdDtgE_PA@mail.gmail.com>
Subject: Re: [PATCH 05/12] mkfs: extend opt_params with a value field
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 3:04 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, Apr 25, 2017 at 11:39:00AM +0200, Jan Tulak wrote:
> Hm, how about:
>
> The actual value used in computations for creating the filesystem.
> This is initialized with sensible default values, if initialized to 0
> the value is considered disabled. User input can optionally override
> default values. If the field is a string and not a number, the value
> is set to a positive non-zero number when user input has been supplied.
>
>>  *     (If the field is a string and not a number, this value is set to
>>  *     a positive non-zero number on an user input.)
>>
>> And for the commit message, a bit shortened version:
>>
>> Add a new field int opt_params - value - which is the actual value
>> used in computations and for creating the filesystem. It is filled
>> with user input if the user specifies the subopt. But he does not,
>> then whatever you put there is used as the default.
>
> Modulo "But he does not"/ "but if no user input is not passed then
> the originally set defaults will be used"
>
>   Luis

Sounds good. I will use your version.

Thanks,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
