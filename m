Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACE8C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 21:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjARVXW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjARVXV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 16:23:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82085D11C
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 13:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674076954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2gxfKpkvolSDTmP8G9AtlA39SHe7LBRoCBVnTv14nW0=;
        b=ah6JwAj83iZRoCa3GX6Tv5aPJ3n52ALtNz4hSkyc+K9kutVQtJ6V44hKx4b4HQuvabzACx
        x4ZrCLaTwflDMjwT9OBh51qB3DlnJle1noxOZDMJl+RBK5Ull6h7KRbpHr8et/rXr1S8Ft
        VF6STgeLEmtK7CX5sGEP2lvARIlwdaE=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-J8n67jBhOTOVjcRpGSUDyA-1; Wed, 18 Jan 2023 16:22:33 -0500
X-MC-Unique: J8n67jBhOTOVjcRpGSUDyA-1
Received: by mail-pg1-f199.google.com with SMTP id q130-20020a632a88000000b004a03cfb3ac6so15894305pgq.6
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 13:22:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2gxfKpkvolSDTmP8G9AtlA39SHe7LBRoCBVnTv14nW0=;
        b=mefk0H9dnHsqy2aUfWvuMHsxBi211YUhBnkPTAh+nPw6CJMig3yWs5c7rMmX4fwGFs
         SUxcoG4kzpFloBBU5J+inFZOuN6BQoA3mm0RpdISYhUZjhEd/YYJiThVF3dutAfR5/kN
         IWB7r8lmp5oFVqpLaiU8Ky4qnI+NjdqcgFnP9DgdXv4ICKdYB67Lr3FpYPWvM7XUVDc8
         4HEzxlHjxxHxtGKgmXGNtPibrZczn/+rb9TNXxRg/3fL+zyUpL6VHYO6Gz845sONkNkJ
         Zf9OAF7oKvRbqG+2rQNqAX/grAaoa/ia57ChBVqyDhQoz3YY1lmT4YH1NWGOOYduhRI7
         WcUw==
X-Gm-Message-State: AFqh2komErf9wY5cXHXagbl/IYWZO4DLe6DQQOFdXVxWV/NQcVQNBn+h
        YjhGm2f8LoS8K/NHQfisb3z4oUWN/wtCLgdcdO4P4zPa+o43HE+Wzgpva8LZxBgQq1sYOK0g4g1
        71KhMJW0Beoh76DxqB9DMR5AoiTjw002F0iO+
X-Received: by 2002:a62:be13:0:b0:58d:b201:84b1 with SMTP id l19-20020a62be13000000b0058db20184b1mr861999pff.41.1674076952270;
        Wed, 18 Jan 2023 13:22:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtLcKVZ6bDykccsj+jnOo2F/dATqdhlnEqdG92C+vaBhHS3utB3cqQ2gbTqHp/mB4oUwt5eRGaT1myO3ALRKTw=
X-Received: by 2002:a62:be13:0:b0:58d:b201:84b1 with SMTP id
 l19-20020a62be13000000b0058db20184b1mr861990pff.41.1674076952001; Wed, 18 Jan
 2023 13:22:32 -0800 (PST)
MIME-Version: 1.0
References: <20220719041311.709250-1-hch@lst.de> <20220719041311.709250-2-hch@lst.de>
In-Reply-To: <20220719041311.709250-2-hch@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 18 Jan 2023 22:22:20 +0100
Message-ID: <CAHc6FU5A71L0r2k5z7QoBZe3pO+5G1nMNvKfGmJzprQWFyDCog@mail.gmail.com>
Subject: Re: [PATCH 1/4] gfs2: stop using generic_writepages in gfs2_ail1_start_one
To:     Christoph Hellwig <hch@lst.de>
Cc:     Bob Peterson <rpeterso@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

On Tue, Jul 19, 2022 at 7:07 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Use filemap_fdatawrite_wbc instead of generic_writepages in
> gfs2_ail1_start_one so that the functin can also cope with address_space
> operations that only implement ->writepages and to properly account
> for cgroup writeback.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/gfs2/log.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> index f0ee3ff6f9a87..a66e3b1f6d178 100644
> --- a/fs/gfs2/log.c
> +++ b/fs/gfs2/log.c
> @@ -131,7 +131,7 @@ __acquires(&sdp->sd_ail_lock)
>                 if (!mapping)
>                         continue;
>                 spin_unlock(&sdp->sd_ail_lock);
> -               ret = generic_writepages(mapping, wbc);
> +               ret = filemap_fdatawrite_wbc(mapping, wbc);

this patch unfortunately breaks journaled data inodes.

We're in function gfs2_ail1_start_one() here, which is usually called
via gfs2_log_flush() -> empty_ail1_list() -> gfs2_ail1_start() ->
gfs2_ail1_flush() -> gfs2_ail1_start_one(), and we're going through
the list of buffer heads in the transaction to be flushed. We used to
submit each dirty buffer for I/O individually, but since commit
5ac048bb7ea6 ("GFS2: Use filemap_fdatawrite() to write back the AIL"),
we're submitting all the dirty pages in the metadata address space
this buffer head belongs to. That's slightly bizarre, but it happens
to catch exactly the same buffer heads that are in the transaction, so
we end up with the same result. From what I'm being told, this was
done as a performance optimization -- but nobody actually knows the
details anymore.

The above change means that instead of calling generic_writepages(),
we end up calling filemap_fdatawrite_wbc() -> do_writepages() ->
mapping->a_ops->writepages(). But that's something completely
different; the writepages address space operation operates is outward
facing, while we really only want to write out the dirty buffers /
pages in the underlying address space. In case of journaled data
inodes, gfs2_jdata_writepages() actually ends up trying to create a
filesystem transaction, which immediately hangs because we're in the
middle of a log flush.

So I'm tempted to revert the following two of your commits; luckily
that's independent from the iomap_writepage() removal:

  d3d71901b1ea ("gfs2: remove ->writepage")
  b2b0a5e97855 ("gfs2: stop using generic_writepages in gfs2_ail1_start_one")

I think we could go through iomap_writepages() instead of
generic_writepages() here as well,  but that's for another day.

As far as cgroup writeback goes, this is journal I/O and I don't have
the faintest idea how the accounting for that is even supposed to
work.

>                 if (need_resched()) {
>                         blk_finish_plug(plug);
>                         cond_resched();
> @@ -222,8 +222,7 @@ void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
>         spin_unlock(&sdp->sd_ail_lock);
>         blk_finish_plug(&plug);
>         if (ret) {
> -               gfs2_lm(sdp, "gfs2_ail1_start_one (generic_writepages) "
> -                       "returned: %d\n", ret);
> +               gfs2_lm(sdp, "gfs2_ail1_start_one returned: %d\n", ret);
>                 gfs2_withdraw(sdp);
>         }
>         trace_gfs2_ail_flush(sdp, wbc, 0);
> --
> 2.30.2
>

Thanks,
Andreas

