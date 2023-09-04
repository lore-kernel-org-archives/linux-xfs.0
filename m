Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCA4C71153
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Sep 2023 08:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352598AbjIDIzz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 04:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352596AbjIDIzz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2023 04:55:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAB212A
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2023 01:55:52 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-56b2e689968so432561a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Sep 2023 01:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693817751; x=1694422551; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Bv44DxuNITNpd4qmM6vPqTpOEKj8EebxgG2BGExGRc=;
        b=PFALBK947RnJt/jLcyWp6VjeFeCxI2BCpliG4xye3kVzCXic4SOWU9bla1e1uBk7tJ
         sXNGKAUA1A44ha0iG8/Owi8OyB4VZALZTmfDMekrKoHBX+xjf8c/d6MSbqgUu+MkvfUX
         yVwg5JJWeSJVrj45SY4SKh2yWu1HFFnLxWFYA2gDYp9DvySBa1+SpG3LjmBJGOURShAX
         oegxN8C8zcd37REpoZb2zvsLd5jLF4vHJfhtqYLSdYHffE4UaT/4khxZ631KNNAX+d5+
         oZGrEzgA+EJlT0kZM5kwXmU5mlNkH1d9hw4lrCT9Op3dD44JvzjsbeXe1RTeg2rggcAk
         PW3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693817752; x=1694422552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Bv44DxuNITNpd4qmM6vPqTpOEKj8EebxgG2BGExGRc=;
        b=Q0tyJqPOnu1JiKOVFyM5QbFdDrHU4FLdrKlyFXJKn7gr8a5+uB258wb9nxIK0i2vHA
         y0eXQtgF17t7PjWAecDiwreia7vXNIHRyfkujPycFtKG1v+gsJOr7C7QQRLBWGSVzUNZ
         F4QP81WxKLduoy3LX43BeQTM9pPT371CW12Q6rhm5EK6PWxaEY0S0A6zdTPV85+e3U1K
         2k/WsDNPmp3Pj70p1l7vcmhejxOQW+vOXMLEE5zdXUCwaBHf3Qr8mJkT592bqK8+N0Ov
         bW5XLlrOtTHNxsoYELo/kDpR2biyL0HsuHl8D66rLwLL5eoDTxkiNUiGIALOM9+AXVTu
         1gjg==
X-Gm-Message-State: AOJu0YypfaaMDL4lDNpDCEAO8pXGbnjpQ5kj74WdXgzQurzdWTQ5MpmN
        st6oHJSTmBYdO/lrZSOtYib8fk/lJMeFlS6seqM=
X-Google-Smtp-Source: AGHT+IHeoMKsRckRtk2mpp27WiGyUYVnjLYXKja/59GxduUL+F6fIrYIlPB5LwoH/z6bxVuWblRoFA==
X-Received: by 2002:a05:6a21:33a1:b0:137:7198:af9b with SMTP id yy33-20020a056a2133a100b001377198af9bmr9168852pzb.56.1693817751696;
        Mon, 04 Sep 2023 01:55:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id c24-20020a62e818000000b006828e49c04csm6870058pfi.75.2023.09.04.01.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 01:55:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qd5N6-00Ae83-1u;
        Mon, 04 Sep 2023 18:55:48 +1000
Date:   Mon, 4 Sep 2023 18:55:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Mateusz Guzik <mjguzik@gmail.com>,
        syzbot <syzbot+e245f0516ee625aaa412@syzkaller.appspotmail.com>,
        djwong@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        syzkaller-bugs@googlegroups.com, trix@redhat.com,
        viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [xfs?] INFO: task hung in __fdget_pos (4)
Message-ID: <ZPWblP6LFKRcUFcv@dread.disaster.area>
References: <000000000000e6432a06046c96a5@google.com>
 <ZPQYyMBFmqrfqafL@dread.disaster.area>
 <20230903083357.75mq5l43gakuc2z7@f>
 <ZPUIQzsCSNlnBFHB@dread.disaster.area>
 <CAGudoHE_-2765EttOV_6B9EeSuOxqo1MiRCyFP9y=GbSeCMtZg@mail.gmail.com>
 <ZPUSPAnuGLLe3QWH@dread.disaster.area>
 <20230904-beleben-adipositas-ac1ed398927d@brauner>
 <20230904-nashorn-gemeckert-3ca91ef71695@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904-nashorn-gemeckert-3ca91ef71695@brauner>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 04, 2023 at 10:23:33AM +0200, Christian Brauner wrote:
> > > Which is pretty much the case for all filesystem bug reports from
> 
> I think we should at least consider the option of reducing the number of
> filesystems syzbot tests. Filesystems that are orphaned or that have no
> active maintainers for a long period of time just produce noise.

I wish you good luck in convincing the syzbot maintainers that
testing obsolete, unmaintained and/or deprecated code should be
outside the scope of what syzbot exercises...

> Slapping tags such as [ntfs3?] or [reiserfs?] really don't help to
> reduce the noise.

Yup - they can't be trusted to be correct, so it does nothing to
reduce the noise. There's been two false XFS categorisations
in just the last half a day....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
