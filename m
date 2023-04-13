Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E354C77B71
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 07:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjDMHk4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 03:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjDMHkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 03:40:55 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA8A7DB0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:40:42 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id xi5so35134257ejb.13
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 00:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1681371641; x=1683963641;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7T7q7sdsDEBhtepgNI0ki2glnFFLKVYBB69jyV022y8=;
        b=hmUSCKdcDl1A1sQPr36Fu1rWnStt7OexlljdywUqMv67o/3lbAXoDlgMwsngJjYhXN
         wfa84/hZ1KS4bBbPZCOAXgCkflTyq1WmKILRcSAT7vdqML+gG9mhRLEbF1CBTqI8xxTj
         Row8yT/PAoDa/BEjOFGQQXwGxx2pLCgJkRA18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681371641; x=1683963641;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7T7q7sdsDEBhtepgNI0ki2glnFFLKVYBB69jyV022y8=;
        b=QVXuUXHqjURNcWo8stqfCH5by+lDIU7BIABfMcUuQZdcckBYeXvVfY8ABs9yCuHsuV
         45K119Z99pc34RwiCAWC0YLOIWslNhLnvNaUo0bZq6RbIy6/6zrDY6lHqsp4jQwiWEVj
         ArxyvLqcfxLQQ4xoyV+jQX3pWhwNT1R8Aa8nrV5thPOXWtnvcGmgKWxkv7qToB41Jc0L
         ep7IytzHM/8HPSnnX7icJydXmw6tAtVflPbFIKI480MDhb8p3xcTpRdPwTAXk5GmejRT
         Ji+/PxzKVv+Ni2lXJj6HFGL+86L4uFhNX7bVXKDa2OnwrK+uiDMGHRMq+pnIt9mLQlva
         cUnw==
X-Gm-Message-State: AAQBX9dluklrnjrTTBgX2tBh3k5dm0olWNfUeXU9IW3g+zSFUaBECf1R
        by6SbvYaUwj2RTsvzx29s+O7KiTmmtO39nCD/lLoZQ==
X-Google-Smtp-Source: AKy350Y9/4S1aq5Wx7x5Sc4KVMyqW3XZKu315mG26h6vL+enjQLM5m7RJvF1SSTExWJj2J8FXSXEON931HqF2A41zvk=
X-Received: by 2002:a17:906:d20a:b0:94e:1014:3114 with SMTP id
 w10-20020a170906d20a00b0094e10143114mr752608ejz.14.1681371641053; Thu, 13 Apr
 2023 00:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230307172015.54911-2-axboe@kernel.dk> <20230412134057.381941-1-bschubert@ddn.com>
In-Reply-To: <20230412134057.381941-1-bschubert@ddn.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 13 Apr 2023 09:40:29 +0200
Message-ID: <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
To:     Bernd Schubert <bschubert@ddn.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, dsingh@ddn.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 12 Apr 2023 at 15:42, Bernd Schubert <bschubert@ddn.com> wrote:
>
> Miklos, Jens,
>
> could we please also set this flag for fuse?
>
>
> Thanks,
> Bernd
>
>
> fuse: Set FMODE_DIO_PARALLEL_WRITE flag
>
> From: Bernd Schubert <bschubert@ddn.com>
>
> Fuse can also do parallel DIO writes, if userspace has enabled it.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/file.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 875314ee6f59..46e7f1196fd1 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -215,6 +215,9 @@ void fuse_finish_open(struct inode *inode, struct file *file)
>         }
>         if ((file->f_mode & FMODE_WRITE) && fc->writeback_cache)
>                 fuse_link_write_file(file);
> +
> +       if (ff->open_flags & FOPEN_PARALLEL_DIRECT_WRITES)
> +               file->f_mode |= FMODE_DIO_PARALLEL_WRITE;

fuse_direct_write_iter():

bool exclusive_lock =
    !(ff->open_flags & FOPEN_PARALLEL_DIRECT_WRITES) ||
    iocb->ki_flags & IOCB_APPEND ||
    fuse_direct_write_extending_i_size(iocb, from);

If the write is size extending, then it will take the lock exclusive.
OTOH, I guess that it would be unusual for lots of  size extending
writes to be done in parallel.

What would be the effect of giving the  FMODE_DIO_PARALLEL_WRITE hint
and then still serializing the writes?

Thanks,
Miklos
