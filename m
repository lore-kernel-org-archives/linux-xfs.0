Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40654 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfEOMks (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:40:48 -0400
Subject: Re: [PATCH 06/11] libxfs: create new file trans_buf.c
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-7-git-send-email-sandeen@redhat.com>
 <20190515060750.GY29573@dread.disaster.area>
 <20190515065238.GF29211@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3a0746b9-d726-f671-975b-7adc444fdf95@sandeen.net>
Date: Wed, 15 May 2019 07:40:45 -0500
MIME-Version: 1.0
In-Reply-To: <20190515065238.GF29211@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org



On 5/15/19 1:52 AM, Christoph Hellwig wrote:
> On Wed, May 15, 2019 at 04:07:50PM +1000, Dave Chinner wrote:
>> On Fri, May 10, 2019 at 03:18:25PM -0500, Eric Sandeen wrote:
>>> Pull functions out of libxfs/*.c into trans_buf.c, if they roughly match
>>> the kernel's xfs_trans_buf.c file.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>
>> So I have no problems with this, but I'm not sure what the eventual
>> goal is? Just sharing code, or is there some functionality that
>> requires a more complete transaction subsystem in userspace?
>>
>> I'm asking because if the goal is eventual unification with the
>> kernel code, then we probably should name the files the same as the
>> kernel code so we don't have to rename them again when we do the
>> unification. That will make history searching a bit easier - less
>> file names to follow across and git blame works a whole lot better...
> 
> Even if we don't want to directly share code having the same file
> name would still be nice..

That's the goal, but I didn't want to do it until they really were
shared.  Right now scripts to merge and diff assume that 
libxfs/xfs_* are shared w/ kernel.

We could work around that, but I just figured I wouldn't give them
the same name until they are really the same file.

Doesn't matter much to me either way tbh.

-Eric
