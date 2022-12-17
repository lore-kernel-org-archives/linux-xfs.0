Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED516C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Dec 2022 17:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiLQRbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Dec 2022 12:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiLQRbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Dec 2022 12:31:03 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E9C7D
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 09:31:01 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id l8so5201185ljh.13
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2022 09:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UHwKv8nza+iyPMYtlVpsTpmRrK6ZcOG/IhPgO5+pNDg=;
        b=D/M727EAxmNOAk3c/FHfWfd2GJJf9FHo90hivK7GWfJM0QZqdl6XvR4b/u0n/g9Xpa
         hKpS24ASpQ3K5CRTs/Vxszf7yeZur2oBQJDtwWoiY6tSIvpiMR7VejP/44SJFWrzx+3Q
         iAuuwcrfH777VJEwpH9whXYIlZpcMdpUqFOrE+TrDkINuZbsygRIqWyn3nnAFh9CCno7
         rr6DEjE/W8NHOYU11dpVuty/pVjwTiCLZ35JJUfq6h19804qhVDBSOUBrXwSVSAAQdAl
         U2saBlHwRPbbiVUc72ZTK1DDwKO9VHlU5THBZP76ZoUf3zNhqtr0IIZ1MIrVcj9LbFvK
         ffvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UHwKv8nza+iyPMYtlVpsTpmRrK6ZcOG/IhPgO5+pNDg=;
        b=BU94WbxuTate7qIdt27B8Iw1j+AJFL0xDoVdGTHrt8Qp/FEROTLUh/IYAkFZNOsD9I
         MpPR+tfw/f66TfG7eKeObGClBQ1DZ59Oo87XLpaqHBmxkyr/iVqsqWBsBt6BtjUBm2eP
         z+SflJGHzAV++rFDp99UCLTWmRKTXPg5j4Yw/3QpFSIo5XAUNbziA3eV+J+A+rxX2qKt
         fyjaSlKlBuFDvAA+P4GFvTCea/HF/LreHFO7uTwY8m/BmuaxzLRP6RvaJRan6PCgxDwn
         f5l0ApyHFbA26mF3UBL7kExwNp0OUuqonif1YXTghBcGe+mEIaZ0xSjOuD6qJ++4Icol
         S3WA==
X-Gm-Message-State: ANoB5pktyLGWAQ8PaVBjlsG0UwmRcxoxEIaJhE701nP2FjbigdN1TRDe
        qxcxUgM6syenu1zQUzvZ+wDbkeo4bXukTXQYCc4=
X-Google-Smtp-Source: AA0mqf7ACXhF/WfFdEbXVA8/Jv7j+KfiTTwhKfeonBgBGewmXpxItHswUiksIvRAJuDy/3l2XbCmde3872Qz1cXnXbY=
X-Received: by 2002:a2e:be10:0:b0:27b:51e2:4879 with SMTP id
 z16-20020a2ebe10000000b0027b51e24879mr1070867ljq.61.1671298259853; Sat, 17
 Dec 2022 09:30:59 -0800 (PST)
MIME-Version: 1.0
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com>
 <Y5i0ALbAdEf4yNuZ@magnolia> <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com>
 <20221215001944.GC1971568@dread.disaster.area> <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu>
In-Reply-To: <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu>
From:   Mike Fleetwood <mike.fleetwood@googlemail.com>
Date:   Sat, 17 Dec 2022 17:30:47 +0000
Message-ID: <CAMU1PDid0KYipUw-1Wznn_zVBcx6G5Y1K=AK7pLf60TqX02_Dw@mail.gmail.com>
Subject: Re: XFS reflink overhead, ioctl(FICLONE)
To:     Terence Kelly <tpkelly@eecs.umich.edu>
Cc:     Dave Chinner <david@fromorbit.com>, Suyash Mahar <smahar@ucsd.edu>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Suyash Mahar <suyash12mahar@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, 16 Dec 2022 at 01:06, Terence Kelly <tpkelly@eecs.umich.edu> wrote:
> (AdvFS is not open source
> and I'm no longer an HP employee, so I no longer have access to it.)

Just to put the record straight, HP did (abandon and) open source AdvFS
in June 2008.
https://www.hp.com/hpinfo/newsroom/press/2008/080623a.html

It's available under a GPLv2 license from
https://advfs.sourceforge.net/

Mike
