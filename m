Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33191 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754009AbdD0IBH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 04:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <20170427075946.GA22284@lst.de>
References: <1493279911-2936-1-git-send-email-amir73il@gmail.com> <20170427075946.GA22284@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 27 Apr 2017 11:01:06 +0300
Message-ID: <CAOQ4uxjKT3CNVR7rJysdFY+EdudPyz-u5RL8Rkk+eqSj9MAcNw@mail.gmail.com>
Subject: Re: [PATCH] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 10:59 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Apr 27, 2017 at 10:58:31AM +0300, Amir Goldstein wrote:
>> Unless mounted with nouuid, copy the uuid of the filesystem to
>> struct super block s_uuid field, as several other filesystems do.
>
> This looks okay ... ish.
>
> Until we have a flag in the superblock that a given fs fills out s_uuid
> no one can rely on it.  So please add the infrastructure that consumers
> can actually make use of it while you're at it.

All right. makes sense. will do.
