Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8849C64ED8
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Feb 2023 14:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjB0OuH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 09:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB0OuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2023 09:50:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132B6199DF
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 06:49:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677509351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x/ElBBPK8UgayfxVszWmis2Rs7vMYtKDO6N6XgXO/FE=;
        b=NEz+rIk3oxtYJgfNljZWJDGSlaP3zNLXabALbo2DZcMygJT5zLaWZLxGODhVWV4iWEdtTe
        k2X8y1P49juj10NIYR9nTciMpQsJSLUXHu7feVlkKup/Md9JXvyC05oYZ5oHjz1jymWaZp
        Rd9n8ZzpJTDoZIKJzhFTGrZiOEAGsnY=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-533-adb6WVmZO1Cuh1jCq2S2Rg-1; Mon, 27 Feb 2023 09:49:09 -0500
X-MC-Unique: adb6WVmZO1Cuh1jCq2S2Rg-1
Received: by mail-oi1-f199.google.com with SMTP id bh14-20020a056808180e00b00364c7610c6aso1684325oib.6
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 06:49:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x/ElBBPK8UgayfxVszWmis2Rs7vMYtKDO6N6XgXO/FE=;
        b=TW5iwrPG5VFsYETjLudfQLGvwEq1Gy9Zm+qlQvgU5NyZLCP5R+MplAo4HKvddMF5rs
         s5dM/VgO7VmIZ4/tbBMOsAGNYS4dy0h+eliJl08ucsRgJf/TOB9DFr3wvTj89Ao7ikPf
         9y/cE7hr0gph8Z+/H1s2ojwjfS9gRteeE1m6Tqe0BS11LdCapN/zbZWyAaAUhl72u3Gl
         C9VCtYYmtT4+RPZthjh+45ReWLWEBwZFSyqwpHc1wBgHEpCksJXYfNW+SUlQwy9S2ILy
         BTOzApg6byzIHoP7hXPOGqR51NSslD8FjL0Aa3fe18ZZGZms1GFEIyZIDd9NTGSCi1V3
         NYPw==
X-Gm-Message-State: AO0yUKXz3KplRBw4mSqeV7sacPqEosNfql1RkwhKsHKgSFREc4Upu7R3
        K7+9nhgRR/WWj4Tr1x8ni6b6+NfvNZFabfkd1F3Zj2Z1ggQ4oJpz9MsA2C6zPWRq8jn0Y0FFVIN
        fOd8ZfoPoFMyl2SJLU+9S422H90AC6D84SKDbwuqA9zez
X-Received: by 2002:a54:458f:0:b0:384:118f:f9c8 with SMTP id z15-20020a54458f000000b00384118ff9c8mr2407661oib.7.1677509348817;
        Mon, 27 Feb 2023 06:49:08 -0800 (PST)
X-Google-Smtp-Source: AK7set9V/VQAYRRW+RNlMQ2Iyote9tJX8parcl0bidZVGDj2BvmlzSTAH41uVNut4gwBVIQHSrAfAR+yQ4Bzw/GT34Q=
X-Received: by 2002:a54:458f:0:b0:384:118f:f9c8 with SMTP id
 z15-20020a54458f000000b00384118ff9c8mr2407655oib.7.1677509348429; Mon, 27 Feb
 2023 06:49:08 -0800 (PST)
MIME-Version: 1.0
References: <20230227131722.2091617-1-arjun@redhat.com>
In-Reply-To: <20230227131722.2091617-1-arjun@redhat.com>
From:   Arjun Shankar <arjun@redhat.com>
Date:   Mon, 27 Feb 2023 15:48:57 +0100
Message-ID: <CAG_osaZLSZ0VG4-oj2jRttYm0YRsaoZQPbTAW0UHwh+ODW=GsQ@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] Remove several implicit function declarations
To:     linux-xfs@vger.kernel.org
Cc:     Carlos Maiolino <cem@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> During configure, several ioctl checks omit the corresponding include
> and a pwritev2 check uses the wrong feature test macro.
> This commit fixes the same.
>
> Signed-off-by: Arjun Shankar <arjun@redhat.com>
>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Please disregard this RESEND. Looks like this has already been pushed
to the for-next branch.

