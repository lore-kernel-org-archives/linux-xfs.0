Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34542 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1431246AbdDZIYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 04:24:46 -0400
Received: by mail-vk0-f43.google.com with SMTP id k4so65258740vki.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Apr 2017 01:24:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170426080142.GY28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com> <20170423185503.31415-5-jtulak@redhat.com>
 <20170425030421.GH28800@wotan.suse.de> <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
 <175c1e19-12df-2993-811d-b5de631ac00f@sandeen.net> <20170426013815.GS28800@wotan.suse.de>
 <ef444d22-6251-c611-9c1e-106f7bbe4e0f@sandeen.net> <20170426080142.GY28800@wotan.suse.de>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 26 Apr 2017 10:24:24 +0200
Message-ID: <CACj3i70PdN2Xdmg1QtQv4KVVOqsrAe30Rkc=yuRiVAgCXbvWpA@mail.gmail.com>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 10:01 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, Apr 25, 2017 at 09:00:40PM -0500, Eric Sandeen wrote:
>> On 4/25/17 8:38 PM, Luis R. Rodriguez wrote:
>> If you're not a fan of #defines to size global arrays that's ok, but
>> let's be consistent and change them all at once, and not change one
>> of the 3 as a side-effect of collapsing the separate opts structures
>> into one.
>
> Hm, changing all 3 of these of these: opts, suboopts, conflicts to flexible
> array may be possible without making the patch impossible to review, but its not
> clear to me, I'd be surprised though.
>
> Anyway in case its useful to Jan or others here's an example of what it using
> flexible arrays could look like for an opt/subopt framework:
>
> http://drvbp1.linux-foundation.org/~mcgrof/demos/demo-flexible-array-subopts.c

Thanks.

>
>> For now, let's follow the pattern of the existing code, and submit a
>> comprehensive functional patch to address this separate change.
>>
>> Small, reviewable, distinct, functional changes.
>
> This patch moves the opts to the 'old' way of doing things with no good reason
> other than its the old style. I find more reasons to move away from it, to enable
> later making subopts and conflicts also use flexible array (if this is agreed
> suitable).

Changing it this later (and all the other size definitions too) sounds
like a better idea to me: this static initialization doesn't add any
work that would be useless after it is turned to flexible, so it is
only about "make it flexible now, or later?" And given the number of
changes I have now, I'm up for making this change later on.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
