Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED5DC2D0E5
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 20:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02C1420719
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 20:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNo8hwrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYUFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 16:05:52 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:46046 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbgCYUFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 16:05:52 -0400
Received: by mail-io1-f42.google.com with SMTP id a24so3039015iol.12
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 13:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4fWuN7VyLwSnaStQfT4sVZnwq1ksW7/UkK/iH+jhByY=;
        b=YNo8hwrHU8vOBrYFY+plAN6BLun/f2wJQBoX1Ybk1UOH5u6akhCa6uC5bP72Jak0N4
         OGMMsNCmtrGTR6F8JorFTDBh9xFbKgl5/JNGlEwN+nW0/MyJrVsmRlwIVxMEVA+J0a9V
         9YQOktA5PLrHmbK09Yi9HkHZd6QQwfW6POuhgDszsvJd6GZ2Nqc2p8H2lj+DPoOCQ8fE
         HuSY9JXXZZhaV/Xcwy5H9hcbxqpUT4AiHughAfk1LwxlnDeEruheRDiVqaOa5UEqmb8t
         lrRpiyYpYHiJblCAEZKeADtO82OsnCPaC2y0G87OKx1WDu/DISJvvZEpk93bcQUIeCms
         6VzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4fWuN7VyLwSnaStQfT4sVZnwq1ksW7/UkK/iH+jhByY=;
        b=gdZxkzdPB7Pt6x9dCP1t1IyorWBm31WOzQgLUX7e3gz6ezbTcL1pks8JatsrqD0Rss
         xoZZwm73ShktaHOIycjwlWqoAKE1d9plmoOwlV+H3lIH2PRkXfusqDHpl+jkoiBaspui
         p7QLV7b+ANB+1aSIqW+QZzmSpuhyWwQjLUZVCLGdhWhKJ62A6y6jx08qkKq88KHvul2I
         A3qHk1EuKwRx3TfEU6xfkrSLKcFqV/F86QtQ/+0BzmDa2QsWpVPvtgBeXyuTaWJE1oLs
         0csBDmfgMdMpaudyNSeRHpAg4OKdi9Fqs8R8hX+89n3SNDBH+V2Bze+1MnFun6mmBa5+
         josA==
X-Gm-Message-State: ANhLgQ1BmfwSnPLP2bT4gZGr+mHOuCGgLuTehDqaYLKgf/tk2bbpRmN/
        oAOdsmSbqtNi+kkTxk0pfi9PjkA6XHQjES1iLlc=
X-Google-Smtp-Source: ADFU+vtvtUl7l/KMTSxpu0qI657jEFhrjhDgZ6qIUGgH3OGlI/yHd5NYqTU4Bqisi16UTTBcON9m366gcC9psY/vYqU=
X-Received: by 2002:a5d:8a10:: with SMTP id w16mr4611254iod.153.1585166751123;
 Wed, 25 Mar 2020 13:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <CABS7VHBR1TqgdKEvN8pnRH8ZxZZUeEFm6pFfaygOzv0781QrRg@mail.gmail.com>
 <20200324183819.36aa5448@harpe.intellique.com> <CABS7VHB2FJdCz+F+3y86wawmBSuaVmfnC57edHVsoRugAK2Nsg@mail.gmail.com>
 <20200324192610.0f19a868@harpe.intellique.com> <CABS7VHDt=v1SmSggnn8288uE5Cs27RqXpPsbiGk9=wyJ-pz1pQ@mail.gmail.com>
 <20200325152418.04340a72@harpe.intellique.com> <CABS7VHCuGgu0N5ZSXXSKQE9R5ngzAedv_TdZDMt-CHWDfhRZEg@mail.gmail.com>
 <20200325183737.634580f5@harpe.intellique.com>
In-Reply-To: <20200325183737.634580f5@harpe.intellique.com>
From:   Pawan Prakash Sharma <pawanprakash101@gmail.com>
Date:   Thu, 26 Mar 2020 01:35:12 +0530
Message-ID: <CABS7VHDNF8yLeTrY-E5k6XOFjSznjrjwxFgGWukvgE3PQLGT0w@mail.gmail.com>
Subject: Re: xfs duplicate UUID
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>Yes, that looks like the proper way to do it. Zeroing the og with
xfs_repair is usually a last resort thing that you'd rather not do
unless it's unavoidable.

Thanks for confirming and thanks for helping me.

Regards,
Pawan.

Regards,
Pawan.


On Wed, Mar 25, 2020 at 11:07 PM Emmanuel Florac <eflorac@intellique.com> w=
rote:
>
> Le Wed, 25 Mar 2020 20:35:03 +0530
> Pawan Prakash Sharma <pawanprakash101@gmail.com> =C3=A9crivait:
>
> > > Note that even after freezing, the on-disk filesystem can contain
> >  information on files that are still in  the process of unlinking.
> >  These files will not be unlinked until the filesystem is unfrozen or
> > a clean mount of the snapshot is complete.
> >
> > hmmm, ok, so what is the right way to do it?
> > Sould mount the cloned volume with nouuid first so that log is
> > replayed and filesystem is clean, then umount it and then generated
> > the UUID for this using xfs_admin command.
> >
>
> Yes, that looks like the proper way to do it. Zeroing the og with
> xfs_repair is usually a last resort thing that you'd rather not do
> unless it's unavoidable.
>
> --
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
