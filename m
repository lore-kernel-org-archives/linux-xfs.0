Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:33330 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbdHSGlT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 02:41:19 -0400
Received: by mail-wr0-f170.google.com with SMTP id b65so75934630wrd.0
        for <linux-xfs@vger.kernel.org>; Fri, 18 Aug 2017 23:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170819010300.GM10621@dastard>
References: <20170818103932.24607-1-jtulak@redhat.com> <20170819010300.GM10621@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Sat, 19 Aug 2017 08:40:57 +0200
Message-ID: <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
Subject: Re: [PATCH] mkfs: rename defaultval to flagval in opts
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Aug 19, 2017 at 3:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Aug 18, 2017 at 12:39:32PM +0200, Jan Tulak wrote:
>> The old name 'defaultval' was misleading - it is not the default value,
>> but the value the option has when used as a flag by an user.
>
> Hmmm - ok, what we have here is the difference between design intent
> and the current use of the field.
>
> The design intent is that the defaultval field can contain the
> default value for any type of config field. It gets used when a user
> either doesn't specify the option or doesn't specify a value for the
> option that is being parsed. The special "need value" value tells

These are two things that can't be done in one field. If it worked
that way, imagine what would happen with a flag that is disabled by
default, like -m rmapbt? If you put here the default value for
"disabled when not specified", you can't enable it with a flag. If you
put here a value for "enable when used as a flag", you have just
enabled it by default as well.

So this field ended up being used only when the option is used without
a value, and my current set adds the "default when the option is not
specified" field with another name, and for the sake of clarity, I
renamed this one.

And this name already caused an issue - when rmapbt was added, the
person went through the "it's a default" line of thoughts, set it to 0
and then it was not possible to enable it with a flag. -m rmapbt was
equivalent to -m rmapbt=0, and the only way to enable it was an
explicit -m rmapbt=1. At which point, we can't speak about flags.

> the code that there isn't a defined default that can be used, so the
> option must be specified with a value.
>
> The current implementation only contains default values for flag
> fields, but that doesn't mean we can't use it for fields that are
> not flags. And if that's the case, then renaming the field "flagval"
> isn't the right thing to do....
>

The field is used only when no value is provided, but the option is
specified --> when the option is used as a flag. So "flagval" sounds
ok to me.

Cheers,
Jan
