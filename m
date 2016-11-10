Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail2.postbox.xyz ([81.169.216.193]:53343 "EHLO
        mail2.postbox.xyz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935170AbcKJUYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2016 15:24:03 -0500
Message-ID: <164fda6af0c9e67fcacbe9b0860bf44f.squirrel@mail2.postbox.xyz>
In-Reply-To: <bbd0f6bd-2d69-29ab-4205-19e3202c8444@sandeen.net>
References: <44d2cb2765781d64e9549b371a2f9686.squirrel@mail2.postbox.xyz>
    <bbd0f6bd-2d69-29ab-4205-19e3202c8444@sandeen.net>
Date: Thu, 10 Nov 2016 21:23:59 +0100
Subject: Re: sb_agblocks
From: "Chris" <chris2014@postbox.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

Thank you!

Eric Sandeen wrote:
> On 11/10/16 8:15 AM, Chris wrote:
>> All,
>>
>> howto display size and number of Allocation Groups? I think 1 varialbe
>> is
>> sb_agblocks.
>
> (whoops, reply-all this time)
>
> xfs_info /path/to/mount/point will tell you, if it's mounted.
>
> Otherwise xfs_db -c "sb 0" -c "p blocksize" -c "p agblocks" -c "p agcount"
> /dev/whatever
>
> will give you block size, blocks per AG, and number of AGs.
>
> -Eric
>
>> - Chris
>


