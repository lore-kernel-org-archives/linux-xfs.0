Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B7EC76196
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Apr 2023 22:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbjDCW2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Apr 2023 18:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjDCW2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2023 18:28:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836402D4C
        for <linux-xfs@vger.kernel.org>; Mon,  3 Apr 2023 15:28:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so34144380pjt.2
        for <linux-xfs@vger.kernel.org>; Mon, 03 Apr 2023 15:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680560890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5dzap7r4jEPxcS1DyxxYKTpwsNWfywPsKJXvqVFzSlA=;
        b=FZ3vwXDNxQKu7SX+zG9IyIBc6YwP0FvH5ZQAxiJAYpN0YjWwJKpUkDqKymsVbfDPDc
         xkf+RB+PtvQ+ZDOx0roiiGX023VwrNk4EFC8Ca/zFhNJoNHGwyH53LGH2n3SoQKWhv53
         +XLsxH7/iEDBu7kEAyIlXaJHUWvPSiJxdJ9WU/n6BE2lqGII4Lgai8DpdGKGmpQBcn5H
         t7n2PEPCSiwI9cqaUo/xu/6Xnqsey8NjX/ASHcHpbCqe8grQWGk4i79+j82sjKZGQ5Np
         9xx8gKLnWmQFfu7m7EfeXwMK00KBSK9iuASMhxgMas0cjfVPFzVFWXEKAitbNswF93Vy
         KemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680560890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dzap7r4jEPxcS1DyxxYKTpwsNWfywPsKJXvqVFzSlA=;
        b=AKIOTd7pZ5FKZYcDDgPUaLFVE5eRWxLCjo9pD0oOPZNfXLfKVvKghgMThOKAklKTxT
         YQ0wxvLjZw/9T5YaXNlth5VCwh7mVKSR/bKjELElGdzAPcNjRjYiRoYaPGPGnE7Sr8HJ
         9IUZmZsqk42lmVYe0FaxxIRlEiuyyFhjph1Wx6l3jjty77bwYHQRISoTs+6Kyl56crA9
         ioVBImDyJTdaVafdWfjXkq29h8xberUloeGusMi90wNf3WgIM6WLFP9mqofBNLpgkJRy
         FrBUbdMd0WVqvwbtMrfUX06EzZWP66MAdcVQLQI55XzRCoJ4WccoBq7jQwqkUFAWY92C
         Ds+A==
X-Gm-Message-State: AAQBX9cakRlxBSHgaSMUBXdo5LjDMszRjqdsJAkbvmdgbcnoQGdJJDu7
        LfTtWkfadvbHKjQGDbHYha1bHffRAd0TIeGHjG0=
X-Google-Smtp-Source: AKy350aT+Bq2Bhz0AEi00Ztv0JaPfPTbmzO+9WHFY+ju8eoUsNQUWsNI7T2IS8sTu41DMOQ21QcP6w==
X-Received: by 2002:a17:90a:df86:b0:23f:8b1b:d7fc with SMTP id p6-20020a17090adf8600b0023f8b1bd7fcmr21152716pjv.15.1680560889915;
        Mon, 03 Apr 2023 15:28:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id gx3-20020a17090b124300b002311c4596f6sm10080590pjb.54.2023.04.03.15.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 15:28:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pjSej-00GhhE-UI; Tue, 04 Apr 2023 08:28:05 +1000
Date:   Tue, 4 Apr 2023 08:28:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Shrink support?
Message-ID: <20230403222805.GJ3223426@dread.disaster.area>
References: <e19e642a3b5faeccf51db4e04bc845d6@karlsbakk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e19e642a3b5faeccf51db4e04bc845d6@karlsbakk.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 01, 2023 at 12:35:01AM +0200, Roy Sigurd Karlsbakk wrote:
> Hi all
> 
> Was it something I was dreaming or was there shrink support coming to XFS?

It's a slow work in progress. Don't hold your breathe waiting for
it; there's still lots of intricate infrastructure stuff that needs
to be done before we get anywhere near being able to shrink the
on-disk filesystem...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
