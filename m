Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA53C77B7F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 07:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjEQHIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 03:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjEQHIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 03:08:09 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD644213D
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 00:08:07 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id ada2fe7eead31-43469a7946eso103305137.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 00:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684307287; x=1686899287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2g7FgDahyPlyrzbzUVaR1hD/iRYtqlpTn/14cgQhb8M=;
        b=ZnJxmMjL3lpGiWd5uFH7qSxVYlc3zhdn1Hyl7cBEhTQRfPv1KOEFHDjIKkokKboX0q
         WHJBMfWVtPCDsZzhpeWRpsYPBDGXli0mYRpfvDAtUd2eK3kFWcl9KSK743rIUFZ2v3Oc
         q8NP7Icybmec4TDta9ybGQH/0FnztNUXOKSGKraJAfZ1xjE4ccW0P8u4wie/8pC7c0EZ
         5RV0GzLUojoromA3w3FjWrIvWHGRqx0mBB7fvu4dBeSBVxLtClpV6ZpzrAzdT5LRaNuH
         zGzdYpXHcLff5Xos6pCAx7qTAan09zaQWTLm9oy/1C+J/g8vNbk1XC2p1xi98dO9uaii
         KJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684307287; x=1686899287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2g7FgDahyPlyrzbzUVaR1hD/iRYtqlpTn/14cgQhb8M=;
        b=giH1nDOIXjoLknEttt+PVGXF/o5hXiJoVeRerf6HVKZXqhZy98kDnnpFcvnzkI+8e+
         5LyThJdVmFQEWMw2OyQnvcD327cvaiMz5D4ni8j8GjCZjNHBFpgFSBue1pJGSwavCoql
         35I21Td6zQ4j8O5eCoz75FVzA/fLrYpk5oohvf3UFjQMnnSQvsx2ZEZEO37jNuZanE9V
         SA0gP2XhCs4xo4wcn7CmLo1Pl4hyjBtRsP67onMIBtr+jpMKnbmQSfKLH1q5xu1svefk
         4w1BhDrYbA93rqDEWU4LCTfEpb5eA73sH/vy5jAzGcmfzMkoP8IaZAat6PbZ1rAFp5ba
         5tdw==
X-Gm-Message-State: AC+VfDyjJLgXiZGheXYV4KIipmWZ6LMWgZOWFjYbmqoR4lgnxuoyDrgV
        7K8LWetq5vyctlAPe/TR++c74FM4bw43mpE/2uA=
X-Google-Smtp-Source: ACHHUZ5BGvSDuO5dOpStotBXCJCWo6jnthxV+p8BYHYhPiDmTCkk/zA6pm2S7QzQIp8gJpmZdPyHx3uwkIe4Iu8wH3U=
X-Received: by 2002:a05:6102:2457:b0:436:52e1:40dc with SMTP id
 g23-20020a056102245700b0043652e140dcmr5032942vss.14.1684307286780; Wed, 17
 May 2023 00:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230517000449.3997582-1-david@fromorbit.com>
In-Reply-To: <20230517000449.3997582-1-david@fromorbit.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 17 May 2023 10:07:55 +0300
Message-ID: <CAOQ4uxiJ-sYPpGcPpVzz0hScUNdZ4bs8=GUsncNOXdeEAOCaCQ@mail.gmail.com>
Subject: Re: xfs: bug fixes for 6.4-rcX
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <lrumancik@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 3:08=E2=80=AFAM Dave Chinner <david@fromorbit.com> =
wrote:
>
> Hi folks,
>

Hi Dave,

> The following patches are fixes for recently discovered problems.
> I'd like to consider them all for a 6.4-rc merge, though really only
> patch 2 is a necessary recent regression fix.
>
> The first patch addresses a long standing buffer UAF during shutdown
> situations, where shutdown log item completions can race with CIL
> abort and iclog log item completions.
>

Can you tell roughly how far back this UAF bug goes
or is it long standing enough to be treated as "forever"?

> The second patch addresses a small performance regression from the
> 6.3 allocator rewrite which is also a potential AGF-AGF deadlock
> vector as it allows out-of-order locking.
>
> The third patch is a change needed by patch 4, which I split out for
> clarity. By itself it does nothing.
>
> The fourth patch is a fix for a AGI->AGF->inode cluster buffer lock
> ordering deadlock. This was introduced when we started pinning inode
> cluster buffers in xfs_trans_log_inode() in 5.8 to fix long-standing
> inode reclaim blocking issues, but I've only seen it in the wild
> once on a system making heavy use of OVL and hence O_TMPFILE based
> operations.
>

Thank you for providing Fixes and this summary with backporing hints :)

Amir.
