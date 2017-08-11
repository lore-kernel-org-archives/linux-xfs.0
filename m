Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752208AbdHKFiV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 01:38:21 -0400
Subject: Re: [PATCH v2] fiemap: Allow to specify range to fiemap
References: <20170810120439.GO21024@dastard>
 <1502368241-8928-1-git-send-email-nborisov@suse.com>
 <20170810161322.GV24087@magnolia>
 <c254f712-e2bd-502b-515f-5ba20097bffd@suse.com>
 <20170810211208.GY24087@magnolia>
 <348c2665-f0e8-48ff-277f-c46748678a3c@sandeen.net>
 <202242e0-6ae8-aebf-9b6f-ce4f91949b10@redhat.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a4aa4ada-22c1-6783-f136-a9949d81c4e7@suse.com>
Date: Fri, 11 Aug 2017 08:38:18 +0300
MIME-Version: 1.0
In-Reply-To: <202242e0-6ae8-aebf-9b6f-ce4f91949b10@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 11.08.2017 00:57, Eric Sandeen wrote:
> On 8/10/17 2:22 PM, Eric Sandeen wrote:
>> On 8/10/17 2:12 PM, Darrick J. Wong wrote:
>>> On Thu, Aug 10, 2017 at 07:46:35PM +0300, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 10.08.2017 19:13, Darrick J. Wong wrote:
>>>>> We don't decrement len each time through the ioctl loop?  Doesn't that
>>>>> cause us to request and retrieve rows for ranges we don't want?
>>>>
>>>> Hm, you are right, I believe on every iteration we should do:
>>>>
>>>> len -= last_logical - start_offset
>>>
>>> start_offset doesn't change, right?
>>>
>>> I would think len -= last_logical - fiemap->fm_start.
>>>
>>> Or just calculate end_offset = start_offset + length and set
>>> fiemap->fm_length = end_offset - last_logical... 
>>>
>>> ...though now that I look at that file even closer I wonder what is
>>> going on with that outer while loop counting extents?  Does -n exist to
>>> let users cap the number of records to print, even if that means we
>>> don't make it to the end of the range requested?
>>
>> -n should simply be the size of each fiemap request, i.e. how many to
>> request and fill on each iteration.  It should not affect how many
>> get printed in the end.
>>
>> At least that's how xfs_bmap is supposed to work, and therefore in theory
>> how xfs_io's fiemap should work.
> 
> ... except apparently that is not actually how it works :(

In my tests passing -n 1 doesn't print anything irrespective of whether
I use the newly added args, it was strange. It's supposed to define the
batch of extents to query at a time. However, that's definitely not what
it's doing... Also the man pages states that if -n is not passed fiemap
would query the number of extents required and use that, however the
code currently just uses the default of 32 extents ...
> 
> -Eric
> 
