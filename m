Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:39708 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753797AbeFKFsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 01:48:22 -0400
Received: by mail-yw0-f195.google.com with SMTP id 81-v6so5945747ywb.6
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 22:48:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b1ffc34b-b76b-7f19-daa5-9ad5597a83b3@oracle.com>
References: <1528607439-11186-1-git-send-email-allison.henderson@oracle.com>
 <1528607439-11186-2-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhxj3hmQsvLtTNKW-e4qvozT8WGoj0Z8v=c=D57FtKOXA@mail.gmail.com>
 <CAOQ4uxgXa7wE42sWF8vTssgrHtq4MEqj-jxqJXtgNAZN4ha6VA@mail.gmail.com> <b1ffc34b-b76b-7f19-daa5-9ad5597a83b3@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 11 Jun 2018 08:48:21 +0300
Message-ID: <CAOQ4uxhGYe8PhgmM4oJaJdEdK=12yEgCU2DtbR+ac2c2GsVpkg@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] xfstests: Add parent pointer test
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

>>>> diff --git a/tests/xfs/group b/tests/xfs/group
>>>> index 2319f58..fb74e82 100644
>>>> --- a/tests/xfs/group
>>>> +++ b/tests/xfs/group
>>>> @@ -445,3 +445,4 @@
>>>>   445 auto quick filestreams
>>>>   446 auto quick
>>>>   447 auto mount
>>>> +448 auto
>>
>>
>> Isn't this test quick?
>>
>> Thanks,
>> Amir.
>
>
> It actually takes about a minute and a half for me, though I guess it would
> depend on how fast the host is.  Most of the time goes into the loop of 100:
> create a hard link, and then scan through all the entries to see if the new
> parent pointer is there.  This was mostly to make sure the attr tree was
> expanding correctly back when I was trying to get the transaction rolling
> straightened out.
>

That is still a bit surprising to me. I suspect the parent pointer parsing
code that invokes awk so many times may be the culprit. We soemtimes use
little C progs to assist in the test (see in src/) in cases where bash scripting
is insufficient or inefficient.

Perhaps if you use more bash array tricks instead of awk, parsing code
will be faster? assuming that parsing code is the slow down factor?

In any case, a "quick" test gets run more frequently by more people
so it would be a big benefit IMO if you are able to squeeze that test
runtime down to "quick".

Thanks,
Amir.
