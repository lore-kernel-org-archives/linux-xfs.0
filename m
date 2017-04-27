Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33231 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdD0OIN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 10:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <13614.1493301655@warthog.procyon.org.uk>
References: <CAOQ4uxgzd35J8ii8WWifrjHowkKwTZh7=zmN5Q3Qx4ADEKtqXQ@mail.gmail.com>
 <1493279911-2936-1-git-send-email-amir73il@gmail.com> <20170427075946.GA22284@lst.de>
 <5818.1493297821@warthog.procyon.org.uk> <12937.1493299325@warthog.procyon.org.uk>
 <9958b109-8b83-c39c-b6f3-249ffe3f812c@sandeen.net> <13614.1493301655@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 27 Apr 2017 17:08:09 +0300
Message-ID: <CAOQ4uxgGz9P1aA9LbGZ+NtU3sfqOUqxk6=UuF1haOTSbmgLUnA@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 5:00 PM, David Howells <dhowells@redhat.com> wrote:
> Eric Sandeen <sandeen@sandeen.net> wrote:
>
>> but s_uuid in the vfs superblock isn't a pointer:
>>
>>         u8 s_uuid[16];                          /* UUID */
>>
>> (or am I missing your point?)
>
> No, I'm getting it wrong.  For some reason I'm thinking it's a pointer.  I
> should probably know better.  I wonder if it should be a struct uuid_v1...
>

If anything, I think we should hoist uuid_t from fs/xfs/uuid.h.
Or arbitrarily use uuid_le, just so it is easy to do
 uuid_le_cmp(sb->s_uuid, NULL_UUID_LE)
