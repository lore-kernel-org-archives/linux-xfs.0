Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53492 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752377AbeEOOOh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 May 2018 10:14:37 -0400
Subject: Re: [PATCH] xfs_db: add blockget -L option
References: <20180510213636.GA5045@deer-run.com>
 <3ae25107-7242-a645-c0f7-784f35ed3e79@sandeen.net>
 <1C5C502C-D536-4C2C-B7CA-9B13F9B2EB20@deer-run.com>
 <20180515052755.GI23861@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <91298125-97e3-139e-d548-9c9052251442@sandeen.net>
Date: Tue, 15 May 2018 09:14:35 -0500
MIME-Version: 1.0
In-Reply-To: <20180515052755.GI23861@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Hal Pomeranz <hal@deer-run.com>
Cc: linux-xfs@vger.kernel.org



On 5/15/18 12:27 AM, Dave Chinner wrote:
> On Tue, May 15, 2018 at 12:27:38AM -0400, Hal Pomeranz wrote:
>> I get the argument Dave is making. But the reality of forensics is
>> that many of our tools are not reliable in all cases. We do a lot
>> of cross-validation for crucial results.
>>
>> Having multiple tools helps. Right now, we basically have nothing
>> for XFS. So adding this option to xfs_db makes things better.
>>
>> We work with underplayed file systems constantly, and it’s
>> less of a worry than you might think. Try my patched version of
>> xfs_db on a live file system of your choice. See if you can make
>> it blow up. When it doesn’t, please consider folding in my
>> patch.
> 
> And the source code to your new and improved xfs_db can be found
> where? I'm interested to know how you've solved the problem of
> detecting stale metadata from userspace on a live filesystem...

I believe he's referring to the patch he just sent, Dave.

-Eric
