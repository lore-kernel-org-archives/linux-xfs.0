Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33440 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbcLEPje (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 10:39:34 -0500
MIME-Version: 1.0
In-Reply-To: <00b2b645-3cd2-f3b2-b026-40dfc97f3f90@sandeen.net>
References: <1480943017-6175-1-git-send-email-amir73il@gmail.com>
 <9125bb5e-49f5-e40e-0181-fea7f80ae553@sandeen.net> <CAOQ4uxhw8Y_9NVwuAZ_xzvPYZ8k1CRonmQ=CAn=Y9j-_nkToMA@mail.gmail.com>
 <00b2b645-3cd2-f3b2-b026-40dfc97f3f90@sandeen.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 5 Dec 2016 17:39:17 +0200
Message-ID: <CAOQ4uxhmLe32AMkBmRJx37Pmg3oZMFLt_6Q0kTNYxix_qz7vZA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs_io: support -c "open foo" command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Dec 5, 2016 at 5:26 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 12/5/16 9:19 AM, Amir Goldstein wrote:
>> On Mon, Dec 5, 2016 at 4:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> On 12/5/16 7:03 AM, Amir Goldstein wrote:
>>>> There is an undocumented and possibly unused feature in xfs_io
>>>> where all commands are executed per file in the file args list.
>>>>
>>>> This feature creates ambiguity when trying to execute commands
>>>> such as "open" and "file" from command line and result in an
>>>> endless loop in the command loop code.
>>>
>>> I may well be dense, but it's not immediately obvious what the
>>> old and/or problematic behavior is.  Can you spell it out a bit
>>> more?  What is an example of this loop?
>>
>> $ touch foo
>> $ xfs_io -c "open foo" foo
>>
>> you will see the shit storm
>
> ;)  Ok thanks.  (would be nice to have that in the changelog)
>

Good point. I will add that.


>
> Given that neither the manpage nor the short help mention that more than
> one filename is accepted, should this even succeed at all?
>

Make sense to me to fail on multiple file args.
This is a behavior change that will not go silently
if anyone is actually using multiple file args.

If there are no objections, I will send out v4 patch.

The only documentation change I am going to make
is put the [file] arg in usage (and man page) inside optional brackets [].
I think the rest of the behavior is pretty much aligned with the existing
documentation.

Amir.
