Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAA0EB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 03:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjFVDLx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 23:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjFVDLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 23:11:52 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DE42100
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:11:43 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-668730696a4so2684210b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 20:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687403502; x=1689995502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AK6kc6f3SjMCn+mwnQVI6VZ+aA4NDV3xaRl7gcOERqc=;
        b=Axki9WoK3tuI9wqONDdFJUxHWq5zJs3OZXH6xsRhoruM6OwRkxq2ymE/wxZ7Bybbxd
         r0NldwYrJ+JaYSR06NmUuHJA8ULkGEhD4ebjydLvB7cOzparMdzXj72OqomX3DDSSXxR
         6i3heSw1e5kygLkHyMN6uH2wKmfGXNlLHvsNu5MFoMyPKUnE5sVEQCWzJATUk3oabHMJ
         v/fZZ38yO5+SEJRPqquVVVgIuFgpi98HQMC371CBWA0xIkZY0PJLPdSCXozdUYo1Bx7N
         TN8wp8FK4iM37WIUE3noaRruah8rVCXHuXjCfJ38gtoZS7NQ4oZ223BXKHb/BDNcrr8j
         mwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687403502; x=1689995502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AK6kc6f3SjMCn+mwnQVI6VZ+aA4NDV3xaRl7gcOERqc=;
        b=aXf6t4JpdxV6KI5rHVNak+btbqAefNS1oVTHPxZBNGS6EtfHyZs5SbdmKiHkhRx/vf
         XF7HqkAKgjagVEKLT7vWpnz8piYgGtr7cc7zMSTs6bmfFKew1fNRnT4CusfbUEXElq8N
         IwstRRSIQ2LbN3H2foKgXz2Xc2wAK+JnkmR0kdu+Xpx6xTIVLXC4X0bfNFiBv6sUnWCO
         dFAniDLUYuPWt1aCqpxviNGCazF6qrfPp7CyQFEFRdzNeQQqMVnhBOcnqO3fsFlFcgsv
         NVaIDg3bkBAB5PNfXdPCHKJHi+ZnAMOvszrVe8thruUOlB2hZBJ3veBl0a7tmryIkAFt
         u7SA==
X-Gm-Message-State: AC+VfDwmayaj9lJDvspTTaZ3E9i0mGhetrpA9K2ZXdOk3SgQyIWRxOAJ
        8hpJUK1wR2+YvaC6Ar35xhHjU45ctWFz0QC/l1Q=
X-Google-Smtp-Source: ACHHUZ5zV2XYcafEjLarRdcUcLrqt2j/scQnAei8S/+EAFkoMx1PlX0SET/AUYZ58jrZhRdqL6df8g==
X-Received: by 2002:a05:6a00:1784:b0:668:7ccd:a207 with SMTP id s4-20020a056a00178400b006687ccda207mr10046723pfg.6.1687403502463;
        Wed, 21 Jun 2023 20:11:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id p18-20020a62ab12000000b0063afb08afeesm3517224pff.67.2023.06.21.20.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 20:11:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qCAjT-00Eguf-00;
        Thu, 22 Jun 2023 13:11:39 +1000
Date:   Thu, 22 Jun 2023 13:11:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v25.0 0/4] xfs: online scrubbing of realtime summary
 files
Message-ID: <ZJO76sENpyYsqflz@dread.disaster.area>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506056859.3729869.14765688109434520098.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506056859.3729869.14765688109434520098.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:29:11PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This patchset implements an online checker for the realtime summary
> file.  The first few changes are some general cleanups -- scrub should
> get its own references to all inodes, and we also wrap the inode lock
> functions so that we can standardize unlocking and releasing inodes that
> are the focus of a scrub.
> 
> With that out of the way, we move on to constructing a shadow copy of
> the rtsummary information from the rtbitmap, and compare the new copy
> against the ondisk copy.
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
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-rtsummary
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-rtsummary
> ---
>  fs/xfs/Makefile          |    6 +
>  fs/xfs/scrub/bmap.c      |    9 +-
>  fs/xfs/scrub/common.c    |   63 +++++++++--
>  fs/xfs/scrub/common.h    |   16 ++-
>  fs/xfs/scrub/inode.c     |   11 +-
>  fs/xfs/scrub/parent.c    |    4 -
>  fs/xfs/scrub/quota.c     |   15 +--
>  fs/xfs/scrub/rtbitmap.c  |   48 +-------
>  fs/xfs/scrub/rtsummary.c |  262 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/scrub.c     |   17 ++-
>  fs/xfs/scrub/scrub.h     |    4 +
>  fs/xfs/scrub/trace.h     |   34 ++++++
>  fs/xfs/xfs_trace.h       |    3 +
>  13 files changed, 410 insertions(+), 82 deletions(-)
>  create mode 100644 fs/xfs/scrub/rtsummary.c

Looks OK, nothing screams out at me that "this is wrong!".

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
