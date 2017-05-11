Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756628AbdEKXPU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 19:15:20 -0400
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com [209.85.161.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD11F23998
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 23:09:20 +0000 (UTC)
Received: by mail-yw0-f177.google.com with SMTP id l14so3680037ywk.1
        for <linux-xfs@vger.kernel.org>; Thu, 11 May 2017 16:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <646aa740-a9fc-98df-df9f-6b89bbed7261@sandeen.net>
References: <20170303231316.12716-1-mcgrof@kernel.org> <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de> <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de> <20170309223435.GT17542@dastard>
 <20170424050010.GD28800@wotan.suse.de> <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
 <CAB=NE6XoEoRo-iBP8vgC7shNQoK9j=unM6_YpDs1p26+i+wQ7A@mail.gmail.com>
 <20170511224603.GA28800@wotan.suse.de> <646aa740-a9fc-98df-df9f-6b89bbed7261@sandeen.net>
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Date: Thu, 11 May 2017 16:08:59 -0700
Message-ID: <CAB=NE6VDPunttSgH9qEhcPSHDdCvzUTskBbzPyhwnJ8Y9Jny2w@mail.gmail.com>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, jack@suse.com, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, Libor Pechacek <lpechacek@suse.com>

On Thu, May 11, 2017 at 3:57 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 5/11/17 5:46 PM, Luis R. Rodriguez wrote:
>
>> FWIW, I've looked at ways to address this without your future work Jan, ie
>> backporting this feature, and ultimately have decided to *not* allow any
>> command line overwrite for options specified in the configuration file. So
>> for the backported versions of this feature a user will only be able to
>> overwrite if the config file is commented out or removed.
>>
>> How we end up doing this upstream may differ given we may have a way to
>> properly do sanity checks overall and treat "defaults" as real "defaults".
>> But without such mechanisms implementing a sensible way to overwrite things
>> in a compatible way was just crap.
>>
>> As such for the backported versions of this feature I'll make this big note
>> on the man page:
>
> I'm a little confused - backported from where to where?  I'm not sure what
> a "backport" means in this context, when there is no upstream solution at this
> time.

Since we're still waiting for a bit of delta before I can push this
work then from my development tree to a stable older release.

>> """
>> One  of  the uses of the configuration file is to enable distributions
>> to provide mkfs.xfs(8) updates from a base distribution release and enable to
>> create filesystems which are sure to remain supported and compatible. As such
>> systems with a mkfs.xfs.conf(5) file present have very likely been well thought
>> out, and  overriding configuration  file  defaults is discouraged unless you
>> know what you are doing and are familiar with the associated risks.  If you
>> know what you are doing, wish to waive compatibility, and wish to overwrite the
>> configuration file provided the best option is to either remove or uncomment
>> the  configuration  file  completely  as options cannot be overwritten on the
>> command line.
>> """
>
> So are you planning a forked, non-upstream behavior for your distro?

Right.

> I think that disallowing commandline overrides of configfile settings is a
> mistake, and not what we'd want upstream.

For upstream I agree. Its how config files typically work after all.

> If you do it as a fork, mkfs should fail if conflicting options are specified, IMHO.

Sure, conflict check will be retained given the same command line
option mechanism would be used to set whatever is in the config file.

> The worst of all possible
> worlds is an admin typing an otherwise valid mkfs command, and getting a
> "successful" result which is /not/ what was specified by the user.

Right.

> Honestly, until an upstream solution is found, simply patching in new defaults
> seems safest (and least-element-of-surprise) for a distro.

Thing is we have no such easy "default" mechanism today. In the future
it sounds like this will change so what you describe should be much
easier. Sure, today a few options are set to 0 on main(), but trying
to see when an option actually gets set to a default value if no other
options are set is non trivial.

As for the backported approach, I don't expect the config file to
retain many options after all, only what is necessary to retain
compatibility with a base distro release.

  Luis
