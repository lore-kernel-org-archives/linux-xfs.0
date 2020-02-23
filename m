Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B279C35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D447206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 13:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cd51DyVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWNFJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 08:05:09 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39913 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgBWNFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 08:05:09 -0500
Received: by mail-io1-f66.google.com with SMTP id c16so7457450ioh.6
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 05:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TG6bYuwEB/i0ftXgrMRHIAGHjfWFUuFSj4zWuC9QFZQ=;
        b=cd51DyVkLtGND9s5c0iSa4ASZ8WrmyWlWezBiQLTO8FU8HiMD8bPLFoaa99rFt1as3
         P+QRWLZ41UxEN3Gf95+qUyZsLOE+54o31yzYlNFN/6zbuD5QX0XXmdi43ktthjZ875U0
         6RRRmiXhNebHjBarnRNyxAMPzKdzbkOC8OM813rS2ht4fa81yMOSN+p2aaWAVnazuPa2
         RPwehNQyA6MoNbm6TsCrc7aFSzeSEawMr+JNFMQ+4Lm0GHJRzxi+h41pIS19iaU61+S4
         1aJDYlGQ90gC0GZIahjmW7PHAHQOeJ3tPS3fIBGoAuV2/wmpywf9iExUfNgYsTSKd1lo
         fkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TG6bYuwEB/i0ftXgrMRHIAGHjfWFUuFSj4zWuC9QFZQ=;
        b=pEB0gwjh0yBYuoqnc2TTOkltL0sK+8wiszHrHd/MbZ1Kfh078wZBpdwBtrYYbPGJ0F
         cdxXWFjeF+lIgmeqYyug8oLsFqzlb0WcdjZRC1RXGKNhmzVD3wCV66WrGOOHTTzASlH6
         mArhGsWnU7hLqhzT9HRS4p+Dvdrkkza+jfunbcdAHHDFJlhXS2WEN85YTNyelIwvEhaY
         /xwv7M8AGT3qW2jMOIEYEKyvs4UELK5inoU9D4cIelJzH+n1wrrTPp5QEcrpSP1MT5PV
         d/zT1pqbE0uMKH0M1Mci1xDiXq3ZA3cxRf4WQLQp16I2e4bziUv1B819H6QgixezME+S
         SLvA==
X-Gm-Message-State: APjAAAVVb6EngSYNFSadVoVqqe3osGN96RDLsjcq1c7la1rKwrrg7MlK
        cTMhZOaAwzlV1rpKKY/nl05K/p71R8MGtyyOk4Y=
X-Google-Smtp-Source: APXvYqyxfyrCxcwi+Ieu+OS8aSc5QRAkXLfwAmKgGOOmtJRWAB8lv+kktwO5POK4oiVEo/Em8wfuFT5UgJcsUEL9w/s=
X-Received: by 2002:a02:8817:: with SMTP id r23mr44554265jai.120.1582463108751;
 Sun, 23 Feb 2020 05:05:08 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-9-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-9-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 15:04:57 +0200
Message-ID: <CAOQ4uxiUHG+PihrP3FXJA_AV-oQ63HG8jrtUg8nMCB3vbhXtRA@mail.gmail.com>
Subject: Re: [PATCH v7 08/19] xfs: Refactor xfs_attr_try_sf_addname
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
<allison.henderson@oracle.com> wrote:
>
> To help pre-simplify xfs_attr_set_args, we need to hoist transacation handling up,

typo: transacation


> while modularizing the adjacent code down into helpers. In this patch, hoist the
> commit in xfs_attr_try_sf_addname up into the calling function, and also pull the
> attr list creation down.
>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

And I don't think the subject (Refactoring) is a reliable description
of this change,
but if nobody else cares, I don't mind what you call it.

As far as not changing logic, you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


Thanks,
Amir.
