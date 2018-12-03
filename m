Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36516 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbeLCMw7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 07:52:59 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-7-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-7-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 14:51:52 +0200
Message-ID: <CAOQ4uxibdJaN-tQBnUeLejyReaVbi1HOnvqW=SUP7ph1+VhDuw@mail.gmail.com>
Subject: Re: [PATCH 06/11] vfs: copy_file_range needs to strip setuid bits
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
> The file we are copying data into needs to have its setuid bit
> stripped before we start the data copy so that unprivileged users
> can't copy data into executables that are run with root privs.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good.
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
