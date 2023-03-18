Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE99BC6FD1D
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjCRAnB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCRAnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:43:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ADB4AFD6
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:42:59 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id om3-20020a17090b3a8300b0023efab0e3bfso10819085pjb.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679100179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lXWFpaE7mm/thOZ6XMLftNirYIw+mKgKenmQbtrInHQ=;
        b=6RAP2tCZTyOV6U0xvD++4EbR+GVXmEKNKFW5FwvUxapRd8MbjGQcp48uhxX5DoDic8
         9LTQh/+89SefNu1CqvGbz2Iw8NUgjzRiw7+RcjndCkXfsFcj/p5XvkKAXZBQRPylW4Dy
         xtUVbjfrvBFy8Y/ah7TOHEzl7J9xT7s22aMbYSzlHxOL4JuvPFppSV5Ex/teuoPDZGeN
         P0qcG3oWHpKcp+O9B5Ga38GxtXfYpubMYvJr/2rjX32MX02zhktX3HbqOjBb9AfURSyw
         PBIupzDm1BsAsbCpxflvgCEuEp2QRj8QKsd4YfTNcA3aZrjF40Ut8v/Lo0jZutYnIwHY
         IZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679100179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXWFpaE7mm/thOZ6XMLftNirYIw+mKgKenmQbtrInHQ=;
        b=q6L4zIaH3b58wGrFyw6yUKmk8ygTGqVik6wXKyo3VVpbd1oy0hqXhtXQyc56LlNtrm
         tooqk7kWAy+Oov0hLIC8Ck62Yu2B4NAkPut35HtE1eAEPXas4kFZFA4ChBCI4YeaytzE
         wulnavt/UvJB/ab6srRxLRW45Kf0yP3I3MSL5EeIiBuVM/xBrflDJr8fp13PgyanKC8N
         MgskUuT25AWXHCv/NPrlFy+e3NgfJMBfezEsN0SxWpdRpObdTLKBDTtqsjBrtz8eZZoT
         UGvknX7aSQKbj/W2ZNzNDIn5P8tyy5kh4SfrdHppRT350FQwEfIAEwtcV035pTkvRgbD
         pPaA==
X-Gm-Message-State: AO0yUKWSXGHGVRPixXbawHEV4acURXJm0bi/O20k7laeSe5K7rkbYLer
        Kr9uULOZUy+8EehxJF52szHIVVgN56WFQ6JEkIM=
X-Google-Smtp-Source: AK7set+v8i4rosPHiPbWl2ho7WtrZsANlHGiV3HhbKQkMmprzkarUTxgVCJuOeGRQ8+7oJqFKxXfKw==
X-Received: by 2002:a17:90b:3a87:b0:23f:ef7:7897 with SMTP id om7-20020a17090b3a8700b0023f0ef77897mr9955874pjb.49.1679100179113;
        Fri, 17 Mar 2023 17:42:59 -0700 (PDT)
Received: from destitution (pa49-196-94-140.pa.vic.optusnet.com.au. [49.196.94.140])
        by smtp.gmail.com with ESMTPSA id ij8-20020a170902ab4800b001a065d3bb0esm2079127plb.211.2023.03.17.17.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 17:42:58 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pdKeu-000JDd-0y;
        Sat, 18 Mar 2023 11:42:56 +1100
Date:   Sat, 18 Mar 2023 11:42:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test dir/attr hash when loading module
Message-ID: <ZBUJEJ27tNWDmdxU@destitution>
References: <20230316164826.GM11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316164826.GM11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2023 at 09:48:26AM -0700, Darrick J. Wong wrote:
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
> outputs for a static pile of inputs on various platforms.  This will be
> followed up in xfsprogs with a similar patch.
> 
> Link: https://lore.kernel.org/linux-ext4/Y8bpkm3jA3bDm3eL@debian-BULLSEYE-live-builder-AMD64/
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I'm going to trust that your binary tables exercise the hash in the
manner needed because I don't have time right now to manually
decode it. With that caveat, everything else looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
