Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A151C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 762A2207DA
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p2/3+Owa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgHROb3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgHROb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:31:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B5AC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:31:28 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id v6so21254380iow.11
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yHnZfQoCtp0ouCz4b4UlANci0rGBcrdxc40bnPr68gc=;
        b=p2/3+Owa3UsbQXR/YUCFae/tXE6x7GKDqqpKuyeyxBxtlnXRVwHKANcVJdYecRLHqK
         R8eSLHWXXQsR36St20THW260ZX053vLa4iYnDOJ3OT4ycDdf6PM7a5XlSYHJYlYc28MC
         5/VbwDDVRilsC2X3gXAGpYWaimgO4IRRRCfM0DddBbc4qCPjRwc9jz5euPHLpJHSViQJ
         b61FNim7bf1n8Fz7b/WmMmDppmNymr6wU7NZyLks8z0WOTn8Q2LZoA5mI9p4ZFN/LN30
         muCFnkU3QpnpJS+INThOhe9kQ+fi1Vl/coDD6k4kI9WrntfuE0HznH5EMMguvQKUfejL
         6cnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yHnZfQoCtp0ouCz4b4UlANci0rGBcrdxc40bnPr68gc=;
        b=CfYMDnk5MzVOX+pSct1HFK/JyY6iX3fJrGlN9dggSWWhHhHUkLlo0fw2UTNBtv38kz
         y3CEMgpeGrwK/Hib293XlaLQFWUq9uWTzS/bDRZRpdylqDM8f4DrVoywfY+D+DGtXzw2
         YXGORTjC7wqLA7OquTTXk8vUqdhwP3Nejrx+LpW3dkjrWsOeiU8o4RaCtXClL3V8Xkx0
         lY/xDuj/QHBJdBaa0gJrnhTc39j1zUdpiNVc/9Ss5ALnrGr3P7nXB1W3aOd+/z9DlXly
         2Sy5ClJRRhPIh11xR6TOFfoEFKPE/pXSujP4L1UiqpaFXlgtd7EsInzOu6SDoDWn1+Hv
         ZAeQ==
X-Gm-Message-State: AOAM5333J8bqMn2zOJxacQS5+nalTDnE/VOwVe93vbuP9Cy06mTQJfu8
        4hFg045WPfCKkmj+oV7T00BX2MeH7mKAPWwpX3k=
X-Google-Smtp-Source: ABdhPJzOF6kpHpi6vJkIti4TDmWP3GD2xbT4rAXv7/xcAqtvr3RuCiOOpWYa46MkLTUEugR5sKteHJiWX+JAJY5CU90=
X-Received: by 2002:a6b:7f07:: with SMTP id l7mr16310165ioq.203.1597761088007;
 Tue, 18 Aug 2020 07:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770519011.3958786.9102828204613614956.stgit@magnolia>
In-Reply-To: <159770519011.3958786.9102828204613614956.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:31:16 +0300
Message-ID: <CAOQ4uxikbjRDDz-Q=qqGJuVZHiVhzNw2dABi75o05BOUeCOfpQ@mail.gmail.com>
Subject: Re: [PATCH 09/18] libxfs: refactor NSEC_PER_SEC
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
> Clean up all the open-coded and duplicate definitions of time unit
> conversion factors.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
