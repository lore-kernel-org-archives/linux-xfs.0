Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42386 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbeLCM4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 07:56:54 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-12-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-12-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 14:55:46 +0200
Message-ID: <CAOQ4uxj9k6rHAXFrNPUDVD7Mw32JeK7T0HUaytxjvmguyjDjGw@mail.gmail.com>
Subject: Re: [PATCH 11/11] ovl: allow cross-device copy_file_range calls
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
> Restrictions on cross-device copy_file_range() only affect the
> vfs_copy_file_range() call to the lower filesystems. They will
> handle the copy appropriately, so OVL will never see a EXDEV error
> from them. Hence we can remove the EXDEV checks and error handling
> from the ovl_copy_file_range() implementation.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
