Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44298 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdHSQ0y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Aug 2017 12:26:54 -0400
Date: Sat, 19 Aug 2017 09:26:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: rename defaultval to flagval in opts
Message-ID: <20170819162646.GU4796@magnolia>
References: <20170818103932.24607-1-jtulak@redhat.com>
 <20170819010300.GM10621@dastard>
 <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i72XgoXfNuSQPHn4ireQBRTiuhH4ngSdzhHgzW5uNWLVng@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Aug 19, 2017 at 08:40:57AM +0200, Jan Tulak wrote:
> On Sat, Aug 19, 2017 at 3:03 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Aug 18, 2017 at 12:39:32PM +0200, Jan Tulak wrote:
> >> The old name 'defaultval' was misleading - it is not the default value,
> >> but the value the option has when used as a flag by an user.
> >
> > Hmmm - ok, what we have here is the difference between design intent
> > and the current use of the field.
> >
> > The design intent is that the defaultval field can contain the
> > default value for any type of config field. It gets used when a user
> > either doesn't specify the option or doesn't specify a value for the
> > option that is being parsed. The special "need value" value tells
> 
> These are two things that can't be done in one field. If it worked
> that way, imagine what would happen with a flag that is disabled by
> default, like -m rmapbt? If you put here the default value for
> "disabled when not specified", you can't enable it with a flag. If you
> put here a value for "enable when used as a flag", you have just
> enabled it by default as well.
> 
> So this field ended up being used only when the option is used without
> a value, and my current set adds the "default when the option is not
> specified" field with another name, and for the sake of clarity, I
> renamed this one.
> 
> And this name already caused an issue - when rmapbt was added, the
> person went through the "it's a default" line of thoughts, set it to 0
> and then it was not possible to enable it with a flag. -m rmapbt was
> equivalent to -m rmapbt=0, and the only way to enable it was an
> explicit -m rmapbt=1. At which point, we can't speak about flags.

As "that person", I confirm that I set defaultval to zero for rmapbt
thinking that meant "off by default if no options given", not "if the
user specifies -m rmapbt without explicitly setting a value, then set
the value to zero".  It doesn't make sense that adding "-m rmapbt"
actually has the effect of /disabling/ rmap.

That said, I also don't remember if one of the side goals of cramming
all the config option data into the huge struct is to eliminate the
difference between the default value of an option if "" vs. if
"-m rmapbt".

> > the code that there isn't a defined default that can be used, so the
> > option must be specified with a value.
> >
> > The current implementation only contains default values for flag
> > fields, but that doesn't mean we can't use it for fields that are
> > not flags. And if that's the case, then renaming the field "flagval"
> > isn't the right thing to do....
> >
> 
> The field is used only when no value is provided, but the option is
> specified --> when the option is used as a flag. So "flagval" sounds
> ok to me.

<bikeshedding> default_flagval? :D

--D

> 
> Cheers,
> Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
