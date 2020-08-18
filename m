Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B82C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE5620786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9jae/p8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHROYt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgHROYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:24:48 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5C8C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:24:48 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g13so7059694ioo.9
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ApWB6SO+fHBqDW+a9+fr3kMhM5PoSTDJeM+1/egP2dc=;
        b=E9jae/p8qhDKztXzrkDYbxHRXTlxYtVCcYdMXrmZkvkCPJkSs+rbaZu3wv1JDCYhh+
         tpA0feN+xRfzx/GiCa3YkUeygW8ZvCoIgE9xpD6NB03cG2c5cDzdtddqQs6aXgzoFQux
         3ZM1znfOvGlnlxVikPEQvnxXznT6ic/IC1hiKOQI/L0X77MXlCRVT4YsPaFrnPaNpVBj
         N36NkdcIJ5zhMC42PA0HEuWBV9UeT67cpvslDdbI7DVhPKVJ7mZR3CnZHKyKa9ZWV8pD
         y7NeR7GuBTc6fL42Ee8enyoZurhEZ3EWwtGc/8hUNO0DoTCbhzVaeRQzGyMEhMJrvqCD
         Wf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ApWB6SO+fHBqDW+a9+fr3kMhM5PoSTDJeM+1/egP2dc=;
        b=ecjebh+GCATcU+fjUNBSGXk99RomSzyGlaSLbLGcFrvtJPU+XtIjV751MZGUqZJUuK
         113Um7qbMkoGXJ6QYF+Y6q935CU32dYRJa97XnibVmFTm/JqYIatPS71cB+maJ0m5Z7o
         XOwKXb7n4m58ZTt4IwXRMrgpsYjRNMDiYX8O26dT/JHcqcfGpN+EfNIAiWEaDnsdhUdd
         svJsub0KpySqzvUo8OMlCl3mkkkUzE8ecDSM6dVALKxQOw14ggNvOD3aUsZfHrnj3JZr
         n1XcKbC/WjrQBnsDeanSv/+EkXvzpt7xTqM7wU9MRAvSbu7iFCB8ecX4uHmg7FaeA50v
         5pJA==
X-Gm-Message-State: AOAM5315qTGCKHN+S7ESe1sR+89fInBX4Ng4UXzHSeVmABnvkayyz6jE
        l7ULy2hKAjMlBZJOVX4krwqfv5c2zjvbu4LUrc0=
X-Google-Smtp-Source: ABdhPJyt9wZCRVVGoObUhr5kqGsU9JscK2vSRt9v0XDwmT/brCGv+kbcUd8p9vk7/x2IjcsM02swx1DBcDEH2JXjJA4=
X-Received: by 2002:a6b:7f07:: with SMTP id l7mr16289489ioq.203.1597760686651;
 Tue, 18 Aug 2020 07:24:46 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770516555.3958786.9705266272309911121.stgit@magnolia>
In-Reply-To: <159770516555.3958786.9705266272309911121.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:24:35 +0300
Message-ID: <CAOQ4uxjJPhQZCO_k=gDUs6kSmhToAmvQM7c1_v7+UJva_-6+=w@mail.gmail.com>
Subject: Re: [PATCH 05/18] xfs: remove xfs_timestamp_t
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Kill this old typedef.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
