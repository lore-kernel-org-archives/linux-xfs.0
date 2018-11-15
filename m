Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbeKPCH7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Nov 2018 21:07:59 -0500
Subject: Re: [PATCH] xfs: fix shared extent data corruption due to missing cow
 reservation
References: <20181113170819.15220-1-bfoster@redhat.com>
 <63420b28-0415-061e-37cd-efe6f6a19f4b@sandeen.net>
 <20181115155812.GA27656@bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e83c4201-d32e-87ca-3009-9aaf3ba6fe06@sandeen.net>
Date: Thu, 15 Nov 2018 09:59:33 -0600
MIME-Version: 1.0
In-Reply-To: <20181115155812.GA27656@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 11/15/18 9:58 AM, Brian Foster wrote:
> On Thu, Nov 15, 2018 at 09:51:58AM -0600, Eric Sandeen wrote:
>> On 11/13/18 11:08 AM, Brian Foster wrote:
>>
>>> For example, a buffered write occurs across the file offset (in FSB
>>> units) range of [29, 57]. A shared extent exists at blocks [29, 35]
>>> and COW reservation already exists at blocks [32, 34]. After
>>> accommodating a COW extent size hint of 32 blocks and the existing
>>> reservation at offset 32, xfs_reflink_reserve_cow() allocates 32
>>> blocks of reservation at offset 0 and returns with COW reservation
>>> across the range of [0, 34]. The associated data fork extent is
>>> still [29, 35], however, which isn't fully covered by the COW
>>> reservation.
>>>
>>> This leads to a buffered write at file offset 35 over a shared
>>> extent without associated COW reservation. Writeback eventually
>>> kicks in, performs an overwrite of the underlying shared block and
>>> causes the associated data corruption.
>>
>> Can you write this in the form of an xfstests reproducer please? :)
>>
> 
> I'll add it to the todo list.

thanks, it doesn't seem like the kind of thing that will be hit too often
at random, based on the struggles to reproduce it as first reported via
fsstress.

-Eric
