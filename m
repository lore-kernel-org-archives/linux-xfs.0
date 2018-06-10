Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:45159 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753864AbeFJLVc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 07:21:32 -0400
Received: by mail-yb0-f193.google.com with SMTP id x6-v6so5795180ybl.12
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 04:21:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1528607272-11122-22-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com> <1528607272-11122-22-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 10 Jun 2018 14:21:31 +0300
Message-ID: <CAOQ4uxhwt2cMDqKe78LZvvmLpeB_FncrPQWx=H9Tr0sGtTEBKQ@mail.gmail.com>
Subject: Re: [PATCH v2 21/27] xfsprogs: Remove single byte array from struct parent
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 10, 2018 at 8:07 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> Variable sized arrays implemented this way may cause
> corruptions depending on how different compilers pack
> the structure.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  include/parent.h | 1 -
>  io/parent.c      | 9 ++++++---
>  2 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/include/parent.h b/include/parent.h
> index f338f96..85cef85 100644
> --- a/include/parent.h
> +++ b/include/parent.h
> @@ -22,7 +22,6 @@ typedef struct parent {
>         __u64   p_ino;
>         __u32   p_gen;
>         __u16   p_reclen;
> -       char    p_name[1];

How about
   char    p_name[0];

Is that also risky? keeps the code cleaner IMO.
Second best, at least have a macro to access p_name
instead of open coding ((char*)parent)+sizeof(struct parent))
all the time. First option is much better IMO.

Thanks,
Amir.
