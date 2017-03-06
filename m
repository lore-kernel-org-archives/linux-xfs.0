Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752398AbdCFAIy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 5 Mar 2017 19:08:54 -0500
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
References: <20170303231316.12716-1-mcgrof@kernel.org>
 <6de0c7e4-8d20-ea90-fc49-d47a787e3939@sandeen.net>
 <20170304045615.GL17542@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7a6509ef-1c2b-cc9c-ecb5-d0a39b5f31db@sandeen.net>
Date: Sun, 5 Mar 2017 18:08:06 -0600
MIME-Version: 1.0
In-Reply-To: <20170304045615.GL17542@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On 3/3/17 10:56 PM, Dave Chinner wrote:
> On Fri, Mar 03, 2017 at 09:49:58PM -0600, Eric Sandeen wrote:
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
>> I'm not necessarily the final word on this, but I have to say
>> I'm not a huge fan of having mkfs config files.  I've lived 
>> through that in mke2fs land, and my personal feeling is that
>> it can lead to confusion when distros start shipping config
>> files with different defaults than upstream ships in the
>> code itself.
>>
>> I guess I can see the argument for shipping old/compatible
>> defaults with newer progs and older kernels, but by the
>> time a distro ships a custom old default config file they could
>> also patch out the new features just as easily... (which
>> is also confusing, I guess ;) )
>>
>> After 25+ years of no external config file, I'm concerned
>> about principal of least surprise when the same xfsprogs version
>> starts behaving differently on different boxes based on a new
>> file that popped up in /etc ...
>>
>> At the very least, I would like to /not/ ship or install any
>> config file with xfsprogs by default; the code itself should
>> be the canonical, single point of truth for defaults for a stock
>> "make && make install" installation.
> 
> Hence my suggestion of libconfig - it can /write config files/ based
> on the current mkfs config. So there's no need to ship default
> config files - if a user wants a special config they can use mkfs to
> generate it and they can install it appropriately.
> 
> e.g. 'mkfs -W <options>' outputs a config file to stdout that
> matches the config specified on the command line, but does not make
> the filesystem (similar to the "-n" option). If no options are
> specified, the default config is emitted....

That sounds nice, but I guess I'd like to get some other thoughts
on the overall upsides and downsides of having config files which
alter a bare mkfs.xfs command's behavior.

Thanks,
-Eric
