Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:38021 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754492AbeEHHdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 03:33:06 -0400
Received: by mail-yb0-f180.google.com with SMTP id w14-v6so10829888ybm.5
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 00:33:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1525627494-12873-5-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com> <1525627494-12873-5-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 10:33:05 +0300
Message-ID: <CAOQ4uxiNvdvw6Hn4bvESitVPgzYYy581KdYiqdBX0XXFpL59Xw@mail.gmail.com>
Subject: Re: [PATCH 04/21] xfs: Add attibute remove and helper functions
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, May 6, 2018 at 8:24 PM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> This patch adds xfs_attr_remove_args. These sub-routines remove
> the attributes specified in @args. We will use this later for setting
> parent pointers as a deferred attribute operation.
>

But this patch also adds xfs_defer_init()+xfs_trans_ijoin()
so maybe I am not understanding how this work, but it seems
to be changing logic as well.

Please say something about this in commit message.

Thanks,
Amir.
