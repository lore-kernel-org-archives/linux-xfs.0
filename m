Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45861 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbeLCMzj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 07:55:39 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-11-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-11-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 14:54:31 +0200
Message-ID: <CAOQ4uxhsVfqGkYi1v1Gd6BnzGsCb5=sOcByB0Nwp_ZGaFTmOPw@mail.gmail.com>
Subject: Re: [PATCH 10/11] vfs: allow generic_copy_file_range to copy across devices
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
> do_splice_direct() can copy across superblocks without problems.
> Remove the same superblock restriction on this fallback code.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
