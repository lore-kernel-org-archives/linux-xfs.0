Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DB9C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 05:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33DF3206F0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 05:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KfEYFHyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbfKNFaj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 00:30:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54143 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbfKNFaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 00:30:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573709438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FNTlFQjhgoFKK4g8aBtwRfKWGqq1ObjteiRjJ4jvx8=;
        b=KfEYFHyFRhB0ZtBk2H+3I2/xyBlygIUyOixAsUBpPoHPaGtpNV5kXAXQ4qzytDBiyjAW2P
        pcG113oHlEOBKEUgfV3kzm5TsHzBLIM/tg7744vIYDocYluuSYKalxcVwYekQjBx9CWHBM
        DxSOkyko/m9/lgIwiUYsn3EAxiQCfCY=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-v7SukFo4NnSSEG4778HVlw-1; Thu, 14 Nov 2019 00:30:37 -0500
Received: by mail-vk1-f199.google.com with SMTP id r16so2146740vkd.1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 21:30:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4FNTlFQjhgoFKK4g8aBtwRfKWGqq1ObjteiRjJ4jvx8=;
        b=mzNNgRH/PwaaPgW7JlxMmXDPABvZXTiMVnSJ+qds6KfXNAXfUMpHkJpvCV0ava/S5N
         1klYzZTb8oFTksIECQjSgk+X8vEq/D5nOl2+ihtsps6i9Fqv68sr4snk1RhCCRuypC6N
         rYExxKIWOaSwSMkya2wdDTr9DGwBdD3UC7Vn0wh+mUrnM9IMUqpw6+ePNmNgU9By6ESf
         U2QuFtZ8DLgDVPbZoEJ0j2+JElc47UOG12G1O//pm5plkXf8+2QFycCS5rN+n/tlAoXT
         dzqhVOgN+IOQ9aL5JjnzlhL/ltePBlTtyXUBvkZodfLHLB2jDKzcFxUmjD3ZoZmYj4lx
         XDEA==
X-Gm-Message-State: APjAAAX7TH7E1HSV+1+2wtYSMPuglga6lyd8Mz/Gt1qWmQSzVH78lL27
        kyeu4Sd4IihHUxtUJz7W7HD5Vd0NXsOpHDgY68m+qE68zNu0qsUCddEP6xD9HhMZbE7Rk1O11u2
        Mwp/zhhmf4+kjyuks788DUHWaiAb6Oe3LOSKd
X-Received: by 2002:ab0:5bdb:: with SMTP id z27mr4584322uae.118.1573709436655;
        Wed, 13 Nov 2019 21:30:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqw/7DMbrgS9Te8Rt518A0riEMZETVMK2pcpAr/Z/Blhm0HyjylUJNLe+2TDOylV4JAkYsVWe5WK3UMMuz6ZT8w=
X-Received: by 2002:ab0:5bdb:: with SMTP id z27mr4584311uae.118.1573709436433;
 Wed, 13 Nov 2019 21:30:36 -0800 (PST)
MIME-Version: 1.0
References: <20191112213310.212925-1-preichl@redhat.com> <20191112213310.212925-4-preichl@redhat.com>
 <20191114013049.GY4614@dread.disaster.area>
In-Reply-To: <20191114013049.GY4614@dread.disaster.area>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Thu, 14 Nov 2019 06:30:25 +0100
Message-ID: <CAJc7PzUGiTSUTWGRMBSKfbgPjmGLs7GJM3RW3EhhZ5Sa2MjOYw@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] xfs: remove the xfs_dq_logitem_t typedef
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
X-MC-Unique: v7SukFo4NnSSEG4778HVlw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Yes Dave, but IIRC the patch failed to apply cleanly so I had to use
the -3way option and I got the idea that me  merging code manually
voids your ACK :-)

On Thu, Nov 14, 2019 at 2:30 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Nov 12, 2019 at 10:33:08PM +0100, Pavel Reichl wrote:
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > ---
> >  fs/xfs/xfs_dquot.c      |  2 +-
> >  fs/xfs/xfs_dquot.h      |  2 +-
> >  fs/xfs/xfs_dquot_item.h | 10 +++++-----
> >  3 files changed, 7 insertions(+), 7 deletions(-)
>
> Pretty sure I've already reviewed this, but simple enough to look at
> again. :)
>
> Looks good.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>
> --
> Dave Chinner
> david@fromorbit.com
>

