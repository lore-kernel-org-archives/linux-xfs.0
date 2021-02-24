Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660A1C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 03:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F24FF64E2B
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 03:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBXDKn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 22:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhBXDKm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 22:10:42 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77188C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 19:10:02 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g4so571866pgj.0
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 19:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=F9pj/Yt9KqTFsOfQSkWuMZ91EvZ0O1vUGeWGb7abBgs=;
        b=vaVqGB5DOwLDXGdra9P0bbpRQjS/NO0UFgTBS6Q6Y8zblalA60/4sl17vVVFftrjuh
         M7QO68yhNxJildKs5IE6RabjSnljqDSqokNsvt+DcMYSeQrz06rozYaHNVTuboc6aiqY
         8c+uPK3BHVyElPqpCpGewZClIzSpCxS//GUytEtmAFHWgn5f21J1VrssTu9/Y4hVjYI5
         r5B4HSTOVGYH0Q1bBim8tH6d2dHO+Bd4se8/CUPYCq8PRITUChl64fy440IGJJ5OG1/n
         zMF1mShR/3zgfDUBQc/dnCraxkmQ+2zGP5ozwNAJazGU6p91ro7Ez7621S2sahTfuAem
         eqJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=F9pj/Yt9KqTFsOfQSkWuMZ91EvZ0O1vUGeWGb7abBgs=;
        b=Mc0hHXXzz3IoiMZxFtnkE1AqpfelqyyqvmthkIhRsund49sKT7a/nKFesjuP8Jkmy1
         TSTYvXgFzRV3BrUn1ImWeOJoqDZLdZGy4Xwjh1SMuah1qGIWV/wAjVCk0zlXALzyWA6C
         n2IL11qa51AIlssy8v9MFY5aNVEP5H4HHRa+ohNNQ/6AYMkhSBZ53+Xr0uZ8+6lQ1KKl
         52cVC9u5WF8bI/UyjawPiYo903Tl4+uR9THZDsHtEZLchn+u8MykTuM7v2G1Y0XaMBes
         0ftcLY1mN1z3SSboqdpjc+vGnwNi5QRSeeIMiB5xVXJjGWWylspX+HA+dCj/tECFyL2j
         H+1A==
X-Gm-Message-State: AOAM533nEWkpSlKQ/ShtfB+rryUA5CgHVQnhZLGvABumBg1QMJuSynmU
        kwoliVqTR58efjBvVpzk+JOJcFk1lz0=
X-Google-Smtp-Source: ABdhPJwf9uaVGOPG/U+RLF8JeH+nKC14lt9heXepDH32zL3DjAqvWmW/5YENRM/wZldi/dNNly1xEg==
X-Received: by 2002:a63:e614:: with SMTP id g20mr15564075pgh.275.1614136201681;
        Tue, 23 Feb 2021 19:10:01 -0800 (PST)
Received: from garuda ([122.171.161.92])
        by smtp.gmail.com with ESMTPSA id 14sm581083pfy.55.2021.02.23.19.10.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 19:10:01 -0800 (PST)
References: <20210223082629.16719-1-chandanrlinux@gmail.com> <20210223203013.GX4662@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Allow scrub to detect inodes with non-maximal sized extents
In-reply-to: <20210223203013.GX4662@dread.disaster.area>
Date:   Wed, 24 Feb 2021 08:39:58 +0530
Message-ID: <87mtvu17qx.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24 Feb 2021 at 02:00, Dave Chinner wrote:
> On Tue, Feb 23, 2021 at 01:56:29PM +0530, Chandan Babu R wrote:
>> This commit now makes it possible for scrub to check if an inode's extents are
>> maximally sized i.e. it checks if an inode's extent is contiguous (in terms of
>> both file offset and disk offset) with neighbouring extents and the total
>> length of both the extents is less than the maximum allowed extent
>> length (i.e. MAXEXTLEN).
>
> It took me a while to understand that what this is actually doing
> (had to read the code because I couldn't work out what this meant).
> Essentially, it is determining if two extents that are physically
> and logically adjacent were not merged together into a single extent
> when the combined size of the two extents would fit into a single
> extent record.
>
> I'm not sure this is an issue - it most definitely isn't corruption
> as nothing will have any problems looking up either extent, nor
> modifying or removing either extent. It's not ideal, but it isn't
> corruption.
>
> I can see how it would come about, too, because extent removal
> doesn't merge remaining partial extents.
>
> That is, create a long written extent in a file, then use fallocate
> to allocate an adjacent extent that puts the two extents over
> MAXEXTLEN. Now we have two phsyically and logically adjacent extents
> that only differ by state. Now do a single write that converts the
> entire unwritten extent to written so no merging occurs during the
> state conversion.  Now punch out the far end of the second extent.
>
> This ends up in xfs_bmap_del_extent_real(), which simply removes the
> end of the second extent. It does not look up the previous extent
> and attempt to merge the remaining part of the second extent into
> the previous adjacent extent.
>
> Hence, at this point, we have two logically and physically adjacent
> extents whose combined length is less than MAXLEN. This patch will
> now signal that as corruption, which is wrong.

Ah ok. Thanks for explaining the scenario which could lead to a false positive
report because of the code changes in this patch.

--
chandan
