Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40648 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755551AbdKJCI5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 21:08:57 -0500
Subject: Re: [PATCH] xfsprogs: fix wrong variable type in write_once function
References: <20171110011737.4089-1-zlang@redhat.com>
 <7ec102d7-a41f-7cef-07f7-3ebb548b8f22@sandeen.net>
 <20171110020644.GW21475@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <19739de9-bc41-5fd7-eb40-ae9077744537@sandeen.net>
Date: Thu, 9 Nov 2017 20:08:56 -0600
MIME-Version: 1.0
In-Reply-To: <20171110020644.GW21475@dhcp12-143.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 11/9/17 8:06 PM, Zorro Lang wrote:
> On Thu, Nov 09, 2017 at 07:47:14PM -0600, Eric Sandeen wrote:
>> On 11/9/17 7:17 PM, Zorro Lang wrote:
>>> The 'Coverity Scan' found a problem in new write_once() function:
>>>
>>> 272             size_t bytes;
>>> 273             bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
>>>>>>     CID 1420710:  Control flow issues  (NO_EFFECT)
>>>>>>     This less-than-zero comparison of an unsigned value is never true. "bytes < 0UL".
>>> 274             if (bytes < 0)
>>> 275                     return -1;
>>>
>>> That's unreasonable. do_pwrite return 'ssize_t' type value,
>> An int, actually, right?
> Yeah, I mean the pwrite manpage defines:
> 
> ssize_t pwrite(int fd, const void *buf, size_t count, off_t offset);

yes, but you said "do_pwrite" - which does call pwrite (ssize_t), and
returns it through an int.  :)  hence the request for a bit more fixing.

-Eric
