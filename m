Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33398 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932069AbeEHJzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 05:55:46 -0400
Received: by mail-yw0-f195.google.com with SMTP id g16-v6so9475869ywk.0
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 02:55:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1525627494-12873-6-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com> <1525627494-12873-6-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 12:55:45 +0300
Message-ID: <CAOQ4uxhONQdM_6t+c87pFkZ+HWL2mM06qhyTGUQWg_DhW=gPfw@mail.gmail.com>
Subject: Re: [PATCH 05/21] xfs: Set up infastructure for deferred attribute operations
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, May 6, 2018 at 8:24 PM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> This patch adds two new log item types for setting or
> removing attributes as deferred operations.  The
> xfs_attri_log_item logs an intent to set or remove an
> attribute.  The corresponding xfs_attrd_log_item holds
> a reference to the xfs_attri_log_item and is freed once
> the transaction is done.  Both log items use a generic
> xfs_attr_log_format structure that contains the attribute
> name, value, flags, inode, and an op_flag that indicates
> if the operations is a set or remove.
>
> At the moment, this feature will only be used by the parent
> pointer patch set which uses attributes to store information
> about an inodes parent.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
[...]

> +++ b/fs/xfs/xfs_trans_attr.c
> @@ -0,0 +1,283 @@
> +/*
> + * Copyright (c) 2017, Oracle Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation Inc.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_attr_item.h"
> +#include "xfs_alloc.h"
> +#include "xfs_bmap.h"
> +#include "xfs_trace.h"
> +#include "libxfs/xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_attr.h"
> +#include "xfs_inode.h"
> +#include "xfs_icache.h"
> +#include "xfs_quota.h"
> +
> +/*
> + * This routine is called to allocate an "extent free done"
> + * log item that will hold nextents worth of extents.  The
> + * caller must use all nextents extents, because we are not
> + * flexible about this at all.
> + */

Copy&paste error...

Thanks,
Amir.
