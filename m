Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422FFC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232CE2078B
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 10:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A4qSnKhV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHRKvw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 06:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRKvs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 06:51:48 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F116C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 03:51:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q75so20773467iod.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 03:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8kaC3MMyjWVO/sW8zKNABAuRcUorNMXcMqii/IZ4a8c=;
        b=A4qSnKhVMQtTnx6pzwTl1GbzrPpDlzuJozhti2x1OXwVn9k8YIYGDLYzMx5T29wqVp
         qq1tYeajVVHRzx/O0fPxsgdTlSpgOw4HBf6NMF5vF+3YrT8pldwUkPZadVDY3Vm3FFXi
         Cc86NHXXcgbhrN2VyAJtw8ohV5m+FPX7cvNiAf4j7eK56hA4GuzeZ9yx6GwHmos9zbo2
         nKsHpd74Tle1kAEK4pfQzYsmmvQ2Epw1Qcl1vu9K7LcXH8JQ7f6tdxRLWyH+MApsk8gA
         qYU5OC6+MW/W0qAvd0/u9atOft/tooX7pXul6t1xEKmzB1xpU8i4yPgUroCMyoqVqIAP
         Y25A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8kaC3MMyjWVO/sW8zKNABAuRcUorNMXcMqii/IZ4a8c=;
        b=Je2Z5ZZyUueuERCZSdm8uSDBEOjZHwbNa4EFj/usxDj3JthST2sRPJgpMSsehAEpzx
         +gADpIcr2on6opqtDzRzv3w31WYtAyDum3AkmLIeo7sJChXQ6J6wJb0A/EnpQ99lB6YS
         hiKjQg/NH9KdQEt2sIb/5JdIy91d6HvZkPkteq3IB8N9WI3dKnCAheDT42+QWOGdjZ6P
         l8pwPLNR/zC+7QZIF0iM7bockNkWy+9mMDzwwUAstXQeh5sm5YUwQjIP+WnwQ+nTgOda
         nWdfsYTbY93h5VmO6izvddP3umrvjMEPFSyd74Cr5Z93vD15lB124/5451Fc97+FyPYH
         rOmw==
X-Gm-Message-State: AOAM533Jp8olTdobdMUajOA09PgrmoIQ7gW3duLCgxqZuKfYyyzeqCdC
        bVpcOqdqRHj2XHsOPq/JClfmR958C9+MzaMBCvyXuQHG5yU=
X-Google-Smtp-Source: ABdhPJxWtFE5baL4I5FvEemjsEUw6CqZqUsJKjKA4odiCH4HU9w3gX0xRbIWokkNKAQ+wUwnngtxzu9ATsRzjoKk/Y0=
X-Received: by 2002:a6b:5d0a:: with SMTP id r10mr15913053iob.186.1597747906559;
 Tue, 18 Aug 2020 03:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770503952.3956827.2088625885596961750.stgit@magnolia>
In-Reply-To: <159770503952.3956827.2088625885596961750.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 13:51:35 +0300
Message-ID: <CAOQ4uxhHJSGnFGLpdULuDbEkh046jEsYoiFg4SYaoHRS78ySgA@mail.gmail.com>
Subject: Re: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log code
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Move this function to xfs_inode_item.c to match the encoding function
> that's already there.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok.
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
