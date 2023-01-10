Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AA0C54EBE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Jan 2023 12:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjAJM0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Jan 2023 07:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238535AbjAJMZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2023 07:25:18 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D4847307
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2023 04:24:53 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1322d768ba7so11938007fac.5
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2023 04:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lvl9Gp5Ngw+k8127momR/FzRBXgKGVF61Q5fLWGt8as=;
        b=dWjBay9d2OO764Jm1SaP9NUI+QPsLnrMVZTGqB8EbfYQ169TCr9ZUPoNNa/JVZAXky
         zY4R4gY44lWIhkQaLoDDVY2oOFgu4+X4skL3qyTrpJNnAw3T2meXoIGSJzl2VIbLtagK
         6OMgJzqFAQqg/yafX9N7KpFjSL7vtQnIVkf1mvXIncfFwxOYDj9gf1b0QRu9gVeId8ru
         B43h6Y5JfPrRg0BSvxypbe/Cm+DHBsQMTPt8zlj16r5et1VNIVP+4ox1bEXKmtoUX1h1
         uohY4lo0NYht8k1Q/3Lwq1JRfMLyInF9yk6y+1+WTOmoxhmp4vO2H2ChN94uUWgbCXII
         dBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lvl9Gp5Ngw+k8127momR/FzRBXgKGVF61Q5fLWGt8as=;
        b=2/8Nm+eneVZJdQJApW0T4+Vv6AUdXli/RdmuSpOzM2h6SUoX5oylbzu/ihtogs4PQ5
         F/cte6GPrNPFaey/1uexX78Z3sFU2/Jk6mboytwqqAjQ6jbqfkfKJ8Earg7oNzPHCAOG
         lV2IyTi6cztnCgSdqtchAQtp3C1azzqyQCwDUmmIa6nIBdv/dKzuJj09U3QVF4no4qN1
         BSjUyZQ+cSH27O9VOyvtmkNaz+9P/TxJ7oh+pHVN8XEOtAQ9BFa6eArTFnLn/pp/BKQt
         ONI437C81lvbMYtlKWGSkz6N+ZrFE+kAWcUBNrWVW+WPQ5kQKFZ9MYHt1t6f2UD71jgM
         DL6A==
X-Gm-Message-State: AFqh2kog1+ggS6C8uBk6VaN7igNGdZqQNgTfWKr6sernMmrHlCcUzjH1
        YMReeNhcGLYhTJGGYVkh//yDQmAmviEv07H/fD4=
X-Google-Smtp-Source: AMrXdXsZD4nsMfbHJvqQ9gbuAHk0HiwIXp9bH3ed5OLRl6dW89QwPibH5iADeKt+Zn4sHPU3E2bhOedriMURgbzp0Yk=
X-Received: by 2002:a05:6870:9d05:b0:14f:e7f3:4ccc with SMTP id
 pp5-20020a0568709d0500b0014fe7f34cccmr4211915oab.261.1673353492565; Tue, 10
 Jan 2023 04:24:52 -0800 (PST)
MIME-Version: 1.0
From:   Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Date:   Tue, 10 Jan 2023 20:24:41 +0800
Message-ID: <CALg51MN+crXt0KcsLOAUF6feGa1q5SJ+bPDy=-SsfQD45nKuMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
To:     chandanrlinux@gmail.com, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/17/21 12:48, Chandan Babu R wrote:

>>>
>>> Just because we currently do a blocking flush doesn't mean we always
>>> must do a blocking flush....
>>
>> I will try to work out a solution.
>
> I believe the following should be taken into consideration to design an
> "optimistic flush delay" based solution,
> 1. Time consumed to perform a discard operation on a filesystem's block.
> 2. The size of extents that are being discarded.
> 3. Number of discard operation requests contained in a bio.
>
> AFAICT, The combinations resulting from the above make it impossible to
> calculate a time delay during which sufficient number of busy extents are
> guaranteed to have been freed so as to fill up the AGFL to the required
> levels. In other words, sufficent number of busy extents may not have been
> discarded even after the optimistic delay interval elapses.
>
> The other solution that I had thought about was to introduce a new flag for
> the second argument of xfs_log_force(). The new flag will cause
> xlog_state_do_iclog_callbacks() to wait on completion of all of the CIL ctxs
> associated with the iclog that xfs_log_force() would be waiting on. Hence, a
> call to xfs_log_force(mp, NEW_SYNC_FLAG) will return only after all the busy
> extents associated with the iclog are discarded.
>
> However, this method is also flawed as described below.
>
> ----------------------------------------------------------
>   Task A                        Task B
> ----------------------------------------------------------
>   Submit a filled up iclog
>   for write operation
>   (Assume that the iclog
>   has non-zero number of CIL
>   ctxs associated with it).
>   On completion of iclog write
>   operation, discard requests
>   for busy extents are issued.
>
>   Write log records (including
>   commit record) into another
>   iclog.
>
>                                 A task which is trying
>                                 to fill AGFL will now
>                                 invoke xfs_log_force()
>                                 with the new sync
>                                 flag.
>                                 Submit the 2nd iclog which
>                                 was partially filled by
>                                 Task A.
>                                 If there are no
>                                 discard requests
>                                 associated this iclog,
>                                 xfs_log_force() will
>                                 return. As the discard
>                                 requests associated with
>                                 the first iclog are yet
>                                 to be completed,
>                                 we end up incorrectly
>                                 concluding that
>                                 all busy extents
>                                 have been processed.
> ----------------------------------------------------------
>
> The inconsistency indicated above could also occur when discard requests
> issued against second iclog get processed before discard requests associated
> with the first iclog.
>
> XFS_EXTENT_BUSY_IN_TRANS flag based solution is the only method that I can
> think of that can solve this problem correctly. However I do agree with your
> earlier observation that we should not flush busy extents unless we have
> checked for presence of free extents in the btree records present on the left
> side of the btree cursor.
>

Hi Chandan,

Thanks for your great work. Do you have any update on these patches?

We met the same issue on the 4.19 kernel, I am not sure if the work has already
been merged in the upstream kernel.
