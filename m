Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33513 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932677AbdEOTiT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 May 2017 15:38:19 -0400
MIME-Version: 1.0
In-Reply-To: <20170515154308.26739-18-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de> <20170515154308.26739-18-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 May 2017 22:38:18 +0300
Message-ID: <CAOQ4uxgyetFTbtuE3H2Msv9Zg1LEdoxr0YqZJ6yv0cFgiTAmAw@mail.gmail.com>
Subject: Re: [PATCH 17/17] fs: switch ->s_uuid to uuid_t
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, May 15, 2017 at 6:43 PM, Christoph Hellwig <hch@lst.de> wrote:
> For some file systems we still memcpy into it, but in various places this
> already allows us to use the proper uuid helpers.  More to come..
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -75,7 +75,7 @@ xfs_uuid_mount(
>
>         /* Publish UUID in struct super_block */
>         BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));

BUILD_BUG_ON not needed anymore now that s_uuid is uuid_t

> -       memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
> +       uuid_copy(&mp->m_super->s_uuid, uuid);
