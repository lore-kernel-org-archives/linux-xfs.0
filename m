Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40302 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752075AbeEUWYg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 May 2018 18:24:36 -0400
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
 <1f1e87df-aba5-e285-e3cb-820306f24f1c@sandeen.net>
 <20180518034600.GW23858@magnolia> <20180520001648.GN23861@dastard>
 <20180521153354.GH23858@magnolia>
 <20180521170530.GH24680@garbanzo.do-not-panic.com>
 <20180521221057.GP23861@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <80799366-31c1-7f23-7020-80caaf17a80c@sandeen.net>
Date: Mon, 21 May 2018 17:24:34 -0500
MIME-Version: 1.0
In-Reply-To: <20180521221057.GP23861@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On 5/21/18 5:10 PM, Dave Chinner wrote:
> On Mon, May 21, 2018 at 10:05:30AM -0700, Luis R. Rodriguez wrote:
>> On Mon, May 21, 2018 at 08:33:54AM -0700, Darrick J. Wong wrote:
>>> On Sun, May 20, 2018 at 10:16:48AM +1000, Dave Chinner wrote:
>>>> On Thu, May 17, 2018 at 08:46:00PM -0700, Darrick J. Wong wrote:
>>>>> <shrug> Bikeshedding more, what if either option accepted either an
>>>>> absolute path, or a file in $sysconfdir/etc/mkfs.xfs.d/ ?
>>>>
>>>> I kinda assumed that config files could be located anywhere, but we
>>>> only searched the sysconfig path if it didn't point at a local
>>>> file...
>>>
>>> <shrug> openat() semantics are fine enough with me, I think.
>>
>> Well this is a big difference, and I think being clear on this would
>> be good. If the user specified:
>>
>> 	-c foo
>> 	
>> and the file 'foo' is present but also exists on
>> $sysconfdir/etc/mkfs.xfs.d/foo do we use the local file if the user
>> did not pass ./foo ?
> 
> I would have expected "foo" to be considered the same as "./foo".
> It's a relative path.

Urgh, so now if foo exists in $PWD /and/ in $sysconfdir/etc/mkfs.xfs.d/foo
we have to have a hierarchy between the two?  :/

Ok. back up.  Honestly I think the only good reason to have config files
outside of $sysconfdir/etc/mkfs.xfs.d/ is to facilitate testing without
perturbing the system's files in order to do so.

In that case maybe we should distill it down to:

1) -c foo looks in $sysconfdir/etc/mkfs.xfs.d
2) -c /absolute/path/to/foo looks there, obviously

and drop relative paths.  Absolute paths are more cumbersome but testing
scripts won't care about that.  mkfs.xfs -c `pwd`/foo isn't that hard either.

-Eric
