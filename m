Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EEEEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 18:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjGLSqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 14:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjGLSqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 14:46:03 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7B91BF5
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 11:46:01 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-666ed230c81so6531169b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 11:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689187561; x=1691779561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5ESgLwwjyOgaa7waZDqp6ISyFEWOGjH/PD1F91g9f6M=;
        b=n8q8XOrclQbUsMCUl9XXfoma3EycOkjIuuAyNm3h6BnRAM1DT7ozfr4Q6fM2lag2DB
         a0Sn48SD4RRkziGSWehZ6yadUBxIV/9wMniScIatsg2oCjS4Q6SJt/kcWxGcL4Y6netE
         HxYBPr8BNF7yq49FB+JRj9SmNKfoQxUF97+xY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689187561; x=1691779561;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ESgLwwjyOgaa7waZDqp6ISyFEWOGjH/PD1F91g9f6M=;
        b=Hbgm/E5ZiQGMlWkP2BDu52/txVBHWoh9cL93DMYWUBinCVRtsOxvweo7r+GuC8Qj4K
         0NE5VZFKbZjeebHKNsvHf3GwIgVx7Ad9EHb70Vkj8ZB4gpS6Q6ao1z/flS3SvBqUQy3R
         qaRAAAN4mJtsou6FoPmZ9ZsJ2eLdJHapq8ADcATGdqWLAEiL1qFzKMX9SZmmOPAyMOrH
         Eqb/jWG2+ornGrILvN3iflKRFnD1MFmB482XHOsbrFf+xI8IcWqQAkiV/ZBhXDM1edOy
         yVMYQhnLZMWxWpQwPeBcE8yWMl+EKBtyhkXZbuybzqmqqFh1rA5JNnbCJuUdBgwHrkFt
         gC/w==
X-Gm-Message-State: ABy/qLZfqD99JHjt8QijQeqIRvl9Y7HUdh/WwC4YrAX84TTpupwhq6SD
        fKVjcwb5Q8Ga9hTJnr4RFlcRFg==
X-Google-Smtp-Source: APBJJlFzvJdaSCmR1hmoQv6bxltILaByXVBtKtyLjmWvOnnQmZj4URhBWGHlRBRKVFP6y0ghhl/Y0g==
X-Received: by 2002:a05:6a00:b93:b0:668:82fe:16f1 with SMTP id g19-20020a056a000b9300b0066882fe16f1mr24780472pfj.1.1689187560994;
        Wed, 12 Jul 2023 11:46:00 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id t5-20020a639545000000b0054ff36967f7sm3957121pgn.54.2023.07.12.11.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 11:46:00 -0700 (PDT)
Date:   Wed, 12 Jul 2023 11:45:59 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] libxfs: Redefine 1-element arrays as flexible arrays
Message-ID: <202307121144.855A9D9@keescook>
References: <20230711222025.never.220-kees@kernel.org>
 <20230712053738.GD108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712053738.GD108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 10:37:38PM -0700, Darrick J. Wong wrote:
> Here's my version, where I go for a straight a[1] -> a[] conversion and
> let downstream attrlist ioctl users eat their lumps.  What do you think
> of the excess-documentation approach?

This is fine by me, and I think it's much cleaner. Thanks for running
with this!

-Kees

-- 
Kees Cook
