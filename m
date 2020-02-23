Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502FBC35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAFD120675
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 12:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXxoq3Ge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgBWMmq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 07:42:46 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:39208 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgBWMmq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 07:42:46 -0500
Received: by mail-il1-f196.google.com with SMTP id f70so5469252ill.6
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 04:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GkV8G/XbZn/3LNFmih47ohsSyCod9B3aO6rK/gWNtU=;
        b=WXxoq3GegpcGk9NCViRlimyojHyRIA/prXfzrJhcCgGEEC1SUF+yTXodXhl8gdYAXm
         QZrDLRAbn312Hx70+swQe2eAtjWvO32eIYf8QVNKDOGkhiSn8esmJw3lWz4H97NRf1uY
         w0/xn0GUcIfW5bgISO08BUPyobQA+4Le7DLBtvmYyQu/ioKJayucvjI5FQsUa4pT3jVo
         QuSUWSNRig5VjeODR/BtmaIUJ6x2uCCmvXtYfDNWZ1wkZ9GByvTkYz6GsNQHupSas8cf
         YL62meOERamw0ORScHZ+OBxYO3A4z8nnYBaHAg6GZupuOGxhknPAfwIUrloH1tVxdr50
         z7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+GkV8G/XbZn/3LNFmih47ohsSyCod9B3aO6rK/gWNtU=;
        b=h1kR09LS5pJH2eiIb9PNzsH5B+jUOv+X1zVjyCQ4+wb6H63XVFWjEPgV+tOaSpZgOF
         Yj1PQnzO3f4v9kR5pJGihWTZLlzNOeEmqm8bh75HR/Ym5M3FszuMpDzG1D/Wk2oS+iWr
         8aXXtg2shWHgb7MzRlh6tID0aYQMMAODIoS9QakWAqA3c0Idl6jHUL+Y1DFC7XqCfBtP
         L/zLWA3TK0GHkAc7uEI6oR6bXyxn/NXvY+vsFqpQzgLKCXriRu8yah8e8tBj1poU4QDF
         z+jP+xQcnOBXK5ZHWv9uFFXufVRNML+3bSW+tpqvrBRwCpChPxTH+H7jwO1OQaTim5m9
         BGnA==
X-Gm-Message-State: APjAAAV9OjkIkBPUexgWfdf8hSlz6voMhiy+1DhVRJ6+YpbvUUpNrfSM
        VU7TU2WrzrhhiJsvlEIh3QlXC8CufkkIY/tkAbmBfZQ9
X-Google-Smtp-Source: APXvYqw3vop4aMkJsDTopGdWcdg6Vr6l6PK5p3Rh5f7R1vt+CKdYwEQC1gOfn8iYJAyJP2wO8yqdf8KhpIei3eDyOlE=
X-Received: by 2002:a92:d5c3:: with SMTP id d3mr49891025ilq.250.1582461765379;
 Sun, 23 Feb 2020 04:42:45 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com> <20200223020611.1802-8-allison.henderson@oracle.com>
In-Reply-To: <20200223020611.1802-8-allison.henderson@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Feb 2020 14:42:34 +0200
Message-ID: <CAOQ4uxj_X+Sm6A838CVsDqL8zkYy63G++RFuew1dYmLsXhOpQg@mail.gmail.com>
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
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
> Factor out new helper function xfs_attr_leaf_try_add.

Right. This should be the subject.
Not factor out xfs_attr_leaf_addname helper.

> Because new delayed attribute
> routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
> that we can use, and move the commit into the calling function.

And that is a different change.
It is hard enough to review a pure factor out of a helper.
Adding changed inside a pure re-factor is not good.

Belongs to another change - move transaction commit to caller.

Thanks,
Amir.
