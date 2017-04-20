Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35342 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939150AbdDTIG2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 04:06:28 -0400
Received: by mail-ua0-f174.google.com with SMTP id f10so41982741uaa.2
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2017 01:06:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170420000909.GI12369@dastard>
References: <20170419153025.10368-1-jtulak@redhat.com> <20170420000909.GI12369@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 20 Apr 2017 10:06:07 +0200
Message-ID: <CACj3i704EAv7OJTw_0apUofjLk_TwJ=r0HYaJj5nxotedRSZqA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mkfs: unify numeric types of main variables in main()
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2017 at 2:09 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Apr 19, 2017 at 05:30:24PM +0200, Jan Tulak wrote:
>> Followup of my "[xfsprogs] Do we need so many data types for user input?" email.
>> This version has bool for flags and uses PRIu64 for printing 64bit values.
>>
>> Other issues from RFC, that I didn't get a satisfactory feedback to:
>>  * __uint64_t is used because it is declared in xfsprogs, so unless there is a
>>    reason to not use it (e.g. the declared type is just for some special use,
>>    or is obsolete), I'm sticking to it.
>
> uint64_t is a standard C99 type. Please use it over an internal
> type that we plan to get rid of.  i.e.
>
> http://oss.sgi.com/archives/xfs/2016-01/msg00386.html
>
> These patches were never finalised/finished because of conflicts
> with all the COW work that was pending at the time. This type
> conversion still needs to be picked up and finished...
>

Thanks, Dave. I will turn it to the standard type.

Jan

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
