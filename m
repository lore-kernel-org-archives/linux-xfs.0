Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129D0C74A5B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCRArh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRArf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:47:35 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F6E5A1AC
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:47:34 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s8so3994107pfk.5
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679100454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UsvbKD5bbwmTBy0LtqLFfOsIqdjnfMecFg11M+FIZjU=;
        b=fARxdYWPbfC7R9Rzx/+y/Ns/R6D79PD8ogKLtFzmF1aBvkya50USwF6kbaj1iDYudP
         FfreAUS7sr1eNwItz0laXrRb8RNMwBcKTRTwZwpOpgn4eSxL/u6DyfZaSkropauhZlsJ
         FYdZ/I+hs/3jQI2xKhoL0rOjz/MKFZIbMWewLVG5DWD8ihUREPt819TcTWWcc3AdQ5qY
         CLeF9gJzLkg1CloQuJaEcCH67C5cz4l+NRp+6HKKcF+rptlgG+kN6Wcsoa7qOuH5z4xm
         pfFIv4Z4aawWOCzs8r4B+E6SnKUb5Vmj5IZ1zz5u3aYDiEJxTk9zDw94e498/roq8DkB
         mbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679100454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsvbKD5bbwmTBy0LtqLFfOsIqdjnfMecFg11M+FIZjU=;
        b=oXXMmaEH6G3pUnqge3SdFg1vKzgn6bcwoT8avqaVPcm5vcH/IneZSWFDMDk+AqiF1q
         UcDA4+Tr3j7O9bOsrwL/IOmbcMcyV9xan/XAepkoUPH/8CqKr8ZFzZptUqKie2ghnDNn
         NMjPyKYgLTc0OdID1edSeG7nweY+VBWmaAPLapdTncFblSEvbaAir3PJp+PM1KbIAMeo
         jthKJJtWjKZ6kbXf9V798je+Ldcyqf2JK4+nv+a4+QTM4+eydPHCRqXw1E7Xwzqpn4qm
         VeC1XKoxBLela/bA4l9eHUY16eW0sj1Dc0v7DSw0E/GOWsawYv0Aiau9JqOMzSNhhi2w
         vefQ==
X-Gm-Message-State: AO0yUKVPJPJx3UrgnTTFuOu9SswFr6ac6czoW83v9yRoaVI/Ej/OJEgf
        UAQBoWLCJLDDYXbyqtRItU2oPA==
X-Google-Smtp-Source: AK7set/e2smWJ1pgQjg4XmOriqAQQbTb8nzks7/AnXKxxhPYycGcFvtnb7J+U8AI8wqdmqwxQBooyw==
X-Received: by 2002:a62:3803:0:b0:625:ce06:e58 with SMTP id f3-20020a623803000000b00625ce060e58mr7937808pfa.17.1679100453997;
        Fri, 17 Mar 2023 17:47:33 -0700 (PDT)
Received: from destitution (pa49-196-94-140.pa.vic.optusnet.com.au. [49.196.94.140])
        by smtp.gmail.com with ESMTPSA id v15-20020a62a50f000000b00592eb6f239fsm2103152pfm.40.2023.03.17.17.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 17:47:33 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pdKjK-000JLH-2h;
        Sat, 18 Mar 2023 11:47:30 +1100
Date:   Sat, 18 Mar 2023 11:47:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] misc: test the dir/attr hash before formatting or
 repairing fs
Message-ID: <ZBUKIjpwiPMzLp2s@destitution>
References: <20230316165101.GN11376@frogsfrogsfrogs>
 <20230316165246.GO11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316165246.GO11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2023 at 09:52:46AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in the 6.2-rc1 days, Eric Whitney reported a fstests regression in
> ext4 against generic/454.  The cause of this test failure was the
> unfortunate combination of setting an xattr name containing UTF8 encoded
> emoji, an xattr hash function that accepted a char pointer with no
> explicit signedness, signed type extension of those chars to an int, and
> the 6.2 build tools maintainers deciding to mandate -funsigned-char
> across the board.  As a result, the ondisk extended attribute structure
> written out by 6.1 and 6.2 were not the same.
> 
> This discrepancy, in fact, had been noticeable if a filesystem with such
> an xattr were moved between any two architectures that don't employ the
> same signedness of a raw "char" declaration.  The only reason anyone
> noticed is that x86 gcc defaults to signed, and no such -funsigned-char
> update was made to e2fsprogs, so e2fsck immediately started reporting
> data corruption.
> 
> After a day and a half of discussing how to handle this use case (xattrs
> with bit 7 set anywhere in the name) without breaking existing users,
> Linus merged his own patch and didn't tell the mailing list.  None of
> the developers noticed until AUTOSEL made an announcement.
> 
> In the end, this problem could have been detected much earlier if there
> had been any useful tests of hash function(s) in use inside ext4 to make
> sure that they always produce the same outputs given the same inputs.
> 
> The XFS dirent/xattr name hash takes a uint8_t*, so I don't think it's
> vulnerable to this problem.  However, let's avoid all this drama by
> adding our own self test to check that the da hash produces the same
> outputs for a static pile of inputs on various platforms.  This
> corresponds to the similar patch for the kernel.
> 
> Link: https://lore.kernel.org/linux-ext4/Y8bpkm3jA3bDm3eL@debian-BULLSEYE-live-builder-AMD64/
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libfrog/Makefile         |    1 
>  libfrog/crc32cselftest.h |   17 ++---
>  libfrog/dahashselftest.h |  172 ++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/xfs_mkfs.c          |    8 ++
>  repair/init.c            |    5 +
>  5 files changed, 195 insertions(+), 8 deletions(-)
>  create mode 100644 libfrog/dahashselftest.h

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
