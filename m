Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53940 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750747AbdK3V5R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 16:57:17 -0500
Subject: Re: [PATCH 1/5] xfs_db: print structure padding fields consistently
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094860737.27182.5422098949147661107.stgit@magnolia>
 <5fc6a92d-b7f7-2dae-862c-d266cc46df99@sandeen.net>
 <20171130215149.GL21412@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a19255b1-f186-2db1-0a87-ff432ac6b7fe@sandeen.net>
Date: Thu, 30 Nov 2017 15:57:16 -0600
MIME-Version: 1.0
In-Reply-To: <20171130215149.GL21412@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org



On 11/30/17 3:51 PM, Darrick J. Wong wrote:
> On Thu, Nov 30, 2017 at 03:37:54PM -0600, Eric Sandeen wrote:
>> On 11/17/17 1:56 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> We are very inconsistent about how we print padding fields in on-disk
>>> structures -- sometimes we hide it from printall, sometimes we deviate
>>> from unsigned hex values, etc.  Make this all consistent -- never hide
>>> padding values, always print them as unsigned hex integers.
>>
>> I'm not sure I see the point to cluttering up structure printing
>> with padding, and would prefer to hide them /all/ by default (and
>> set them all to hex printing when explicitly asked for).
>>
>> Consistency is good but I'm not sure we need to consistently print
>> values that are never even used...?
> 
> Ok.  Will you take a patch that changes them all to FLD_SKIPALL?

and sets them all to hex type, and adds missing ones?  Sure.

If you love the idea of printing padding or need it, that's ok,
I'd just like a little justification for the extra clutter,
if you need it. :)

Thanks,
-Eric
