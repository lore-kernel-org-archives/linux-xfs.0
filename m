Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E06F7C71153
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 01:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbjH3BC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 21:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbjH3BCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 21:02:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C3E1BF
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-68c576d35feso2123548b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693357317; x=1693962117; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZS+ro3hnJT+F2EuJzD8qwTtt1ieU4aDrIShCqeJ/UZY=;
        b=m38QK2YXNjhwCYlWLb8Nw38UykY/qPZ9Q7z5mdeOVQr7HfnCXYMyqRVXUJnAeSjDyA
         n/veRCTanIfvpthN5e7TZUPVlSqz/4E5jeZY6LU7QbVzmQuwLrpLbyHsqpGRJnh9iVmx
         l1YzKHoY64P6GCaRRsTnuD/XM9cWnpzv7J5+RdIagROxV8k5xKQsUSNt7D9DpS+/fHM1
         auG3XT259UeT69hrjjW/LZTYV04PeXWEc18XM4Qu+RP5qzlZjZ8VWqrJ5cvzFZH0kgEm
         JmpeJbCBC157BtEU/UqYpdcIAIymOZ5qm2fRBIa2FDaEniukE5ZF4UiZwzDmHSDvE8Y4
         r+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693357317; x=1693962117;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZS+ro3hnJT+F2EuJzD8qwTtt1ieU4aDrIShCqeJ/UZY=;
        b=jDyD/ZGOIgAcmW7Bkma3k5Vdpr6IiT7WjDP2a5+ZXlHzY0YBzD3tURNcqz+4bZyT8m
         l+mXw+P9S2v95JGhl3bCswMGixjsANIVezJGFu2Zuk22RZbWmLu+/KBQlWZ2peC/eFKn
         c0If9TuX9wij/FYWeeM0LFh3Sv8+UsD6P/B4uzTl41P1qd5VIvHrZV5Cf8F810tTr2gy
         Gck1wS7Fd+41VxdZVk3zgaiPw4ePT6SHg+pEMYIRwRzeJIYGaq4sJk9wi4LLYhz7wyH2
         RHN+W8RL15fPOoJhiG3y1Ok7x9tb0/CrVJ3DBvVET5xfHkfFBog4Fv+61Pl1DScWaAS5
         pKdA==
X-Gm-Message-State: AOJu0Yzj6zaLazGo9gqTb1tTm5mnI2AOxDwsymtahHSCVOcwSAWX2sde
        vqnu49EPkopA/ztEIE2RWhywdQ==
X-Google-Smtp-Source: AGHT+IHizfVQ0ukIvoYDQVNltW5sZzV9NL5cioiKuKL3Y+qpTho5j5MeF5mYfOZE7dqxDRNFxLbRBQ==
X-Received: by 2002:a05:6a21:81a8:b0:14b:f386:f6fb with SMTP id pd40-20020a056a2181a800b0014bf386f6fbmr853117pzb.35.1693357317235;
        Tue, 29 Aug 2023 18:01:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b00198d7b52eefsm9964942plg.257.2023.08.29.18.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 18:01:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qb97n-008IZC-1G;
        Wed, 30 Aug 2023 10:31:59 +1000
Date:   Wed, 30 Aug 2023 10:31:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 2/2] xfs: fix log recovery when unknown rocompat bits are
 set
Message-ID: <ZO6N/8JBzF3Ev92x@dread.disaster.area>
References: <169335056369.3525521.1326787329447266634.stgit@frogsfrogsfrogs>
 <169335057499.3525521.13864967150156919137.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335057499.3525521.13864967150156919137.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:09:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix log recovery to proceed on a readonly mount if the primary sb
> advertises unknown rocompat bits.  We used to allow this, but due to a
> misunderstanding between Eric and Darrick back in 2018, we accidentally
> changed the superblock write verifier to shutdown the fs over that exact
> scenario.  As a result, the log cleaning that occurs at the end of the
> mounting process fails.
> 
> We now allow writing of the superblock if there are unknown rocompat
> bits set, but only if the filesystem is read only.  Hence we still have
> to remove all ro state toggling that occurs around the log mount calls.

APart from the wording of the commit message, this all looks good.
It took me a little while to parse what it meant paragraph meant,
so can I suggest something like:

	Log recovery has always run on read only mounts, even where the
	primary superblock advertises unknown rocompat bits. Due to a
	misunderstanding between Eric and Darrick back in 2018, we accidentally
	changed the superblock write verifier to shutdown the fs over that exact
	scenario.  As a result, the log cleaning that occurs at the end of the
	mounting process fails if there are unknown rocompat bits set.

	As we now allow writing of the superblock if there are unknown
	rocompat bits set on a RO mount, we no longer want to turn off RO
	state to allow log recovery to succeed on a RO mount.  Hence we also
	remove all the (now unnecessary) RO state toggling from the log
	recovery path.

Other than that,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
