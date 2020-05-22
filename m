Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526A4C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21D6E20757
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 07:56:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n4SdgYaT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgEVH4n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 03:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgEVH4n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 03:56:43 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1861EC061A0E
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:56:43 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d7so10448082ioq.5
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 00:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JOuWxBk/W/aLJ9PoVph/5ZnGlQ5FxBKYQToGueZo9TA=;
        b=n4SdgYaT80FX6otJU5JJ39FVYimMq62kfsMTyJBLLNgI9oegx3xHPw8mlUfwudwSk8
         rnjTb+JCCaOIs3WCusvj7Qj5+9GSOdeEi36MTtEKbJupOYFFsXI7XmvlgkxWFnbU4HBY
         jS5OGRO307lAsYgDvd6iwxt9ycL2bz061YcR2BFkZRxQ+aAVzZ2UXJaIZy2OioMm8v2X
         m59lMiHn0D6VZxw+Nwypa9s8QqvbSkLEgfvqfYK0ws0o9OeDGv6jMVkttGHCPzEhhTTM
         wYQ7RQni+Ab7yZPNZa75gIwy5OTfCSAP0u+zzqghJiJMTKFrU6C8pWSB0izdiFOZEV9Z
         y/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JOuWxBk/W/aLJ9PoVph/5ZnGlQ5FxBKYQToGueZo9TA=;
        b=qAV++4EqP7h/BCiyM+j5aUdO0gwH8QORijnw/niRSCazYUeOE8ueKDHV3ALzfPUWN6
         yFEqw4svSgoA7UcVdT/Neix/7RJccwW62yv/V/XNIVi76DbR+9GPeLNL71IWifen6po7
         JyPD6AC9OMPippelmD0kv2YUr5o2vuEiOkEjjpnhFO18ovy2Tx2uFjXQ8A2MqP4iCxtn
         WjI3es6EYX6jwsy9ELWix9f3Hj8t8Z+aZzwicLP4PAsxkVVQ6+h0oH8YipImfUHJVIa5
         RMN8gqcIEZ7HXSIQbY5+qEfhRP5t1PX4tAS26CMeKqdlo74c8hVXZpT3+Tsph+vUqi8i
         UZ3w==
X-Gm-Message-State: AOAM532oGYlyw7qqMEfrhBY/Oc5ohu4tgb3e/p49MLlnGXDW2VjszxHl
        LbVdIypk9vP7tDHn8G9QSeTt87JbXONnHYQYnpkr6RMI
X-Google-Smtp-Source: ABdhPJyy+eC+X3O71tpb3amICaT4ZawFD/CKCQG/PfSgdWRySH24EYGdpFL7PkW+XBwHag24gorJoFLdtNMFEpJwYsU=
X-Received: by 2002:a05:6602:4a:: with SMTP id z10mr2096318ioz.186.1590134202528;
 Fri, 22 May 2020 00:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200522035029.3022405-1-david@fromorbit.com> <20200522035029.3022405-7-david@fromorbit.com>
In-Reply-To: <20200522035029.3022405-7-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 22 May 2020 10:56:31 +0300
Message-ID: <CAOQ4uxgFDiomtFOEQ3wTtFmJ4g31QX257otbuaQztgksweBeEw@mail.gmail.com>
Subject: Re: [PATCH 06/24] xfs: call xfs_buf_iodone directly
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 6:51 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> All unmarked dirty buffers should be in the AIL and have log items
> attached to them. Hence when they are written, we will run a
> callback to remove the item from the AIL if appropriate. Now that
> we've handled inode and dquot buffers, all remaining calls are to
> xfs_buf_iodone() and so we can hard code this rather than use an
> indirect call.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
[...]

>  /*
> - * Inode buffer iodone callback function.
> + * Dquot buffer iodone callback function.
>   */
>  void
> -xfs_buf_inode_iodone(
> +xfs_buf_dquot_iodone(
>         struct xfs_buf          *bp)
>  {
>         xfs_buf_run_callbacks(bp);
> @@ -1211,10 +1191,10 @@ xfs_buf_inode_iodone(
>  }
>
>  /*
> - * Dquot buffer iodone callback function.
> + * Dirty buffer iodone callback function.
>   */
>  void
> -xfs_buf_dquot_iodone(
> +xfs_buf_dirty_iodone(

Nice cleanup!
Minor nit - if you added the new helper at the location where old helper
was removed, it would have avoided this strange looking diff.

For not changing logic by rearranging code:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
