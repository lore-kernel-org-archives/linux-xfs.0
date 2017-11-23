Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:45015 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdKWKo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 05:44:59 -0500
Received: by mail-yb0-f182.google.com with SMTP id x72so7026447ybg.11
        for <linux-xfs@vger.kernel.org>; Thu, 23 Nov 2017 02:44:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171122210023.GJ2135@magnolia>
References: <20170830145400.3681-1-hch@lst.de> <20171115011022.GC5119@magnolia>
 <CAOQ4uxg2iF5ucZTeN6orJVA2VYFnHAkvyb1-FS0BEZ=rGN+-Lw@mail.gmail.com>
 <20171122183119.GI2135@magnolia> <CAOQ4uxjzpBrzMnt-OFP4P_6DB5onw9U+BM+4Dd_BpaeaPQ86iQ@mail.gmail.com>
 <20171122210023.GJ2135@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Nov 2017 12:44:58 +0200
Message-ID: <CAOQ4uxhqf9mNcDdmMenzLNEXGSksuOZ5s_gGoQB5WJ9cbUEgbw@mail.gmail.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 22, 2017 at 11:00 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Wed, Nov 22, 2017 at 10:40:07PM +0200, Amir Goldstein wrote:
>> On Wed, Nov 22, 2017 at 8:31 PM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>> > On Wed, Nov 15, 2017 at 08:14:33AM +0200, Amir Goldstein wrote:
>> [...]
>> >>
>> >> Last time you wrote about this bug you had a "hard question" about transaction
>> >> reservation for the solution and said your're going to go have a think about it:
>> >> https://marc.info/?l=linux-xfs&m=150766311924170&w=2
>> >> Did you come to any conclusions?
>> >> That sounds like one of those nasty CoW corner cases, so I'd be happy to know
>> >> there is at least a well thought design for a solution - if not a fix.
>> >
>> > Sorry I let myself get distracted/stressed with the merge window;
>> > hopefully the patch I sent out will address that problem?
>> >
>>
>> Problem reproduces better on a spinning rust I have at the office, so will
>> give it a spin tomorrow.
>

So far all good.
Spinning rust never survived 10 rounds of generic/457
and it is past the 100's round with your patch already.
Will keep it spinning for the weekend.

Thanks,
Amir.
