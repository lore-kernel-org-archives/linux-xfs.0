Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45716 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752990AbdLHNha (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Dec 2017 08:37:30 -0500
Subject: Re: [PATCH 1/5] mkfs: Don't emit default config message yet
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
 <62f67117-150d-e456-d9dd-3a19938cb03a@sandeen.net>
 <20171208042153.GI19219@magnolia> <20171208045422.GL5858@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <855fd30f-2c53-6956-808d-645c285746c6@sandeen.net>
Date: Fri, 8 Dec 2017 07:37:28 -0600
MIME-Version: 1.0
In-Reply-To: <20171208045422.GL5858@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 12/7/17 10:54 PM, Dave Chinner wrote:
> On Thu, Dec 07, 2017 at 08:21:53PM -0800, Darrick J. Wong wrote:
>> On Thu, Dec 07, 2017 at 10:13:15PM -0600, Eric Sandeen wrote:
>>> Until we have more than one possible source of configuration,
>>> there is no need to emit the only possibility and clutter
>>> the output.  We can decide how it should all look when we
>>> get more than one source.
>>>
>>> Apply some i18n to the config description, though.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> Looks ok, I guess,
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> (I wonder why Dave put the printf in there, but I'll let him answer that.)
> 
> Because I wanted to demonstrate to everyone where the config file
> based defaults should be introduced. i.e. before the printf that
> says where the defaults were sourced from!

Sure, and having the infrastructure and the big comment helps, and
it's all still there.

But we shouldn't emit configuration details about non-configurable
things to every user in the meantime, just to remind developers what
to do next.

-Eric
