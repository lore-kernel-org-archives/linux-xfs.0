Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34494 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033571AbdD0NzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 09:55:13 -0400
MIME-Version: 1.0
In-Reply-To: <9958b109-8b83-c39c-b6f3-249ffe3f812c@sandeen.net>
References: <CAOQ4uxgzd35J8ii8WWifrjHowkKwTZh7=zmN5Q3Qx4ADEKtqXQ@mail.gmail.com>
 <1493279911-2936-1-git-send-email-amir73il@gmail.com> <20170427075946.GA22284@lst.de>
 <5818.1493297821@warthog.procyon.org.uk> <12937.1493299325@warthog.procyon.org.uk>
 <9958b109-8b83-c39c-b6f3-249ffe3f812c@sandeen.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 27 Apr 2017 16:55:12 +0300
Message-ID: <CAOQ4uxjNBqHWHB7hJUKbh5hBqCY6Y2z8JpzWxmfsW40-6qjtvw@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 4:50 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 4/27/17 8:22 AM, David Howells wrote:
>> Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>> You mean if it is NULL_UUID_LE? Yes, that is what I do now.
>>> Christoph suggested that this is not robust enough.
>>> I'm rather indifferent about the need of a flag.
>>
>> I was thinking more that s_uuid would be a NULL pointer if the fs doesn't have
>> a uuid.
>
> but s_uuid in the vfs superblock isn't a pointer:
>
>         u8 s_uuid[16];                          /* UUID */
>
> (or am I missing your point?)
>
> -Eric
>

IMO, its just too simple to compare to NULL_UUID_LE and/or
the set/check a flag.
I don't think we should bother with any other option.

Amir.
