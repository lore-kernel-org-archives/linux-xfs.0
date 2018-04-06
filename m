Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56252 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751415AbeDFCuC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Apr 2018 22:50:02 -0400
Subject: Re: [PATCH 2/6] xfs: pass xfs_dqblk to
 xfs_dquot_verify/xfs_dquot_repair
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <c92cfdb8-88c2-0f5b-7383-e5208fef6f5e@redhat.com>
 <20180405035241.GB7500@magnolia>
 <5c02fc77-28b6-4665-82f3-699fda82688c@sandeen.net>
 <20180405224033.GG23861@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3d482958-bf06-86f4-56e1-c679e9490495@sandeen.net>
Date: Thu, 5 Apr 2018 21:50:01 -0500
MIME-Version: 1.0
In-Reply-To: <20180405224033.GG23861@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 4/5/18 5:40 PM, Dave Chinner wrote:
> On Wed, Apr 04, 2018 at 11:13:03PM -0500, Eric Sandeen wrote:
>> On 4/4/18 10:52 PM, Darrick J. Wong wrote:
>>> On Wed, Apr 04, 2018 at 01:54:26PM -0500, Eric Sandeen wrote:
>>>> In order to validate the UUID in xfs_dquot_verify, we need
>>>> the full xfs_qblk, not just the xfs_disk_dquot_t (which is
>>>
>>>           ^^^^^^^^^ xfs_dqblk, right?
>>
>> yup
>>
>> ...
>>
>>>> @@ -192,14 +191,10 @@
>>>
>>> Any way you can get your diff generator to add -p to spit out the
>>> alleged function this chunk is supposed to land in?  It makes reviewing
>>> patches somewhat easier for me. :)
>>
>> No doubt ... I don't know why it doesn't do so, sorry.  :/  Will try
>> to figure that out.  Sorry about that.
> 
> diff -up

I am actually familiar with diff, thanks ;)  I couldn't figure out why
git & guilt weren't giving me the expected results.

For some reason I had this in this particular repo:

$ cat .gitattributes
*.c   diff=cpp
*.h   diff=cpp

Getting rid of that fixes it, I don't actually know why it was there.

-Eric
