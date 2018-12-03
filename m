Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38152 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbeLCMsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 07:48:47 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-6-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-6-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 14:47:40 +0200
Message-ID: <CAOQ4uxgbFA_T_U53kM-HJH0mYMw3mF205TMgnKWDX-xZ5LrABg@mail.gmail.com>
Subject: Re: [PATCH 05/11] vfs: use inode_permission in copy_file_range()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 3, 2018 at 10:34 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Similar to FI_DEDUPERANGE, make copy_file_range() check that we have
> write permissions to the destination inode.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
