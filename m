Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38472 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757557AbdELQFP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 12:05:15 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
 <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
 <20170309175750.GE14437@wotan.suse.de> <20170309223435.GT17542@dastard>
 <20170424050010.GD28800@wotan.suse.de>
 <CACj3i70n4RctOrBVY4Jh8+p7=8NzfPDMp0o4+05nE76AV7ofSA@mail.gmail.com>
 <CAB=NE6XoEoRo-iBP8vgC7shNQoK9j=unM6_YpDs1p26+i+wQ7A@mail.gmail.com>
 <20170511224603.GA28800@wotan.suse.de>
 <646aa740-a9fc-98df-df9f-6b89bbed7261@sandeen.net>
 <CAB=NE6VDPunttSgH9qEhcPSHDdCvzUTskBbzPyhwnJ8Y9Jny2w@mail.gmail.com>
Message-ID: <142427e4-658a-3df2-9ff3-77beb868f48d@sandeen.net>
Date: Fri, 12 May 2017 11:05:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VDPunttSgH9qEhcPSHDdCvzUTskBbzPyhwnJ8Y9Jny2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, jack@suse.com, Jeff Mahoney <jeffm@suse.com>, okurz@suse.com, Libor Pechacek <lpechacek@suse.com>

On 5/11/17 6:08 PM, Luis R. Rodriguez wrote:
> On Thu, May 11, 2017 at 3:57 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 5/11/17 5:46 PM, Luis R. Rodriguez wrote:
>>
>>> FWIW, I've looked at ways to address this without your future work Jan, ie
>>> backporting this feature, and ultimately have decided to *not* allow any
>>> command line overwrite for options specified in the configuration file. So
>>> for the backported versions of this feature a user will only be able to
>>> overwrite if the config file is commented out or removed.
>>>
>>> How we end up doing this upstream may differ given we may have a way to
>>> properly do sanity checks overall and treat "defaults" as real "defaults".
>>> But without such mechanisms implementing a sensible way to overwrite things
>>> in a compatible way was just crap.
>>>
>>> As such for the backported versions of this feature I'll make this big note
>>> on the man page:
>>
>> I'm a little confused - backported from where to where?  I'm not sure what
>> a "backport" means in this context, when there is no upstream solution at this
>> time.
> 
> Since we're still waiting for a bit of delta before I can push this
> work then from my development tree to a stable older release.
> 
>>> """
>>> One  of  the uses of the configuration file is to enable distributions
>>> to provide mkfs.xfs(8) updates from a base distribution release and enable to
>>> create filesystems which are sure to remain supported and compatible. As such
>>> systems with a mkfs.xfs.conf(5) file present have very likely been well thought
>>> out, and  overriding configuration  file  defaults is discouraged unless you
>>> know what you are doing and are familiar with the associated risks.  If you
>>> know what you are doing, wish to waive compatibility, and wish to overwrite the
>>> configuration file provided the best option is to either remove or uncomment
>>> the  configuration  file  completely  as options cannot be overwritten on the
>>> command line.
>>> """
>>
>> So are you planning a forked, non-upstream behavior for your distro?
> 
> Right.

I'm not really in a position to tell a distro what to do, other than out of
concern for polluting user expectations with non-upstream behaviors.  Which
/is/ a concern; I'm not looking forward to complaints from your users that
upstream has "broken" behavior w.r.t. your fork when we (finally...?) ship a
config-file capable mkfs.xfs.

i.e. you go that route, your forked behavior will differ from any behavior
that we ever ship upstream.  Your users will eventually need to adapt to
considerably different behavior which is unique to your distro, and just to
be clear: "but we already shipped it!" will not hold any weight whatsoever
in future upstream behavior discussions...

If you want to ship newer progs w/ older defaults, I really don't understand
why you can't just revert the patches that added the new defaults.

-Eric

