Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D819BC2BB3F
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Nov 2023 19:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjKRTmB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Nov 2023 14:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjKRTmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Nov 2023 14:42:00 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D06192
        for <linux-xfs@vger.kernel.org>; Sat, 18 Nov 2023 11:41:56 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-507b9408c61so4197710e87.0
        for <linux-xfs@vger.kernel.org>; Sat, 18 Nov 2023 11:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1700336514; x=1700941314; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=arrWkxXHqp3RBN6xKz1SeOK4wu0R/9RHSILdDDeQh8c=;
        b=N9yWi3VRtgxBKD2q079Y0mlUfEFGau81ikloMxHfXG1VGTTLVGYdA5LdyKCG/+lBp2
         u/pyy2g11k+G+xz9LBFQT46OpyScaw/PodLAt/X4qQFU0C3g2euznDidmQ+Ia+4bHQZp
         SdE0FSONEG6xkfqMUBfhO1zNbtzORglxvwufU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700336514; x=1700941314;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=arrWkxXHqp3RBN6xKz1SeOK4wu0R/9RHSILdDDeQh8c=;
        b=kpkm5ykVmb9Xc5a9sBYQ2I9MMoMYliBhlDA9eUVq0QFjUEAyvlEEVQDEu6dml1lXN/
         pZ6GWeHyLbxzHpyrEKYuLB5TXgvYujV93GYIY8zZRLrHqwFEzXKp+XSEa0WfXs+UDvK6
         TIKt6BCg65UzrrpDXj/aq2IsHaSwCWZ9xJjSvm3eIqeZ+nwt0f7+jxACIS+RRrmtYhKz
         ACZqN0KbTp+pO/BB+JkosrPiTVhdbeATPoV1+SdPrKRHskXk//32URDJ5fiEM/o9YvTm
         SK5JD1KgcdT5a92dT+hTYWx/Vxp9EStP72L/mhu34/mgawxhHrlExvfPsFbIRejpn+05
         gyZw==
X-Gm-Message-State: AOJu0Yx6XrpDsjmgKMW5bpvE5EVH7vIusobHAEfo5gZ/g8c3OjQgP+uK
        TVQ3j64jJiUve/d6oWK3ObGArx16nz/ZiLlGpipa3yBA
X-Google-Smtp-Source: AGHT+IF0qDTZNa+1TlWLqYU+s9VO7XofHpiwX7VT44pmMmOmmk9J6zJSaKdI+KCmunmqMfa0FjHTNA==
X-Received: by 2002:a19:f80c:0:b0:509:1207:5e9a with SMTP id a12-20020a19f80c000000b0050912075e9amr2487219lff.42.1700336514586;
        Sat, 18 Nov 2023 11:41:54 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id a18-20020ac25e72000000b005094d95e8bcsm651248lfr.218.2023.11.18.11.41.53
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Nov 2023 11:41:53 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50797cf5b69so4163622e87.2
        for <linux-xfs@vger.kernel.org>; Sat, 18 Nov 2023 11:41:53 -0800 (PST)
X-Received: by 2002:a19:6409:0:b0:507:a6e9:fbba with SMTP id
 y9-20020a196409000000b00507a6e9fbbamr2364600lfb.63.1700336513175; Sat, 18 Nov
 2023 11:41:53 -0800 (PST)
MIME-Version: 1.0
References: <87zfzb31yl.fsf@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <87zfzb31yl.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 18 Nov 2023 11:41:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgC_nn_6d=G0ABjco5qMMZELGrUyCVQN3zB8+Yo5F8Drw@mail.gmail.com>
Message-ID: <CAHk-=wgC_nn_6d=G0ABjco5qMMZELGrUyCVQN3zB8+Yo5F8Drw@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: bug fixes for 6.7
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     ailiop@suse.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de, holger@applied-asynchrony.com, leah.rumancik@gmail.com,
        leo.lilong@huawei.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, osandov@fb.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 18 Nov 2023 at 00:22, Chandan Babu R <chandanbabu@kernel.org> wrote:
>
> Matthew Wilcox (Oracle) (1):
>       XFS: Update MAINTAINERS to catch all XFS documentation

I have no complaints about this change, but I did have a reaction:
should that "Documentation/filesystems" directory hierarchy maybe be
cleaned up a bit?

IOW, instead of the "xfs-*" pattern, just do subdirectories for
filesystems that have enough documentation that they do multiple
files?

I see that ext4, smb and spufs already do exactly that. And a few
other filesystems maybe should move that way, and xfs would seem to be
the obvious next one.

Not a big deal, but that file pattern change did make me go "humm".

So particularly if somebody ends up (for example) splitting that big
online fsck doc up some day, please just give xfs a subdirectory of
its own at the same time?

            Linus
