Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596D6C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 01:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32AF56101A
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Oct 2021 01:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhJDBJL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Oct 2021 21:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhJDBJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Oct 2021 21:09:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC4AC061780
        for <linux-xfs@vger.kernel.org>; Sun,  3 Oct 2021 18:07:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t4so2044197plo.0
        for <linux-xfs@vger.kernel.org>; Sun, 03 Oct 2021 18:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=pStQdMrL6ZFdXlJGha4PGljRtDULz8i5+uPOyRWf8rU=;
        b=kAMJB1dPHfIu0grrWDbrhbolngM0JPtqVX6W4LQ0dtNlTNzO4A4V4jJfu3GO//KpI/
         zoCckKf+f5s6de3QFu2N7/YZY8bZhxxvwZ/cVyDsFquSDFcoOsCt9tkpgk8jwGmfEcWR
         OKK/uu0L1RIcNvw+Ro/RFp06yHEtZkrhJNa8FM/BDB59V45gHSKiejNo357eRnDtDSy/
         b76AdDM/tjRm2HBiefXqqGCizbuXhYPpOwxVNjkVSaN+zzokQ1GhYkxAEiqJ/E/NxsxO
         cqUaV5bA/NdeHMtleODM3D57VAurRyugnfdK9q0qM1J2IakdMLzcGTbSIMufvfOtYCZ7
         ycdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=pStQdMrL6ZFdXlJGha4PGljRtDULz8i5+uPOyRWf8rU=;
        b=2C7p1RZldVf33JIhrpsh02tOFgaIZUmcj0brEnO1TRdmjIvwjKy4FqMonXNk5CPNh0
         qq/r5LMTONVX1qiY7qpi6hZ5nlxF4XKOLyP/s4yaIRrqN5dwy8AItkU0U7GBpr9tITJx
         rF7ITuA1OJL2nbVsD8w8WUXziH6Ei0iWNtJxaoWV4TlJOhnO/AFPTw+igzm1GbmVO8AD
         BrERn13PUW65DI520KBZjwfThm5PjYE7T8Wn+5/86nv2SPMNWKLYO5SOmTzxD5vR9Zql
         bI+thkJh/s+1NAFOBN1dys9fUuMFx8HW2d5MbsFp82iqcMzqozSG/7gW88m2gph6HXsI
         k26Q==
X-Gm-Message-State: AOAM533b50P1i/nsiSLn4w8+QhcFSi9rcWbEh32pxn1CPO+2M49jGyjG
        CXwZC/2OjKb92znxJtuFqbKAUg==
X-Google-Smtp-Source: ABdhPJw+OUZxiTir+uXz7ip5A94n6l2wmdN8lZupAMuxEoGz73pp9OWHAtT4OzzvlWLfGbA3B+EWQQ==
X-Received: by 2002:a17:902:7e48:b0:13d:a58a:e9ce with SMTP id a8-20020a1709027e4800b0013da58ae9cemr20330094pln.21.1633309642214;
        Sun, 03 Oct 2021 18:07:22 -0700 (PDT)
Received: from [2620:15c:17:3:4faa:17e6:3602:9e7d] ([2620:15c:17:3:4faa:17e6:3602:9e7d])
        by smtp.gmail.com with ESMTPSA id p24sm2314787pjz.32.2021.10.03.18.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 18:07:21 -0700 (PDT)
Date:   Sun, 3 Oct 2021 18:07:20 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
To:     Rustam Kovhaev <rkovhaev@gmail.com>
cc:     Vlastimil Babka <vbabka@suse.cz>,
        Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        gregkh@linuxfoundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        dvyukov@google.com
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
In-Reply-To: <YVZXF3mbaW+Pe+Ji@nuc10>
Message-ID: <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
References: <20210929212347.1139666-1-rkovhaev@gmail.com> <20210930044202.GP2361455@dread.disaster.area> <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz> <YVYGcLbu/aDKXkag@nuc10> <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz> <YVZXF3mbaW+Pe+Ji@nuc10>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 30 Sep 2021, Rustam Kovhaev wrote:

> > >> I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
> > >> excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
> > >> two together last 5 years anyway.
> > > 
> > > +1 for adding Kconfig option, it seems like some things are not meant to
> > > be together.
> > 
> > But if we patch SLOB, we won't need it.
> 
> OK, so we consider XFS on SLOB a supported configuration that might be
> used and should be tested.
> I'll look into maybe adding a config with CONFIG_SLOB and CONFIG_XFS_FS
> to syzbot.
> 
> It seems that we need to patch SLOB anyway, because any other code can
> hit the very same issue.
> 

It's probably best to introduce both (SLOB fix and Kconfig change for 
XFS), at least in the interim because the combo of XFS and SLOB could be 
broken in other ways.  If syzbot doesn't complain with a patched kernel to 
allow SLOB to be used with XFS, then we could potentially allow them to be 
used together.

(I'm not sure that this freeing issue is the *only* thing that is broken, 
nor that we have sufficient information to make that determination right 
now..)
