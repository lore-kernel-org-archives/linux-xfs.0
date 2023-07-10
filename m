Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CC1EB64DA
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Jul 2023 19:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjGJTc2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 15:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjGJTc1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jul 2023 15:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C626BC
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 12:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689017501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RAYTaIQkXbY6ZRoVxd8ENSJnQxncIPDbKGiAypV7DvI=;
        b=eG1n92RtjGHVTErrQkcD8jhL7NVsHyTIfKvUIEZdGm1iiZE/VuoRdQx+wj3/6Sf1ACqw0R
        5FH8dPqqDELUlr6UPvcto0woEVHoLbEGIZ+/zIzPEoYo65F6aRItXZTkbECeEONQgXnv74
        giRmgh8f7qOwVXbwjF6BcDrSMBmw4PA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-Dbjo8PaDP_WU5OX4OcSHAg-1; Mon, 10 Jul 2023 15:31:40 -0400
X-MC-Unique: Dbjo8PaDP_WU5OX4OcSHAg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-636073f0ebfso43157926d6.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Jul 2023 12:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017499; x=1691609499;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RAYTaIQkXbY6ZRoVxd8ENSJnQxncIPDbKGiAypV7DvI=;
        b=Ku/y+k7ShGSSwBQi70gVoyiJdF4TY2dBa2YjZC74ICHvdSt/HLtEFzDzJ6wQnk+I29
         TAoUi72+G8Q25fVONzAMcDZSG7ChlbAXctzsuuaXFMLqNGv2CMS6yR2AiNLKg39z90hC
         ho7tBKkoxbynN9MZPRjmNbsq/63eCSkt4CD0GHSspWVic/kuhCWimlPXFmrHherUicAj
         lJdv7WOS3w4ERhuVTckBFJBhqiUedw/5k4IUoRqxku1p7D0eeA9KBUC3gyjREEXfoZq0
         2XakoIeiY2IWwomhzzTkTXGm4J4ZnW1dJ7njpoRfQR76X0Qthqo8zWnQpy9Z8Y2EjFYX
         Fy+g==
X-Gm-Message-State: ABy/qLaTf2eAuiLdR9cciwK1ZixSBZ78f+UUwaVgwfqrwnaLR9naIzQ5
        CNx8Y1PKiyHtsTrFLPCNrqEfSlMGOl14kCzCD9/ztDuURkEaopuDXRCtRUXCWdde2XStdT+zwqx
        hG6K+s0zHCP7Ct6k89vprrFxNKsY=
X-Received: by 2002:a0c:ae89:0:b0:626:33bb:3fd3 with SMTP id j9-20020a0cae89000000b0062633bb3fd3mr11322364qvd.19.1689017499678;
        Mon, 10 Jul 2023 12:31:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEq02GstuJh5Poau/MulKYC6as1BZdI/s4xkykrIHe3BZOKUTqjN6M7/9YpY4NO+pYvJ+octQ==
X-Received: by 2002:a0c:ae89:0:b0:626:33bb:3fd3 with SMTP id j9-20020a0cae89000000b0062633bb3fd3mr11322349qvd.19.1689017499328;
        Mon, 10 Jul 2023 12:31:39 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a20-20020a0cca94000000b00631f02c2279sm147129qvk.90.2023.07.10.12.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 12:31:38 -0700 (PDT)
Date:   Mon, 10 Jul 2023 21:31:36 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: remove bogus fstest
Message-ID: <20230710193136.44xdkhvozigznh7m@aalbersh.remote.csb>
References: <20230709223750.GC11456@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230709223750.GC11456@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-07-09 15:37:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Remove this test, not sure why it was committed...
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/999     |   66 -----------------------------------------------------
>  tests/xfs/999.out |   15 ------------

huh
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

