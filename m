Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34487 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbeJKVlS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 17:41:18 -0400
MIME-Version: 1.0
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923115968.5546.9927577186377570573.stgit@magnolia> <20181011134256.GC23424@infradead.org>
In-Reply-To: <20181011134256.GC23424@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Oct 2018 17:13:44 +0300
Message-ID: <CAOQ4uxiavoysJQEUEaMXb+mnZWhPT5kvmK6WZav9tbiJxara5A@mail.gmail.com>
Subject: Re: [PATCH 03/25] vfs: check file ranges before cloning files
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com

On Thu, Oct 11, 2018 at 4:43 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> > -EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
> > +EXPORT_SYMBOL(vfs_clone_file_prep);
>
> Btw, why isn't this EXPORT_SYMBOL_GPL?  It is rather Linux internal
> code, including some that I wrote which you lifted into the core
> in "vfs: refactor clone/dedupe_file_range common functions".

Because Al will shot down any attempt of those in vfs code:
https://lkml.org/lkml/2018/6/10/4

Thanks,
Amir.
