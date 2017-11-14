Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60858 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755426AbdKNNbg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Nov 2017 08:31:36 -0500
Subject: Re: [PATCH v3 2/2] fiemap: Implement ranged query
References: <1510588073-5665-1-git-send-email-nborisov@suse.com>
 <1510588073-5665-2-git-send-email-nborisov@suse.com>
 <20171113214457.GX4094@dastard>
 <e97f774f-a3ae-04c0-4b74-6a4f26e72674@suse.com>
 <3491ce98-b744-90de-e01b-83f13abadfa9@sandeen.net>
 <6619a7bc-ecc1-b8aa-82d0-1747ee812463@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bbfdb7c8-81a7-0a42-ccfc-003f3b89de9b@sandeen.net>
Date: Tue, 14 Nov 2017 07:31:34 -0600
MIME-Version: 1.0
In-Reply-To: <6619a7bc-ecc1-b8aa-82d0-1747ee812463@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com



On 11/14/17 12:32 AM, Nikolay Borisov wrote:
> 
> 
> On 14.11.2017 00:22, Eric Sandeen wrote:
>> On 11/13/17 4:05 PM, Nikolay Borisov wrote:

...

>>> You are right this is a bit ugly, but it seems more consistend to me,
>>> rather than something like
>>>
>>> xfs_io -c "fiemap -r -n 10 -v 4k 10k" for example. And the reason why
>>> I'm using this hackish way and not declaring r as r: in getopt is
>>> because getopt doesn't recognise when a parameter takes more than 1
>>> argument.
>>
>> Sorry for chiming in so late after all the go-rounds, but:
>>
>> Why not just drop -r entirely, and make fiemap go into ranged mode iff a
>> range is specified at the end of the command, i.e.:
>>
>> fiemap [ -alv ] [ -n nx ] [ offset length ]
> 
> V2 was like that but it required some changing to the generic code which
> detects the presence of this feature and Dave objected hence v3.

Ok, sorry for being so behind and rehashing old discussions.  Let me look
at that.

-Eric
