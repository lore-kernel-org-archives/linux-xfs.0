Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:36722 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbdHQO4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 10:56:40 -0400
Received: by mail-wr0-f175.google.com with SMTP id f8so1402775wrf.3
        for <linux-xfs@vger.kernel.org>; Thu, 17 Aug 2017 07:56:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170817110324.GR21024@dastard>
References: <20170811123037.15962-1-jtulak@redhat.com> <20170815150812.32237-1-jtulak@redhat.com>
 <20170815150812.32237-5-jtulak@redhat.com> <4a7d1fe9-8094-78e8-aca9-f7f0156f0aa7@sandeen.net>
 <20170816213812.GC4796@magnolia> <CACj3i72+wAWL0ZVBmC8Kk4_B7=du_J_yoDsyeT=G359u-nv+hw@mail.gmail.com>
 <20170817110324.GR21024@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 17 Aug 2017 16:56:18 +0200
Message-ID: <CACj3i73CN_0YE8gEV6+qxq5hcGEu1aXiL8fCO=VLv7qvhqoNpg@mail.gmail.com>
Subject: Re: [PATCH 6/6 v2] mkfs: extend opt_params with a value field
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 17, 2017 at 1:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> Hi folks,
>
> I'm going to put my 2c worth in here in the form of a patch.  The
> tl;dr of it all is that I think we need to reset and reflect on what
> I was originally trying to acheive with the table based option
> parsing: factoring and simplifying mkfs into an easy to understand,
> maintainable code base....
>
> And, while I remember, there's a handful of input validation bugs I
> found in the code whiel I was doing this (like missing conflict
> checks).
>
> Anyway, have a look, based on the current for-next branch.
>
>> >> [1] # mkfs.xfs -dfile,name=fsfile,size=1g,sectsize=4k -lfile,name=logfile,size=512m,sectsize=512
>> >
>> > I see -d sectsize is in the --help screen but not the manpage.  Can we
>> > fix that?
>>
>> I made it, but Dave would rather see the -d sectsize option removed.
>> Which I'm not sure about...
>> See "[PATCH] xfsprogs: add sectsize/sectlog to the man page"
>
> Slash and burn - there is so much useless, redundant crap in the CLI
> we've been holding onto for 15 years that we should just get rid of
> it. That's what I was intending to do originally with this rework
> and I still see no reason why we should be keeping stuff that just
> causes user confusion and implemention complexity.

I went through it and I admit that his shot seems to go in a much
better way than my patches; I focused on the opts structure too much I
guess. :-) So, thanks for this restart. I'm going to compare it with
my changes and check which parts of my set makes sense in this
direction as well and which do not...

And this is maybe a bit premature idea now, but should we add some way
how to tell the user "this option is deprecated, use XXX"? I think
that it is a good idea if we are removing parts of the CLI, which
might break some user scripts or workflow. It would be pretty easy to
do - with something like your *_opts_parser() functions, just a case,
print the error and return EINVAL.

Cheers,
Jan
