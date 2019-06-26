Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36354 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfFZPAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 11:00:22 -0400
MIME-Version: 1.0
References: <20190626061711.27690-1-amir73il@gmail.com> <fe818d07-f539-4b2c-fe26-dbc18003e3e2@sandeen.net>
In-Reply-To: <fe818d07-f539-4b2c-fe26-dbc18003e3e2@sandeen.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 26 Jun 2019 18:00:08 +0300
Message-ID: <CAOQ4uxj12x4+FDfcA4t72nYEvXAsV7FhgYQLDSA068Tdyz-Tsw@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: reorganize source file handling in copy_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jun 26, 2019 at 5:51 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> rename and rearrange some of the vars related to using an open
> file number as the source file, so that we don't temporarily
> store a non-fd number in a var called "fd," and do the fd
> assignment in a consistent code location.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> Amir, what do you think about this tweak, just for maintainability
> I'd prefer to only assign an actual fd to "fd," and handle that
> assignment in the same code location for both invocation options.
> Thoughts?  Not a big deal either way.

I think that looks much better.

...

> +       } else
> +               fd = filetable[src_file_nr].fd;

I would match else { } to if { }.
 Other than that, looks good.

You may add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
