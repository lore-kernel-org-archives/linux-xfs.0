Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41421 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfDHGVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 02:21:00 -0400
MIME-Version: 1.0
References: <155466882175.633834.15261194784129614735.stgit@magnolia> <155466884962.633834.14320700092446721044.stgit@magnolia>
In-Reply-To: <155466884962.633834.14320700092446721044.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 8 Apr 2019 09:20:47 +0300
Message-ID: <CAOQ4uxj4WLX8sWbnm11Ps+rmCNTPecV-w9YUzJfKDtDs+qTx3Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: don't allow most setxattr to immutable files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>

On Sun, Apr 7, 2019 at 11:28 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> The chattr manpage has this to say about immutable files:
>
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
>
> However, we don't actually check the immutable flag in the setattr code,
> which means that we can update project ids and extent size hints on
> supposedly immutable files.  Therefore, reject a setattr call on an
> immutable file except for the case where we're trying to unset
> IMMUTABLE.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Did you miss my comment on v1, or do you not think this use case
is going to hurt any application that is not a rootkit?

chattr +i foo => OK
chattr +i foo => -EPERM

Thanks,
Amir.
