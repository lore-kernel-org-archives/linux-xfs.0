Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:37637 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeLTH1O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 02:27:14 -0500
MIME-Version: 1.0
References: <20181220053622.GD27176@magnolia>
In-Reply-To: <20181220053622.GD27176@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 20 Dec 2018 09:27:02 +0200
Message-ID: <CAOQ4uxj3cnZJNqZRt-ijGZcq8rjcBfiF1UrctZK4-jCe=UnEEw@mail.gmail.com>
Subject: Re: [RFC PATCH] iomap: take responsibility for the filesystem iomap code
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On Thu, Dec 20, 2018 at 8:47 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> XFS is the primary user of the filesystem iomap code, so we (the XFS
> community, specifically) will explicitly take responsibility for its
> maintenance.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> Just floating this as a test balloon.  Would like at acks from at least
> Dave and Christoph since they wrote most of the fs iomap code.
> ---
>  MAINTAINERS |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8119141a926f..a36a88a72423 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16518,6 +16518,16 @@ L:     alsa-devel@alsa-project.org (moderated for non-subscribers)
>  S:     Supported
>  F:     sound/xen/*
>
> +IOMAP FILESYSTEM LIBRARY

Sort alphabetically please.

Thanks,
Amir.
