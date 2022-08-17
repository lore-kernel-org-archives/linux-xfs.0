Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EFF1C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 13:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbiHQNQO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Aug 2022 09:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239191AbiHQNPn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Aug 2022 09:15:43 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1738185FF1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 06:15:26 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id m21so1253321uab.13
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 06:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=cSo15qrf6HsTaJ5udJjVZD9V3SXs7LH28gj50HEVHFg=;
        b=hFGVz0LR2iyiJAIC5IXIwW1H7UTKatgsEZC5nD//ICDMylDFjiIwdR6qMAoLKEdffU
         OU4pdYxdsqnjjqyOjxKPcgWawvWtJR9xMVjXjXJAeErJlo3DFa3tPu6gC7gWR+W/Tp9P
         6TRgI+3R2I1tVS9UGjXoGYO5+DUYeTdQWnNMAPNYVx9YwtrI38QD9mvDBTt3ACY6iIVQ
         KMqQc7iUw/3vK+DLLqXilBpDyBr4950+a9RPbXjocg8BLIqGrTPxU1rARuziw3fL0z3H
         mJ4qIQ+Vl4svWAdP6IGrJLXIbtLbRgQ9xHcuub0TFaibMvmREyZ6lQRIGO/qBKHfONWN
         +9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=cSo15qrf6HsTaJ5udJjVZD9V3SXs7LH28gj50HEVHFg=;
        b=ZMpA+iuP9qzC4Pi0KprHI6Qch8TPn7AM6mSKHmFyrv2K3+Q/6SOIGhEm9wGbPjyc+h
         Wp943taE8jkD+fD8gWwGtRnrynsbR5h4ihAFpTTtaSw8+Dkrt1Sa/GPRuHhB0hc61fCs
         P3f9bDDxVpRSdVnaxVbrzNKze8/fjcjkx4G0Gan9LlmOxRnMS+p0RXRr+7FzfgxJYxp0
         oiITgqoxGiBYQihFU5btCwam9fnfUm+R6ISNTo6suTjTGxly02eIQx7UIOgfw9iA9sFz
         i5r4P3BeifsmSAw95GWuwxnA944Nnld3sMWkN6rVaPIl2UdSU0a+je9slanek2MX88go
         KZyw==
X-Gm-Message-State: ACgBeo3AYTrDG+fCj/S5OOQDzVXTpbIEFTDHfbeTtGl8+2qcbCKtx8/w
        KVOpolmOMx9Rs1N7sdWvbtLeWeREvXr1UtdHdobF/MGMFio=
X-Google-Smtp-Source: AA6agR7eyb8XHJnu3oIMYwlTW75vFVDOVVk8tIMU6sngRn53xLzVsQjt16rrTIoCgELiD9BkbKTT+OptMyikMXnwABI=
X-Received: by 2002:ab0:36e3:0:b0:38c:4baa:f775 with SMTP id
 x3-20020ab036e3000000b0038c4baaf775mr10723069uau.114.1660742125162; Wed, 17
 Aug 2022 06:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <bug-216343-201763@https.bugzilla.kernel.org/> <bug-216343-201763-sk71fw4i3o@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216343-201763-sk71fw4i3o@https.bugzilla.kernel.org/>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 17 Aug 2022 16:15:13 +0300
Message-ID: <CAOQ4uxg0c-1dV54wEsPA8Kev9FaK==ewkHzEAxUhFXu9RqVjwQ@mail.gmail.com>
Subject: Re: [Bug 216343] XFS: no space left in xlog cause system hang
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 17, 2022 at 1:19 PM <bugzilla-daemon@kernel.org> wrote:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216343
>
> --- Comment #5 from zhoukete@126.com ---
> (In reply to Amir Goldstein from comment #4)
>
> >
> > According to xfs_trans_dirty_buf() I think it could mean uptodate and
> > dirty buffer.
> >
>
> when I review the xfs_trans_dirty_buf code, I found that xfs inode item
> b_log_item is null,
>
> crash> xfs_log_item.li_buf,li_ops 0xffff0340999a0a80 -x
>   li_buf =3D 0xffff0200125b7180
>   li_ops =3D 0xffff800008faec60 <xfs_inode_item_ops>
> crash> xfs_buf.b_log_item 0xffff0200125b7180
>   b_log_item =3D 0x0
>
> and only xfs buf log item b_log_item has value
>
> crash> xfs_log_item.li_buf,li_ops ffff033f8d7c9de8 -x
>   li_buf =3D 0x0
>   li_ops =3D 0xffff800008fae8d8 <xfs_buf_item_ops>
> crash> xfs_buf_log_item.bli_buf  ffff033f8d7c9de8
>   bli_buf =3D 0xffff0200125b4a80
> crash> xfs_buf.b_log_item 0xffff0200125b4a80
>   b_log_item =3D 0xffff033f8d7c9de8
> crash> xfs_buf_log_item.bli_flags 0xffff033f8d7c9de8
>   bli_flags =3D 2     (XFS_BLI_DIRTY)
> crash> xfs_buf_log_item.bli_item.li_flags  ffff033f8d7c9de8
>   bli_item.li_flags =3D 1,  (XFS_LI_IN_AIL)
>
> So xfs buf log item XFS_DONE is set because of xfs_trans_dirty_buf(),buf =
xfs
> inode log item never call xfs_trans_dirty_buf() because of b_log_item =3D=
=3D 0x0.
>
> Do  you know the reason why xfs inode log item XFS_DONE is set=EF=BC=9F
>

#define XBF_DONE        (1u << 5) /* all pages in the buffer uptodate */

Buffer uptodate does not mean that it is not dirty.
I am not sure about the rest of your analysis.

> >
> > Maybe the hardware never returned with a response?
> > Hard to say. Maybe someone else has ideas.
> >
>
> If we can prove that XFS_DONE isn't stand for iodone, I think this issue =
may
> cause by the hardware error.
>
> I find the err msg in dmesg:
> [ 9824.111366] mpt3sas_cm0: issue target reset: handle =3D (0x0034)
>
> Maybe it tell us mpt3sas lost the io requests before.
>

Yes, maybe it does.

Anyway, if your hardware had errors, could it be that your
filesystem is shutting down?

If it does, you may be hit by the bug fixed by
84d8949e7707 ("xfs: hold buffer across unpin and potential shutdown process=
ing")
but I am not sure if all the conditions in this bug match your case.

If you did get hit by this bug, you may consider upgrade to v5.10.135
which has the bug fix.

Thanks,
Amir.
