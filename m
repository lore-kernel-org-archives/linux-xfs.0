Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57328 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754785AbeFNTFD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 15:05:03 -0400
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
 <20180614050844.GK10363@dastard> <20180614062949.GA6825@magnolia>
 <20180614174640.GE7508@wotan.suse.de> <20180614175909.GB8128@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3c6ec372-3941-386c-37b5-3e7415cf8b67@sandeen.net>
Date: Thu, 14 Jun 2018 14:05:02 -0500
MIME-Version: 1.0
In-Reply-To: <20180614175909.GB8128@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, sandeen@redhat.com, linux-xfs@vger.kernel.org



On 6/14/18 12:59 PM, Darrick J. Wong wrote:
> On Thu, Jun 14, 2018 at 07:46:40PM +0200, Luis R. Rodriguez wrote:
>> On Wed, Jun 13, 2018 at 11:29:49PM -0700, Darrick J. Wong wrote:
>>> On Thu, Jun 14, 2018 at 03:08:44PM +1000, Dave Chinner wrote:
>>>> On Wed, Jun 13, 2018 at 11:23:09PM -0500, Eric Sandeen wrote:
>>>>> On 6/13/18 11:06 PM, Dave Chinner wrote:
>>>>>> With this change, we'll have code to maintain it to ensure that the
>>>>>> file gets updated properly, and it will probably take more time and
>>>>>> effort to validate that the generated file is correct (and debug if
>>>>>> it's not!) compared to the 30s it will take to hand edit the
>>>>>> template file to change or add a new default...
>>
>> If we had an xfstest to *test* that same generated file, this would not
>> be an issue and from what I gather we need quite a bit of work to get there.
>>
>> I'm working on a test for config stuff but that will just test for now
>> (and this reveals some future work needed):
>>
>> a) a set of config files we know should work and ensure they produce the
>>    same filesystem as if we had used CLI params. We can use xfs_db -c version
>>    against both filesystems and check that each differences. Since this would
>>    use the same xfsprogs for the results of a config based filesystem and
>>    the CLI based filesystem the diff would only generate if there really
>>    was a change between both runs, and you can use any xfsprogs version
>>    for it.
> 
> Hmm, just out of curiosity, are there any mkfs cli/config options that
> do /not/ show up in the output of mkfs and/or 'xfs_db -c info'?

Of the options that actually write [meta]data to disk, these don't show
up in the info output:

-m uuid=
-l agnum=
-L <label>

The rest do in some form, though as you know several mkfs options all specify
the same metadata detail in different ways, so i.e. su/sunit distill down to
a single xfs_info field.

-Eric
