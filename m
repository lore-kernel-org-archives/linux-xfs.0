Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5363FC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 03:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB2461A2A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 03:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhCZDdO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 23:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhCZDco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 23:32:44 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC915C06174A;
        Thu, 25 Mar 2021 20:32:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id i22so3703597pgl.4;
        Thu, 25 Mar 2021 20:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=LBmsrsdz7s7PIOeZHx9CXt+hZEjOqvNhF34JU21GDLA=;
        b=VsvdQnmtCxgP2V2rjvhTVVSvN8dSsunZIBCrjMW7R9nUhFWPBVb5yt8nin285olQ34
         BXiFaQn/vRW4uJJ0KPNg4sc23ZmPU5bz0QTavOrSxRJugusK71C7iS72tr4Knc30mfSk
         jhqlzo3x30iaFa23voh8KLl0xDa265cFVyxBUnCIcEB6DbSwt/470HldjeJ+xe/N8M/a
         9+2NM1kM8yqRg5s5kQKftl1Dw5ulnHpE1DBKJmLxKvj/e7dCUTxZ9zdKUWXUVfwJ45IO
         va4JN53oJ3qhhPEtdJsfFlaXBfenZyhvi9cnpGDI1LO94LWk4zas/KI/96VI5AG5ejME
         Xh7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=LBmsrsdz7s7PIOeZHx9CXt+hZEjOqvNhF34JU21GDLA=;
        b=JD7thUPr5Dhr12x4ZY4IlZF8mFkL7rOIGWruYruR1YiMl0aFcOraG2rx7OjRBGhmpF
         DCVpl/OxpQOGEdR50pahHc5gaVCQO3L+1Iu/fWkGo4vzt5ksWq4e2DhJ5SS4Ij2bsRjm
         u0k4P8wufWHOf5gf/FFxCYo49WDT5nHzPJa61YEMfcqX/QNEuBqePmxS9yQaosIu5PcX
         EOgbYpyof0xcJAvhp287ecLk+WnBOxeaxFlA0/D90l4Hsmq1IPS8A73CqWgVtkQDSxp3
         ZBrx0OVuXCYlOQpsRy2d6WsG6K7mM5E+ZTQeyU24LFAOvB/LARnGULI3yqX+63Fo6PVH
         Tmew==
X-Gm-Message-State: AOAM530A8Pu+4mL+/mUGG7wHIGnG/5ntqmVygTUwwdCFFbJS5ao02fA4
        Mw77T57W/tPHUJ41HjwuG/4=
X-Google-Smtp-Source: ABdhPJwC/uT2Yy9gSWzW8fACHlxQt4SzQGcSxCK88MwxVOVfe9ksrNtOltaeL1xbPHENxOL3A/9RuA==
X-Received: by 2002:a62:6546:0:b029:21f:4bea:3918 with SMTP id z67-20020a6265460000b029021f4bea3918mr10157667pfb.47.1616729563509;
        Thu, 25 Mar 2021 20:32:43 -0700 (PDT)
Received: from garuda ([122.179.126.69])
        by smtp.gmail.com with ESMTPSA id w37sm6933263pgl.13.2021.03.25.20.32.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 20:32:43 -0700 (PDT)
References: <161647321880.3430916.13415014495565709258.stgit@magnolia> <161647322983.3430916.9402200604814364098.stgit@magnolia> <20210325163625.GI4090233@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH v1.1 2/2] xfs: test the xfs_db ls command
In-reply-to: <20210325163625.GI4090233@magnolia>
Date:   Fri, 26 Mar 2021 09:02:39 +0530
Message-ID: <874kgyr3mw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2021 at 22:06, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Make sure that the xfs_db ls command works the way the author thinks it
> does.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

-- 
chandan
