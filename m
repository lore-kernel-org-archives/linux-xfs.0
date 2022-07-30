Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53548C3F6B0
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jul 2022 07:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiG3HwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Jul 2022 03:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiG3HwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Jul 2022 03:52:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4322C13DE7
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 00:52:18 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id sz17so11957068ejc.9
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 00:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=sW/SOkVQdGE4dXJwwLc+zTF9ESbscxQR2bBrDwzilPk=;
        b=h5SOAGVU60C54fN7dZjdS9/tg4pVXorHfEpD/hpu6mH4Zg5apXIiNRhz+2u8KHbqn7
         8SiRhmGikalttUCDmUpx5VBknoWGReDozXrvzSVKNl8FSOglUjtpycwIyCVHfX7aAvfp
         KX1rJBe0Lj2neh3gzHVOfG+Vr3/XWybPGBSe3Lb4nO0b7KqKqKypJS6WVeYAn9gHP8n7
         HC9afZa4f5xmbBD0jnnHrwvaoHec9v27negJEE1hpYVRxVifa0PHTLbaxbFvxE05TXos
         GkxxVifkyqdWjhTYFiHmrCLSEoMsf0ZM28Wq+X1RnLlz+oPr3HztGSCSjv2Ubqzh3XsD
         yHpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=sW/SOkVQdGE4dXJwwLc+zTF9ESbscxQR2bBrDwzilPk=;
        b=sbmn6VJDuXMaNCkM+nL0IDfVMnPKkFCAwTrGJgTJRIEKNzHxNS+FJJ0MxSMIdptzBQ
         P0geusWtRZj1hLJeCNij6RU5wiBimPCA70JACkIQZOdh8yyA4YLlns9hPZKfFs/UeQlO
         xm0gSQui7AqNtmuwOyLItjl5DUPF1sQkFqG1azZAqrkrD4V6uoe1QCaKvl+xpZAjSKgD
         11FRpCE9F10ZeXCHrE21icsnZvFqETB/6yZyieqzN4TJroKw0DcEmyvNcPQ+CjQFY0iC
         fglV/zz/u2gIqtRozPzBx4tksxo0NL+Cv3Aa7wwiNLwLloQlJMyuiMIMe9zFPyx3va13
         nLYQ==
X-Gm-Message-State: AJIora/tPQ0G/ZSKWhuAwVlWx5Z26KnpyfaLSjmmiT8Do0AKaKAnC3uc
        pyDQhcEBWPTIGhG8dxXob8S9gqjrzRAF7VjG54s=
X-Google-Smtp-Source: AGRyM1vkS1K36tQv2rlq8C5gR2AsAEjXq42zMb0AE7kpfdDHAv0siNXelkT+kp0mi+GU/JONzW+eRQe+fNKIsE7NmEE=
X-Received: by 2002:a17:907:2bd3:b0:72b:44ed:6d6b with SMTP id
 gv19-20020a1709072bd300b0072b44ed6d6bmr5595138ejc.632.1659167536552; Sat, 30
 Jul 2022 00:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220729075746.1918783-1-zhangshida@kylinos.cn>
 <YuQATS8/CujZV3lh@magnolia> <CANubcdVqkeyG5AP56AQ+x3QayRmLZ=zULShhxha-a4N16gPKYg@mail.gmail.com>
 <YuSJuF55dZLsbO8Z@magnolia>
In-Reply-To: <YuSJuF55dZLsbO8Z@magnolia>
From:   Stephen Zhang <starzhangzsd@gmail.com>
Date:   Sat, 30 Jul 2022 15:51:40 +0800
Message-ID: <CANubcdW2LOgePOCLyE=Q2sbSJ0UGO+2Wt3YjsBd3eD9radOVVQ@mail.gmail.com>
Subject: Re: [PATCH] libfrog: fix the if condition in xfrog_bulk_req_v1_setup
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@redhat.com, hch@lst.de, zhangshida@kylinos.cn,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Darrick J. Wong <djwong@kernel.org> =E4=BA=8E2022=E5=B9=B47=E6=9C=8830=E6=
=97=A5=E5=91=A8=E5=85=AD 09:30=E5=86=99=E9=81=93=EF=BC=9A
>
> It's probably ok to resend with that change, but ... what were you doing
> to trip over this error, anyway?
>
> --D
>

Well, I was running xfs/285, and ran into some other error, which was
already fixed by the latest xfsprogs.
But in the process of examining the code logic in xfs_scrub, i still find
there may exist a flaw here, although it hasn't cause any problem so far.
Maybe it's still neccessary to submit the fix.Or am I just understanding
the code in a wrong way?

Thanks,

Stephen.
