Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C39EB64D7
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Jun 2023 00:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjFQArs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 20:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFQArq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 20:47:46 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199E3AA8
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 17:47:45 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6b2f0a140b7so1103192a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 17:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686962860; x=1689554860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=thGgBbDwZkxUx0XWN8Af4w6mTX1kBxfVqvWZChl5hmU=;
        b=pUDfO7w/vVD7Az2ZGmdF7OdLDPpOvr3KIH7tCmaEh94ojI+L82mJu56KS2dkJRhaZb
         XZlofgSaiO7AJBB0+qefSzG86aKEUrvXVPITaggVVwf2CGeEOSP2xvDpQLPHsBN2Ny//
         PNCp2lU0615K2v7NLcPJzx/IJ1/FqpOhl6OFQs8vaQINcGWVWQl8ZVw+LS5rRnlD5AMP
         eML+hExhf6RwXQ3FHUNpMqTKLeYrl8biVFdZ7WKMhfZVGD4Fdn3sfFDuI1KaXdzxQZTk
         JPW2fusyGx2RmJoGuNCPEVRpIgS+BiAsmhRi2X+UX1TmSz3wArxvWYalnCXB9Mny/zv9
         qYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686962860; x=1689554860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thGgBbDwZkxUx0XWN8Af4w6mTX1kBxfVqvWZChl5hmU=;
        b=TZprxNcBVGYu1g5QNnHfq1239arb49zu+5QoMvr87qBNQUKxeL10QKx6nFSKGrEG4p
         +KEquJh94Og5TtEirQuorwFsjEM9yHC6jHEZNnrqoCSwHw3+T/vjsYiSVFzYZdMoBJvv
         d9opTVnTlGTa1LX/aKBeX6q1jahnB4mWUJ1rR9y8ez1rxo9xuMfBIvZi3gvjB9gnFu8A
         IeEzZ30ojQie5RFWt+qQhVhcNrREevF1IkOf0MKxl/YWETu/mvMbwcsCjb0/nVyBr4gz
         B7ll9dfPsB7OxtQ+AZehohKxgxyN3CMee7s5EU+Ekub3ojELlikATmchaLXeYFysW80n
         d+ug==
X-Gm-Message-State: AC+VfDxRXPCyZckwGo0mCwq+st0i0GVVXjWwKmZjpeCjUGydSiBOUdjU
        yTDu/WG2cyT/kWZjtbCIxI7v2w==
X-Google-Smtp-Source: ACHHUZ6rLTBwPZ8yl+yD+k2Ubp5T/MhQbCjIZqW5llPf25Tv4HqBTEB2Q7Lm+CXI4ZWuo2ktE5/x+A==
X-Received: by 2002:a05:6358:f16:b0:12f:2815:fecd with SMTP id b22-20020a0563580f1600b0012f2815fecdmr794904rwj.9.1686962860267;
        Fri, 16 Jun 2023 17:47:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id r21-20020a170902ea5500b0019309be03e7sm16339328plg.66.2023.06.16.17.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 17:47:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qAK6K-00Cfln-2p;
        Sat, 17 Jun 2023 10:47:36 +1000
Date:   Sat, 17 Jun 2023 10:47:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Message-ID: <ZI0CqJR5k/CAZkD1@dread.disaster.area>
References: <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
 <ZIuqKv58eTQL/Iij@dread.disaster.area>
 <903FC127-8564-4F12-86E8-0FF5A5A87E2E@oracle.com>
 <46BB02A0-DCEA-4FD6-9E30-A55480F16355@oracle.com>
 <ZIwRCczAhdwlt795@dread.disaster.area>
 <B7796875-650A-4EC5-8977-2016C24C5824@oracle.com>
 <ZIziUAhl71xz305l@dread.disaster.area>
 <B8A59418-0745-4168-984F-5F9B38701C1E@oracle.com>
 <DBE6AA99-C1F7-4527-BAAA-188EAA29728F@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBE6AA99-C1F7-4527-BAAA-188EAA29728F@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2023 at 11:14:51PM +0000, Wengang Wang wrote:
> >> 
> >> So, can you please just test the patch and see if the problem is
> >> fixed?
> > 
> > Then OK, I will test it and report back.
> > 
> 
> Log recover ran successfully with the test patch.

Thank you.

I apologise if I sound annoyed. I don't mean to be, and if I am it's
not aimed at you. I've been sick all week and I'm pretty much at my
wits end. I don't want to fight just to get a test run, I just want
an answer to the question I'm asking. I don't want everything to a
battle and far more difficult than it should be.

But I'm sick and exhausted, and so I'm not caring about my tone as
much as I should. For that I apologise, and I thank you for testing
the patch to confirm that we now understand what the root cause of
the problem is.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
