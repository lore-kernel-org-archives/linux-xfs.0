Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33882 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751450AbdCIEms (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 23:42:48 -0500
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <83a0df73-be0e-e3f9-df47-9b5c4a226498@sandeen.net>
 <20170309005130.GC14437@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ac91cbba-83b7-31d4-0fc9-cdb52286acdf@sandeen.net>
Date: Wed, 8 Mar 2017 22:41:52 -0600
MIME-Version: 1.0
In-Reply-To: <20170309005130.GC14437@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, Jan Tulak <jtulak@redhat.com>


On 3/8/17 6:51 PM, Luis R. Rodriguez wrote:
> On Wed, Mar 08, 2017 at 06:16:57PM -0600, Eric Sandeen wrote:
>> On 3/3/17 5:13 PM, Luis R. Rodriguez wrote:
>>> This series adds mkfs.xfs.conf support, so that options can now be
>>> shoved into a configuration file. This enables certain defaults to be
>>> saved for folks sticking to certain values, but more importantly it
>>> also enables distributions to override certain defaults so that new
>>> filesystems remain compatible with older distributions.
>>>
>>> This has been based on top of xfsprogs-dev v4.9.0-rc1.
>>>
>>> Given we already have an existinsg infrastructure to validate argument
>>> values this reuses that infrastructure by first adding helpers and porting
>>> over the argument parsing suppor to use these helpers.
>>
>> Hm, one functional problem with this, aside from Dave's concerns and
>> suggestions, is that many options in the config file can't actually
>> be overridden on the commandline because they are treated as having
>> been respecified, which is not allowed:
>>
>> # mkfs.xfs -m crc=1 -m crc=0 -f fsfile
>> -m crc option respecified
>> Usage: mkfs.xfs
> 
> This was dealt by enabling the last option taken to override, and
> this mechanism was also taken to enable the config file to take
> the first value but let the command line to override. Refer to
> usage of reset_opt(). Granted I had only done this on B_LOG but
> this can easily be made to enable us to reset for all options.

Well, the above test was with your full patchset applied,
so my point is that it's not currently working properly as posted...

But are you proposing adding this reset_opt() to /every/ option?
That would undo all of the respecification checks, which were
put there for a reason (I assume?) ;)  I don't really remember
how all of the respecification and compatibility checking works
tbh, I'd have to dig back into it.  Maybe jtulak can help...

But it makes little sense to have a framework to prevent
respecification but then render it useless with reset_opt()
after each option gets parsed.  Or do I misunderstand?

> If we don't want to enable subsequent command line entries to
> override (to keep old behaviour) but still allow at least the
> command line to override the config file options, that's also
> doable.

Well, I'm going to need to refamiliarize myself with how the
conflict checking works, and why respecification is prohibited.
If respecification matters, it matters just as much whether the
first specification came from the config file or from the command
line.

-Eric

>   Luis
> 
