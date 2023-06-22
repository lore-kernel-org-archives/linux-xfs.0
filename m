Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A4CEB64D7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 03:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjFVDN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 23:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFVDN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 23:13:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4002E1BD6
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:13:25 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6682909acadso2837633b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687403605; x=1689995605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HtM5z56/oWT+ryLH4JOoXRno2HnX4sd+5Fb00XQ2qJw=;
        b=SAp6yLCYhzbH8IxqHqi3xqhPjwFLGjTRmHnUmpTOQkDPPRnAGkPtQDne29LYHHec7D
         4Rdph2q21putAzzlgoE6URdfSmLjBle4sj+OqtsSaeiXK359uqk8oaPdozcRQ+6VflCm
         /MwUQn5zpOiaoukvnlKep6c7PjkkvZI2UheBlbx/Y2jim580e9f0iGzWXS3KwGq7IJts
         +iNNUv44ZsWvuo3i2/5PK+KGwYQxW7zAnkfITdo8hGZnlQgNHhL9kxc2G9jAjXn/YcJj
         OpB/w7ZOiGGS6Ax2BcfBTzC3LsnwvU7aiZtE2r1Hxz4F3QTPa+bRUJ0NlAoKL/o42CTk
         GR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687403605; x=1689995605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtM5z56/oWT+ryLH4JOoXRno2HnX4sd+5Fb00XQ2qJw=;
        b=dkVSMlMBIgzZxJSunnPO/YhOQJWHgpSKylAN2XDvUXQLDMC1qgwuXIuGwWhdv7J34S
         9wDfBKa4MSw3z0h6Rcg8k7nnSnbNKnUOYW3X2Skd0AHVmMkJ3iMPCX1+l5Ihe+qxFKhg
         PQLAV+FrOFEjKTJZbPYxD/QPL0ZrL/0ajsJM8a+zshK69aouqCGfqMyO4kxISZe+Ua+6
         4CYi1RrQTbV+lnep4FRQOSww7AtLQLCJ8Dkym+y2D4jEpHqMVbC98BU+sSbyg4xpAvCe
         oBEwUkEKS55yFqeaXyalYJ07i4lN4/Mh4/zQ1uReooNRK40B28HgFPLLL9wHDGW0MzNN
         lEKw==
X-Gm-Message-State: AC+VfDxkQjnOO8m9kKdFdriaBWbrLszFwcuJ5qYK/j9nn4y9KWk3BRZ5
        7JTXwX5OT9OBc02+x1FuslcoTWHYa8YT+Wvw2vI=
X-Google-Smtp-Source: ACHHUZ7Y+OQHADD4lXIpsIQlk3+kHdJ6yL883TOyioTuPBGsjq2514Sn1rOuvY0CnochzaNFvVy6ww==
X-Received: by 2002:a05:6a00:23c5:b0:668:7744:10de with SMTP id g5-20020a056a0023c500b00668774410demr9547859pfc.9.1687403604599;
        Wed, 21 Jun 2023 20:13:24 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id m25-20020aa78a19000000b0065e154bac6dsm3534887pfa.133.2023.06.21.20.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 20:13:23 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCAl7-00EgwB-1j;
        Thu, 22 Jun 2023 13:13:21 +1000
Date:   Thu, 22 Jun 2023 13:13:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v25.0 0/2] xfs: miscellaneous repair tweaks
Message-ID: <ZJO8UYwHKiRemLvi@dread.disaster.area>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506057223.3730021.15237048674614006148.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506057223.3730021.15237048674614006148.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:29:27PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Before we start adding online repair functionality, there's a few tweaks
> that I'd like to make to the common repair code.  First is a fix to the
> integration between repair and the health status code that was
> interfering with repair re-evaluations.  Second is a minor tweak to the
> sole existing repair functions to make one last check that the user
> hasn't terminated the calling process before we start writing to the
> filesystem.  This is a pattern that will repeat throughout the rest of
> the repair functions.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-tweaks
> ---
>  fs/xfs/scrub/agheader_repair.c |   16 ++++++++++++++++
>  fs/xfs/scrub/health.c          |   10 ++++++++++
>  2 files changed, 26 insertions(+)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
