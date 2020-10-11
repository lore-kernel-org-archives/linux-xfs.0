Return-Path: <SRS0=HmrU=DS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F14C43457
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Oct 2020 20:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717942145D
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Oct 2020 20:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="se4EGX91"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgJKUXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Oct 2020 16:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbgJKUXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Oct 2020 16:23:17 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618D4C0613D5
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 13:23:17 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id f10so13976398otb.6
        for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2020 13:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=tRceXdKhB8YrGa5UF3V+9BiDoHJDhSAujZzJPaxD6i8=;
        b=se4EGX91wXk2NZMva6HzFZt9bCZz8RMcBbrzoCXtUq3w7fZQ1NYTEx0+dle/di2F1+
         UMlSTWzAs2o5+wpceMyNbEGN2hTYHQpNNfyByKl5nEcsn66SyilMSjwsZ4cGPfkmBdYF
         yp6Nw97A01gYD5ub1/INhnhY970Z/HlYmbvK/LaNIIE3sBoaVVhmmclnwCCPgaULh6vY
         IxIhvUHsa77LoIoogl9eveMNpldGFUGa3mjyOxtKDwI1N8AyBQEUvYbZyS6WJk8fkRN4
         /evvAYdtKBs0YAniCPIKXpFnj29oVuIWyLaL/rGXSXn8Gch+kyM/AJyBMyFmUyuNfgxn
         vslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=tRceXdKhB8YrGa5UF3V+9BiDoHJDhSAujZzJPaxD6i8=;
        b=tTvgBwPaoPMPGNrbsU3ZakVbpqnl3nyNlmIA2Fw1SJDTrRVIPjRwD2P2Vs7V8flzFl
         +nEgzENtgQs+2sjsJU9pTQXYOOAWlZcdly1L2Pb9mmbGYkl7XV3gea+vQQQy0UZU87iq
         Qwtzzq6uLtmBxD04oGMDc0hB0WdYmWUjackWbUbt80Q83daRYj9zodIt+xtCignYjOEj
         yZTtvZAknVROAvoQX8eYsgPeLZ9EEC6pAviN4E0IkZ7FA+YRxcqfBvJPnp4k2rcKwNXO
         cJkcNwrQ5vE53Og8hyjgApCw5awDgVRTRRaQbOYt16h7eMbxcaP6vud2jLTiUwcvfZGs
         7YjA==
X-Gm-Message-State: AOAM530xFPzusCcJ2ErBMJWDnZp9tjIPLjP8fbMnTEP6iuHhseEklcOY
        Gs4ivTfUmWuUmRm0uDpZ+qJNpg==
X-Google-Smtp-Source: ABdhPJxJevS9phfHNPbujhgUz0c2zM32mOg8hpn2iOLSemBV/AGaC7PVIMJ1K7/V4AWK3zP1Bm9Msg==
X-Received: by 2002:a05:6830:149:: with SMTP id j9mr15110595otp.187.1602447796574;
        Sun, 11 Oct 2020 13:23:16 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id j34sm8210899otc.15.2020.10.11.13.23.14
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sun, 11 Oct 2020 13:23:15 -0700 (PDT)
Date:   Sun, 11 Oct 2020 13:23:12 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Qian Cai <cai@lca.pw>
cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, darrick.wong@oracle.com,
        kirill@shutemov.name, peterx@redhat.com,
        yang.shi@linux.alibaba.com, hch@lst.de,
        linux-kernel@vger.kernel.org, songliubraving@fb.com
Subject: Re: VM_BUG_ON_PAGE(page_to_pgoff(page) != offset) on s390
In-Reply-To: <20200617031906.GA5065@lca.pw>
Message-ID: <alpine.LSU.2.11.2010111321430.15963@eggly.anvils>
References: <20200616013309.GB815@lca.pw> <20200616014859.GY8681@bombadil.infradead.org> <20200617031906.GA5065@lca.pw>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adding a note to update this thread: the v5.9 tree now has
033b5d775511 ("mm/khugepaged: fix filemap page_to_pgoff(page) != offset")
which fixes this VM_BUG_ON_PAGE (or data corruption) when CONFIG_NUMA
is not set: we are hoping that may have have been the problem here.
