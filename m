Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDD1C001B0
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 19:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236524AbjHHTj7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbjHHTjq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 15:39:46 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0866892B
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 11:00:40 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-563de62f861so3545029a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 11:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691517640; x=1692122440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDl/slbJs9D1xKHBPHbGK/INn+cIEpxTOdRZQgeyYO0=;
        b=qomode1iXGYc1B2ySxsLA1S8oYpqkBRfZef/E2CcQssBfOMbHQLLZs5WVtesWe0/4P
         QMC9TL1390FDFyRIIwgFUElFp76a+yreDACSYa0+RrC6eWAKX/DxyxkzgKuOs+iYk5h5
         b1u9N5/LXhTA2U+c4k9Qgks3GDsMzudWofnuwZlwyHTasXix61c5BQ3aUUCQmx1PmQ59
         D4IsWfv4vQAKnqb/OG6hY6AkHKWJfGsvskslZRauZtSjDp9oMKbLdE1mQSYwvTeXQt4p
         0SSQj1g3U+K3GaDpN+ZSkksJB/vbHw6POjVqEGLwG7AKjmhONgbaBVO/aV7V1etPthUE
         WLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691517640; x=1692122440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZDl/slbJs9D1xKHBPHbGK/INn+cIEpxTOdRZQgeyYO0=;
        b=SL0MoLGqHYyMu3X5k5t1ofH3owkRoVYQNjpKAsVLtBmc45lQUEET4lmWlHb+k9vaEr
         fb0G1Tf9zhYYmL0KpXegB+lty6hAew3a+2nz2RCo4+6wRhBG3AvSWQTngBtKThEFTmth
         SmJj+7kHler69xPDAs0nxAVchMIfXfxSdn1wUKcZB8+KiwQYjD66QcnLVNlQfITkDsjf
         gbM41P3y+DWE9W8jycgpH/WlWcC8ja95TZ1O3etvcIUGPClDgd7y+vnfty5oXJIbv2HE
         XCOqUqLUr/fxD6cebY/HAtvpc+aRdOfTDrTIlHNf/G9b4mLmI/KjpucD4caj7JaI0uBX
         ASwA==
X-Gm-Message-State: AOJu0Yx1SFsri5fQxmz632YqoZEyrHNofvYxorS7bLjL0niH8S7tDBRe
        uIJwJh30TEVUGeQCKHR2TPCZqIn2OM0ItZ5zAXA=
X-Google-Smtp-Source: AGHT+IFXn187w0E5tgoqmzdOZ+ABe7F+e3gdFsfzONbFjE0Qk42TXQW8ZKzCyruHnufi+wmHoRysWg==
X-Received: by 2002:a17:902:b20e:b0:1bb:6eeb:7a08 with SMTP id t14-20020a170902b20e00b001bb6eeb7a08mr10642011plr.10.1691478562272;
        Tue, 08 Aug 2023 00:09:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902f7c400b001b8a3a0c928sm8197698plw.181.2023.08.08.00.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 00:09:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTGqF-002c7s-0v;
        Tue, 08 Aug 2023 17:09:19 +1000
Date:   Tue, 8 Aug 2023 17:09:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v26.0 0/2] xfs: add usage counters for scrub
Message-ID: <ZNHqHzFrtyy/kBSE@dread.disaster.area>
References: <20230727221158.GE11352@frogsfrogsfrogs>
 <169049623967.921701.643201943864960800.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049623967.921701.643201943864960800.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:19:19PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series introduces simple usage and performance counters for the
> online fsck subsystem.  The goal here is to enable developers and
> sysadmins to look at summary counts of how many objects were checked and
> repaired; what the outcomes were; and how much time the kernel has spent
> on these operations.  The counter file is exposed in debugfs because
> that's easier than cramming it into the device model, and debugfs
> doesn't have rules against complex file contents, unlike sysfs.

I wish we could just put these in sysfs with all the other per-mount
stats files we have. It's just stupid to have to put them somewhere
else because we want to put all the stats in a single file and so
grab them with a single read operation...


Other than that, this series looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
