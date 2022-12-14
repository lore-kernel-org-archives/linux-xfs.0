Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB8AC10F1B
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 00:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbiLNAxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 19:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiLNAxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 19:53:47 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E5924BD2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 16:53:45 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so5443440pjr.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 16:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6FPkAv72GYYparyOjopC4+0TyiONk3xjxwzE/01pbQw=;
        b=xcLF+nYK5jvQlV8/BNLBVSVxdyf+dQlZPWF9D1ueXEfpI6r76ImwZPCVWJef3joDZO
         IV4pusV0rpl1j/Bqvt1NMYqVAUo/Vl+F6W1i5bCgXw0lnp0ycVBjIfiH5PK66eQsuEfv
         fxjnn1/TFfpPC9GZ287CMc4KzkvDaYhP9gz0FHxW36aRjJw0syK0yTk8+Vb0BZnPNbJj
         TVl+hndk1fZuw+mK9GlkjOEHsyDQS0MmpijeRzNfD22khR0POP8gqwm0iSNp13gDY08f
         J9yfIBSC/Xn8KaVkDNBow9bjJI/ypkrNtG/yBLGVa1LbujVA7VHFD55CrxQgO2mIecEU
         vj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6FPkAv72GYYparyOjopC4+0TyiONk3xjxwzE/01pbQw=;
        b=S754fPSBNmaV66yZ5DiPJxjbdVJSiZSjHAVNXCDXRrYQCDbG7K/lb1JY1ShgWj/fWw
         T3g2T5D5MUNMyiMQBBjb0GT9vmBExGs2fF5umniLw4t+4gUqrj8IsfOTnQ1zELzjJDPR
         LaDM1oF8MXlIxN5+QTi4MxufIjPwhTutvcuXSFkkSx8EjAgeMczCk8KpX9qKcXjkwiK0
         qQxoE5mOj00t68DuwMix4A6Z3HQOFqwV2WN9p9mZP1R5D2ZOA5b2vK2t99rpmYVXq4mk
         DawtF9W1uq0tg14BRLEkvRQwCUTUkouGfBe6vqMEWhM3VggvBk7jm/az5h2vByzr0g4m
         dz5A==
X-Gm-Message-State: ANoB5pnUc3WF8Afrc/kMOsZqOszPwyihK8u/T/FFKlA8NZj/LEG+Db9h
        t2k5fX5S6RK3MDVRLzJkH9SisY0aOvPCbFSS
X-Google-Smtp-Source: AA0mqf5BbaixKSd/wkuwLlznlJvzmAnqWjKT5bPkY326ZcTQF/FFoDINZHMs8V9tKIrF+2fxLNy+yg==
X-Received: by 2002:a17:903:40ce:b0:189:c83f:d5 with SMTP id t14-20020a17090340ce00b00189c83f00d5mr24619081pld.52.1670979225273;
        Tue, 13 Dec 2022 16:53:45 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id a15-20020a1709027e4f00b0018b61ecf36fsm441258pln.287.2022.12.13.16.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 16:53:44 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p5G1m-0089IT-Au; Wed, 14 Dec 2022 11:53:42 +1100
Date:   Wed, 14 Dec 2022 11:53:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 01/11] xfs: enable large folios in xfs_setup_inode()
Message-ID: <20221214005342.GB3600936@dread.disaster.area>
References: <20221213172935.680971-1-aalbersh@redhat.com>
 <20221213172935.680971-2-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213172935.680971-2-aalbersh@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:29:25PM +0100, Andrey Albershteyn wrote:
> This is more appropriate place to set large folios flag as other
> mapping's flags are set here. This will also allow to conditionally
> enable large folios based on inode's diflags (e.g. fs-verity).
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 2 --
>  fs/xfs/xfs_iops.c   | 2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
