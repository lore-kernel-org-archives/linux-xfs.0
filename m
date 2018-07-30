Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59570 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727478AbeGaBTx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Jul 2018 21:19:53 -0400
Subject: Re: Recently-formatted XFS filesystems reporting negative used space
References: <CAKAc_Gwh-KMdnK6LqX3kE9jTmSHsg8_kzQE5fPsnL3xETD1O+w@mail.gmail.com>
 <3895eebe-3fa2-a977-4021-3bd6ef645fdd@sandeen.net>
 <CAKAc_GwXi4U=WceoWo_6dsjT_ThTYKbebOzxkcTAW2_-vfgt=g@mail.gmail.com>
 <CAKAc_GxsR9UxswqJMLhPOqR6HeYLi-rHZiEY8LLxs-hj0n=uMQ@mail.gmail.com>
 <20180717092626.pxb6wzhcswf2f77p@odin.usersys.redhat.com>
 <CAKAc_Gx5RaiEC1C8aSYZXAcZcyyPHPNWHy6ALuzOJvkgkg5nkA@mail.gmail.com>
 <830a7de7-34ca-7d79-d94a-ff16c98381a3@sandeen.net>
 <CAKAc_Gwh36OhTs9DfsfqxniRw+jZ5c-Tyh2P5D3tA+JJW31Y6g@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3a077653-8dc5-b38c-6ecf-6ed607a54d2b@sandeen.net>
Date: Mon, 30 Jul 2018 18:42:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAKAc_Gwh36OhTs9DfsfqxniRw+jZ5c-Tyh2P5D3tA+JJW31Y6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Filippo Giunchedi <fgiunchedi@wikimedia.org>
Cc: linux-xfs@vger.kernel.org

On 7/30/18 5:02 AM, Filippo Giunchedi wrote:
> On Sun, Jul 22, 2018 at 2:03 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 7/20/18 3:20 AM, Filippo Giunchedi wrote:
>>> To recap what we've seen, hardware bit flipping is extremely unlikely:
>>> the same type of sb_fdblocks corruption has appeared on four different
>>> hosts affecting at most one third of xfs filesystems per host. Also
>>> the corruption looks always the same, namely the 33rd bit flipped
>>> which also seems suspicious.
>>
>> Running a debug kernel with memory poisoning, KASAN, or something similar might
>> help catch it if it's a stray memory write of some sort...
> 
> Thanks! BTW we've experienced this again on a FS at around 77% usage
> and xfs_repair reports a flip in the 32nd bit (output below). We'll
> enable memory poisoning on said host and see if other filesystems on
> that host experience the same.
> I see in the patch thread it has been mentioned this particular
> condition will be checked and fixed/prevented in 4.19 though the root
> cause isn't know (?)

Yeah, the validation should happen in 4.19, but no idea what the root
cause is.  Catching it at write time may offer some clues, I hope,
if the debug kernel doesn't help.

-Eric
