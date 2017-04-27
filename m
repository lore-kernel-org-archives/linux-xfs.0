Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34554 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031467AbdD0JJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 05:09:07 -0400
Received: by mail-oi0-f49.google.com with SMTP id x184so30547238oia.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2017 02:09:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
References: <1493283574-1497-1-git-send-email-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 Apr 2017 11:09:06 +0200
Message-ID: <CAJfpegs=zMQzzVep7uJwvZp0ujw1kSK8VSEszcKB-VzeHAvCKg@mail.gmail.com>
Subject: Re: [PATCH 0/5] VFS API for getting filesystem's UUID
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Thu, Apr 27, 2017 at 10:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> As you observed, the sb->s_uuid field is not always filled by filesystems.
>
> Consumers, like overlayfs, that wish to use this field can check if is
> zeroed out as an indication for valid value.
>
> Christoph suggested to make the test more explicit and require the
> filesystems that fill the s_uuid field to set a super block flag.
>
> Do you agree with the proposed API?

Sure.

Thanks,
Miklos
