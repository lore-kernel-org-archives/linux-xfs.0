Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36142 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030522AbdD0Igy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:36:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjKT3CNVR7rJysdFY+EdudPyz-u5RL8Rkk+eqSj9MAcNw@mail.gmail.com>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com>
 <20170427075946.GA22284@lst.de> <CAOQ4uxjKT3CNVR7rJysdFY+EdudPyz-u5RL8Rkk+eqSj9MAcNw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 27 Apr 2017 11:36:53 +0300
Message-ID: <CAOQ4uxhz89Z_tr=HsQtdSxYK2zKqx3-8bXZ0qFoNyOXdoAfkRA@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 11:01 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Apr 27, 2017 at 10:59 AM, Christoph Hellwig <hch@lst.de> wrote:
>> On Thu, Apr 27, 2017 at 10:58:31AM +0300, Amir Goldstein wrote:
>>> Unless mounted with nouuid, copy the uuid of the filesystem to
>>> struct super block s_uuid field, as several other filesystems do.
>>
>> This looks okay ... ish.
>>
>> Until we have a flag in the superblock that a given fs fills out s_uuid
>> no one can rely on it.  So please add the infrastructure that consumers
>> can actually make use of it while you're at it.
>
> All right. makes sense. will do.

Darrick,

While I am working on the infrastructure that Christoph requested,
please consider this patch as is for now, because:
1. Other filesystems do set s_uuid anyway
2. For my use case, I do check for NULL (zeros) value of s_uuid
    and this is pretty good validation if UUID has been filled
3. I do anticipate bikeshedding on the proposed infrastructure,
    mainly because of #2 above

Cheers,
Amir.
