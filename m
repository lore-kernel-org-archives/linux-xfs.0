Return-Path: <SRS0=mmaA=6Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EBEC3A5A9
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 08:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E4621582
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 08:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9Hg1kzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEBI5z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 May 2020 04:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726741AbgEBI5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 May 2020 04:57:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8BFC061A0C;
        Sat,  2 May 2020 01:57:54 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so5761489pgl.9;
        Sat, 02 May 2020 01:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CxqauPPQOmctuxrVdiCLcsfetiYJdmmz2EMMFCRLInI=;
        b=c9Hg1kzmLnzzKJy7eATuX+ZL6gaW6XtQtcYcZIYc2+m5k565bjupKMQ67+GmwgC9N3
         NZX96SMUOrxTYGKIHEok5jlMMeQzrFQYdRzRW17z6Z0pK15mp0sBO6lrcoD+roj74sha
         ycTFmXu/GoOPC7aUCOHzF1oDF+XyP6r6wr/CTkQFILEJC3mtwJUQHBariGOnmNoeXPyo
         EOyAlnE9o6WMlfhEX4hgU4du1634PSsnnFCCsJGwdlHi2T59zL1WsUtqq6s9p42PuNPW
         iQ5zoc20zUPKpVGCbcbkygRjeaoE39INCXv2HFWcmENxfr+tKrhUp87YVYvohg+qcTwS
         T90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CxqauPPQOmctuxrVdiCLcsfetiYJdmmz2EMMFCRLInI=;
        b=MbNyX+gHG2NDQ652rKtexLUKT648by1mn5uDUlZO3xlANVYie/aYNTNyq39V23BuIh
         MT+CvRfeECq2eCk8JedoLBeEJSm3jlStUjx9G/AZ7UbwvbDQoHkgQFHO0r40rJ3XuzGn
         tm4mdO0V6eenH4g00oZvSd+NcPhsbrAt0p5CADXjsP/PXWIo11/gB7zN+9KbRfnP1lfl
         nZGAgG5KLgFy2iEMExiTCtgu3Cvu7SkDafZiTYtQh4bPkOtmuFkVR93DI0b80H8TNTMF
         MI7orQffQC0Nuu1IxiLeUGL4dtF7cS7YYWio16TkFP3HFaDXx764/i+/fa27bx6Usgck
         Clrw==
X-Gm-Message-State: AGi0PuZ/YZ87en8fGQogc0XgqmWO0IPziyYmYH3dQFJ6I/ImBKYEwT2R
        DPezqDhYxGGDyiZJIGqOd+c=
X-Google-Smtp-Source: APiQypLdymm8Tc66/Ky0UlyOG+4GPnuVllad082xTUrejNIYOwcCBOi1BxsPBsbmhqxhPdL7ijK7eg==
X-Received: by 2002:a62:81c1:: with SMTP id t184mr8007784pfd.236.1588409874264;
        Sat, 02 May 2020 01:57:54 -0700 (PDT)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id f99sm1713269pjg.22.2020.05.02.01.57.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 01:57:53 -0700 (PDT)
Date:   Sat, 2 May 2020 14:27:47 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Chiristoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Joe Perches <joe@perches.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Use the correct style for SPDX License Identifier
Message-ID: <20200502085745.GA17862@nishad>
References: <20200425133504.GA11354@nishad>
 <20200427072527.GA3019@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427072527.GA3019@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 12:25:27AM -0700, Christoph Hellwig wrote:
> On Sat, Apr 25, 2020 at 07:05:09PM +0530, Nishad Kamdar wrote:
> > This patch corrects the SPDX License Identifier style in
> > header files related to XFS File System support.
> > For C header files Documentation/process/license-rules.rst
> > mandates C-like comments (opposed to C source files where
> > C++ style should be used).
> > 
> > Changes made by using a script provided by Joe Perches here:
> > https://lkml.org/lkml/2019/2/7/46.
> 
> Please use up all 73 chars in your commit logs.

Ok, I'll do that.

Thanks for the review.

Regards,
Nishad
