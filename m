Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:35769 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752364AbdKWGqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 01:46:21 -0500
Received: by mail-ua0-f177.google.com with SMTP id 108so12175692uaf.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 22:46:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201711221837.25630.arekm@maven.pl>
References: <CAL4D3QFpES1U1pCQ3md2Jiiqm0E5L5KhG4T77gnyEiom-EZBgw@mail.gmail.com>
 <201711221837.25630.arekm@maven.pl>
From: Romeo Theriault <romeotheriault@gmail.com>
Date: Wed, 22 Nov 2017 20:46:20 -1000
Message-ID: <CAL4D3QFam3XSw2JkPDppt3WezH1+uwQAeBmKQu9WeCF7qfqfDg@mail.gmail.com>
Subject: Re: Display project quotas without
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-xfs@vger.kernel.org

Thanks. That works!

On Wed, Nov 22, 2017 at 7:37 AM, Arkadiusz Miskiewicz <arekm@maven.pl> wrot=
e:
> On Wednesday 22 of November 2017, Romeo Theriault wrote:
>> Hello, Is it possible to display project quotas without the
>> /etc/projid file? I have a need to display the quotas without this (or
>> the /etc/project file) and just display the quotas with the id's.
>>
>> For example,
>>
>> xfs_quota -x -c 'report -p'
>>
>> displays nothing until I add a /etc/projid file.
>
> Try -L low_id -U high_id as described in man page.
>
>>
>> Anyway around this? Using xfs_db or xfs_io somehow?
>>
>> Thanks,
>
>
> --
> Arkadiusz Mi=C5=9Bkiewicz, arekm / ( maven.pl | pld-linux.org )



--=20
Romeo Theriault
