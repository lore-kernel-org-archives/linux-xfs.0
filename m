Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C901C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 20:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiKBUib (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiKBUi3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 16:38:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF105F55
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 13:38:27 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b185so17453480pfb.9
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 13:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ySMQAOYPs6lSyHPB4212G0UUjZknA3KxQTHHiDfeZQA=;
        b=SVAbeQqoGi9ef4hysu2fXdLu1iy69knvsp5T2MBm9gW0FWpjEVEUDLKOcqjonEB1EI
         s0Pw3h+SoFM71MWe+IWuk+NaXFkRGF0nkR1mmXCo6WyTrCKvjbqfi45tnWKI9lvwWTZ5
         fhEufgyFUlh9RXpQXuRj+/8fpo4NZLiGepvVqAIlM2QUoN4OObS7NL67y/MzFswBo5OA
         nc3731OolLuyzV6+ycQ6V/1cr6OH0Iinqdw3Ig+PVwX2KGkSAnpaob38j8Pjhte8b4Ap
         30PzPWLPHeIFGPqJrZxnYRndLbtHd7ls3cKkqX+II7OpW6VQOk/VmoVEyX8yvE+slGyt
         2S4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ySMQAOYPs6lSyHPB4212G0UUjZknA3KxQTHHiDfeZQA=;
        b=hUxHUWg13x8agd5cdNZp44SZFs+dlI/xa36vTmA3HGEt70ty4BWZjDHYzMx+LSSXCe
         WpMnlOJhe9e9TFpJjit+29NtMp2Eqhvm8FmMPDaa+hRsM44BL5Wgg/n6nYyYy/ym1ad2
         GILOzCIxiVoiZx2wBFvpijwycMq7Bgv3mWl6YCZV7LgsXNY3Vz3OSQAOIWzTC8D/qZo/
         sFkq6zcsBThUkWMo3gAlcI4koR2PoAcU3KDInnpaiIjqHsgaqq7TXN56X2aWsUyWxyfw
         ukNKXMZKwmhWbJs5/KVOSMep7FN5jKoKrSMAZpXzIhuQ/t4LKH+Qs7rNx8BRhuWz5/ja
         GbcQ==
X-Gm-Message-State: ACrzQf1sHwVMCyNJr+CYiEx7DdltXF8l3pm3aJc1kdQYIbOKMrgx+Fks
        S2pezsKhdhyoXYW9zOzKv16Aew==
X-Google-Smtp-Source: AMsMyM5e16KVl636iqXjznnxCJ/09cGYuH7oJqwEWZV3tVNlOZqH9oyADhcCg6i0sM27Q57OJEvFlQ==
X-Received: by 2002:a63:1110:0:b0:46f:b040:f5a with SMTP id g16-20020a631110000000b0046fb0400f5amr16800208pgl.84.1667421507320;
        Wed, 02 Nov 2022 13:38:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902ec8500b00177f82f0789sm8763054plg.198.2022.11.02.13.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:38:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqKVD-009VtW-Na; Thu, 03 Nov 2022 07:38:23 +1100
Date:   Thu, 3 Nov 2022 07:38:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Lukas Herbolt <lukas@herbolt.com>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
Message-ID: <20221102203823.GW3600936@dread.disaster.area>
References: <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 01, 2022 at 12:19:06PM -0500, Eric Sandeen wrote:
> From: Lukas Herbolt <lukas@herbolt.com>
> 
> As of now only device names are printed out over __xfs_printk().
> The device names are not persistent across reboots which in case
> of searching for origin of corruption brings another task to properly
> identify the devices. This patch add XFS UUID upon every mount/umount
> event which will make the identification much easier.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> [sandeen: rebase onto current upstream kernel]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Seems harmless.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
