Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33492 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966974AbdDTWTC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 18:19:02 -0400
Received: by mail-io0-f175.google.com with SMTP id k87so89777739ioi.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2017 15:19:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170420220428.GG5205@birch.djwong.org>
References: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
 <2236FBA76BA1254E88B949DDB74E612B41C8D726@IRSMSX102.ger.corp.intel.com>
 <20170420172404.GE23371@birch.djwong.org> <20170420220428.GG5205@birch.djwong.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 20 Apr 2017 15:18:59 -0700
Message-ID: <CAGXu5jKDetasAbtQ0R_17NrTAGCqhftDOAryFCvBA87uHkfM6w@mail.gmail.com>
Subject: Re: [PATCH 0/5] fs, xfs refcount conversions
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>

On Thu, Apr 20, 2017 at 3:04 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Thu, Apr 20, 2017 at 10:24:04AM -0700, Darrick J. Wong wrote:
>> On Thu, Apr 20, 2017 at 08:11:41AM +0000, Reshetova, Elena wrote:
>> >
>> >
>> > > v3:
>> > >  * fixed header file inclusion
>> >
>> > I don't think I have heard anything back on this v3 patch set.
>> > Is there still smth here to fix or could you take the changes in?
>>
>> Generally I think it looks ok; it's running through shakedown testing as
>> we speak.
>
> Well, it survives the shakedown testing all right, but I can't shake the
> feeling that this is overkill.  The xfs_{ef,bu,cu,ru}i_log_item
> structures should only ever be referenced by the log itself and the
> log-update-done log item: the refcount should only ever go 2 -> 1 -> 0.
> We set the refcount to 2 and never increment it.

I haven't studied this code, but I think it'd likely be worth keeping
it just to catch any future bug that might appear. If it doesn't
create a problem, we should use refcount_t for anything that is being
used as a reference counter.

> Given that I've seen occasional refcounting problems with the log intent
> items, I think it would suffice to ASSERT in xfs_*i_release that the
> refcount isn't already zero.  Using ASSERT is particularly useful
> because ASSERT compiles out in release builds.

We _absolutely_ don't want to compile out these checks: the point is
to catch flaws that are discovered and could be exploited in the wild
before updates could be delivered to a system (if they ever are at
all).

> As for the xlog_ticket, we increment its refcount as part of duplicating
> a transaction as a part of committing one transaction (which decrements
> the xlog_ticket's refcount) and reusing the log reservation to create a
> new transaction.  In this case the refcounting already seems to have
> sufficient non-zero checks, and since only one thread can hold a
> transaction at any given time, I don't see how overflow protection helps
> here.
>
> In other words, I'm ok with better refcount checking but need convincing
> that we need to do more than what a simple ASSERT would provide.

If it doesn't get in your way, and it really is reference counting
(which it sounds like it is), we should be using refcount_t. The kinds
of bugs we've seen over the last decade continually prove that we'll
see refcount issues where we least expect it, and we need to catch
them.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
