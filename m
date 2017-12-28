Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34492 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbdL1Vgh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Dec 2017 16:36:37 -0500
Subject: Re: [PATCH 6/7] mkfs: resolve sector size CLI conflicts
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-7-david@fromorbit.com>
 <20171220025958.GN12613@magnolia> <20171220035601.GE4094@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b80e8bf-3447-539d-96a7-b4b06a2f9414@sandeen.net>
Date: Thu, 28 Dec 2017 13:36:36 -0800
MIME-Version: 1.0
In-Reply-To: <20171220035601.GE4094@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 12/19/17 7:56 PM, Dave Chinner wrote:
> On Tue, Dec 19, 2017 at 06:59:58PM -0800, Darrick J. Wong wrote:
>> On Mon, Dec 18, 2017 at 08:11:57PM +1100, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Now we have a two dimensional conflict array, convert the sector
>>> size CLI option conflict determination to use it. To get the error
>>> specification just right, we also need to tweak how we store
>>> and validate the sector size CLI parameter state in the options
>>> table.
>>>
>>> Old:
>>>
>>> $ mkfs.xfs -N -s size=4k -d sectsize=512 /dev/pmem0
>>> Cannot specify both -d sectsize and -d sectlog
>>> .....
>>>
>>> New:
>>>
>>> $ mkfs.xfs -N -s size=4k -d sectsize=512 /dev/pmem0
>>> Cannot specify both -s size and -d sectsize
>>> .....
> ....
>>> @@ -964,8 +991,8 @@ conflict(
>>>  	int			conflict)
>>>  {
>>>  	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
>>> -			opts->name, opts->subopts[option],
>>> -			con_opts->name, con_opts->subopts[conflict]);
>>> +			con_opts->name, con_opts->subopts[conflict],
>>> +			opts->name, opts->subopts[option]);
>>
>> Why is it necessary to change this around?  Surely
>>
>> 	Cannot specify both -s barfu and -d fubar
>>
>> and
>>
>> 	Cannot specify both -d fubar and -s barfu
>>
>> aren't /that/ much different?
>>
>> Or is this one of those things that fixes up an xfstest or something?
> 
> Ummm, that might be a stray hunk of code. if it's necessary it
> should be in the original patch that changed this error message, not
> in this patch.
> 
> I'll have to go check. Too hot here to think right now.

Let me know what to do about this, I can just drop the hunk unless
you decided there's a reason for it.

-eric
