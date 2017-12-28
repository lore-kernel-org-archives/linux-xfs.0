Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34442 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751220AbdL1Vft (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Dec 2017 16:35:49 -0500
Subject: Re: [PATCH 7/7] mkfs: remove logarithm based CLI options
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-8-david@fromorbit.com>
 <20171220030111.GO12613@magnolia> <20171220040131.GF4094@dastard>
 <20171220052136.GQ12613@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7c8fbff9-aa41-3f1a-73fa-39cf09ff9df0@sandeen.net>
Date: Thu, 28 Dec 2017 13:35:47 -0800
MIME-Version: 1.0
In-Reply-To: <20171220052136.GQ12613@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 12/19/17 9:21 PM, Darrick J. Wong wrote:
> On Wed, Dec 20, 2017 at 03:01:31PM +1100, Dave Chinner wrote:
>> On Tue, Dec 19, 2017 at 07:01:12PM -0800, Darrick J. Wong wrote:
>>> On Mon, Dec 18, 2017 at 08:11:58PM +1100, Dave Chinner wrote:
>>>> From: Dave Chinner <dchinner@redhat.com>
>>>>
>>>> Very few people use the log2 based size options for various mkfs
>>>> parameters and they just clutter up the code. Get rid of them.
>>>
>>> Maybe we should deprecate them for at least one release instead of
>>> just hard breaking everyone's scripts?
>>
>> Yet we don't even test that these options give the right results :/
>> i.e. this patch does not cause any new regressions in xfstests...  I
>> know of only one person who used them, and that was a guy that did
>> testing for us in his spare time a few years ago.
>>
>> Hence I'm of the opinion we should just remove them, just
>> like we don't give people any warning of default mkfs values
>> changing. Eric can decide what to do, but I wrote this patch after
>> he pondered aloud on #xfs if we should just remove these options :P
> 
> Ahhh, so we can blame the maintainer then!  In that case,
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 8-)

I'm good with that, they are stupid.  Kill them with fire.
Anyone doing "-s log=5" deserves punishment, IMHO.  

-Eric
