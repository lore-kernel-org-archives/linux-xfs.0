Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36790 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdEBON5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2017 10:13:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170502073019.GD11582@lst.de>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com> <20170502073019.GD11582@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 May 2017 17:13:56 +0300
Message-ID: <CAOQ4uxjKbgCwhV4iBNVyfmS5+iR3o1BPF+PDj7YmrPP-qTv1eA@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, May 2, 2017 at 10:30 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Fri, Apr 28, 2017 at 05:00:01PM +0300, Amir Goldstein wrote:
>> Copy the uuid of the filesystem to struct super_block s_uuid field,
>> as several other filesystems already do.  Copy regardless of the nouuid
>> mount option, because other filesystems also do not guaranty uniqueness
>> of the s_uuid field in super_block struct.
>
> No guaranteeing uniqueness will create problems, don't do that.

How can it create problems if uniqueness is not guaranteed with
Current s_uuid? Even if we did make the xfs uuid table code generic
It couldn't be the vfs default. Filesystems will have to opt in.

>
> Other file system didn't use to do the uuid table check that XFS did
> either, and that's a fatal bug.  In the long run we'll need to move
> this check to the VFS now that we have s_uuid.
>
> Also while checking for a nul uuid is probably ok we need to formalize
> that at least that the check is needed.  Preferably by adding a little
> inline helper for it, and documenting it.

Makes sense. I'll post a patch.
