Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91E6C74A44
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 06:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCNGAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 02:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCNGAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 02:00:34 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39AD50F99
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 23:00:33 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id a3so13137691vsi.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 23:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678773632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kP3Av7PNq5YG3n+WqZ0X/vq7UDnO3zRjOV0vIaZuv6Y=;
        b=Cp3dVhJLa1BtuxlxxlH18hFgQAEbEZXkAAZn2bOxFQXYCqtdU+D00d7dxp8wZAT7mL
         /8OY/+m8dMIMHcrLg6JiDDYUdZIpoj+XKw8Gz2FOrUHg0avDq7VSxphohLfdaSRqgT1D
         y4LYZrKBcxEMrEg2LmveIr9BOl7HohCJ9b5xYwCBth6lCrsh2h/YQ/uY5sNIfj7obNTj
         pgXHihTm2DofD70eDRBOYm0dsl3Tq2mFR6OsbkrA6G2nDS4EvtkB6a7nWUpmU+agJZf5
         lwdzg+2pAWZxDTgrCs4RR1SPrLwB1ZvVqccbAr8FAHvZV9n3RcvRmQJYmsM0pp0UCVAd
         cC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678773632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kP3Av7PNq5YG3n+WqZ0X/vq7UDnO3zRjOV0vIaZuv6Y=;
        b=2Gcf7NqbKeqFO2bbK8gwEI2o9PZ7SaY70/3eYlmrlFLqRyx21CBVSjTJWSsF1IfNu/
         BKuGpX+ghl8EFr/1KUF/D+8agEYS2pZzpji//RdFTLwennTsmaYUid89SrfThILAppX6
         60yVtQDi2/miLiz261Hch09U2nKC74qi4PzBaQl/8Piq9pDXDVpoaXaLEL1xdDs4e5PH
         5c+3zcXyMgYOvXs+jMAcbsOCtwWk7P1A1uMwMW3KrEXYkNAk7NCLQJdsTVUtotDMn6sc
         r8Jui/l7AM7uwQNWocTp8sfFl4PmCD1ascvTlXtIa+MqwLFhso2QfJ0qXUt4C6eftrwC
         xPYg==
X-Gm-Message-State: AO0yUKW+4+g6FQ4Fjc9OwrcBQWZcKqlDhoOPkj++bswcNaVmbl+2feD2
        /ciNfnSkAIYu0dfA8TstHyuso6J61AE2OaZESqdIX+junmA=
X-Google-Smtp-Source: AK7set+0U3jARLrBK3JLB4ch84N2wz+MAB+1T6/bR8qJ4rho+Qcee9DshupRCBnjq/pmTwDv2y+IsfhmU+X286POq+k=
X-Received: by 2002:a05:6102:3196:b0:423:e7a3:aedf with SMTP id
 c22-20020a056102319600b00423e7a3aedfmr4736064vsh.0.1678773632600; Mon, 13 Mar
 2023 23:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314042109.82161-3-catherine.hoang@oracle.com> <CAOQ4uxhKEhQ4X+rE4AYq70iEWKfqwQOZu47w_n1dbXd-wOeHTw@mail.gmail.com>
 <20230314052502.GB11376@frogsfrogsfrogs>
In-Reply-To: <20230314052502.GB11376@frogsfrogsfrogs>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Mar 2023 08:00:21 +0200
Message-ID: <CAOQ4uxgeHcSOnZxKV4rGXa_gj4-hwicu7=VVvofrQGwcDSdt0w@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] xfs: implement custom freeze/thaw functions
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 7:25=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> On Tue, Mar 14, 2023 at 07:11:56AM +0200, Amir Goldstein wrote:
> > On Tue, Mar 14, 2023 at 6:25=E2=80=AFAM Catherine Hoang
> > <catherine.hoang@oracle.com> wrote:
> > >
> > > Implement internal freeze/thaw functions and prevent other threads fr=
om changing
> > > the freeze level by adding a new SB_FREEZE_ECLUSIVE level. This is re=
quired to
> >
> > This looks troubling in several ways:
> > - Layering violation
> > - Duplication of subtle vfs code
> >
> > > prevent concurrent transactions while we are updating the uuid.
> > >
> >
> > Wouldn't it be easier to hold s_umount while updating the uuid?
>
> Why?  Userspace holds an open file descriptor, the fs won't get
> unmounted.

"Implement internal freeze/thaw functions and prevent other threads
from changing
the freeze level..."

holding s_umount prevents changing freeze levels.

The special thing about the frozen state is that userspace is allowed
to leave the fs frozen without holding any open fd, but because there
is no such requirement from SET_FSUUID I don't understand the need
for a new freeze level.

Thanks,
Amir.
