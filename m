Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4A5C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 01:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiKVB6V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 20:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiKVB6Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 20:58:16 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF3A2B625
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 17:58:10 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id y4so12259134plb.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 17:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K3D6CEDfNisMn5+Ij/yJFOz/DQ0YAfB3CAUOidai46E=;
        b=uF6w7xvZQ5gyICpDAKpJkbQLwZusZ9lkREv6/cNclwxhj7TnAnflb+svxwKsFxv+Rg
         PfkgV9kDl/dn7m7Dl57qvUbBtnMgRnpkdn6nomf02ylZ/sXAJ6rzAg/BLYSwP9yLZjAQ
         +aseA8Vebo9oNxPuaxiVk3x5g6rwxDUKqxy8zk7VPW7JASQLnr2nfF2fOXldClJ2dANs
         WwMYX6kzLjkay0psC5/PPPir5Kq+uLUiP1ZfK/lwNpMJgZpTI5L/e/Orw3RPSV32Pfe7
         tMgiAI7PD7JpNCNa21wjQRHxMtmQ8hAVgAFZV4hWfURLLOqXKxhAUxhZNlHwfg655qn+
         jlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3D6CEDfNisMn5+Ij/yJFOz/DQ0YAfB3CAUOidai46E=;
        b=ffAql4bY5Wg9LSbTZ8EWDrL3mU/xFQpkHE/xNztVe5xBX9dw/o5lhbiF9hbH8KyXri
         Ze385RNhUX1SMXV+oypxcOyyfvWxX3bqWgZ4F4z/zAPI5t0E9ZFs7miyWoHODlpwUVJj
         nGyGp3yHhIrePFKsGnaL58OGx3QWqK144ZJAsZzn8ED+M4Yx5S9DNFn90DCMQpgW1txe
         dLvd06YIX1lQp6Fj61l483jwXJcvj2UPXc5YDZR3vyQsjNQgnwRHhP9hQcIPkioIIzB0
         d8B8jCp+EmphaOBH131lTip52DFMskXCTbDL8MOVBEJxtgtYJLa0sf3+oNjZXttoF4RU
         UO+w==
X-Gm-Message-State: ANoB5pkkkLi0v3+H4xoMljOPsuMPvlKV3pRf60O/tFiojPdnz5H8ch01
        AIv7l0UHZkokHTmg546c/R7Hxw==
X-Google-Smtp-Source: AA0mqf6NgelLmy2OByyMK7BRtriqyMydNMV9sttc6ThtP9h4lQYoEL+UVhGk87LX1s9aZ1aoKHEalQ==
X-Received: by 2002:a17:90a:b906:b0:213:b349:143e with SMTP id p6-20020a17090ab90600b00213b349143emr23296338pjr.114.1669082290249;
        Mon, 21 Nov 2022 17:58:10 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903231200b00188f772a3c7sm9524326plh.99.2022.11.21.17.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 17:58:09 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxIY2-00H5wG-Mx; Tue, 22 Nov 2022 12:58:06 +1100
Date:   Tue, 22 Nov 2022 12:58:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: moar weird metadata corruptions, this time on arm64
Message-ID: <20221122015806.GQ3600936@dread.disaster.area>
References: <Y3wUwvcxijj0oqBl@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3wUwvcxijj0oqBl@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 21, 2022 at 04:16:02PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> I've been running near-continuous integration testing of online fsck,
> and I've noticed that once a day, one of the ARM VMs will fail the test
> with out of order records in the data fork.
> 
> xfs/804 races fsstress with online scrub (aka scan but do not change
> anything), so I think this might be a bug in the core xfs code.  This
> also only seems to trigger if one runs the test for more than ~6 minutes
> via TIME_FACTOR=13 or something.
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf
> 
> I added a debugging patch to the kernel to check the data fork extents
> after taking the ILOCK, before dropping ILOCK, and before and after each
> bmapping operation.  So far I've narrowed it down to the delalloc code
> inserting a record in the wrong place in the iext tree:
> 
> xfs_bmap_add_extent_hole_delay, near line 2691:
> 
> 	case 0:
> 		/*
> 		 * New allocation is not contiguous with another
> 		 * delayed allocation.
> 		 * Insert a new entry.
> 		 */
> 		oldlen = newlen = 0;
> 		xfs_iunlock_check_datafork(ip);		<-- ok here
> 		xfs_iext_insert(ip, icur, new, state);
> 		xfs_iunlock_check_datafork(ip);		<-- bad here
> 		break;
.....
> XFS (sda3): ino 0x6095c72 nr 0x4 offset 0x6a nextoff 0x85
> XFS: Assertion failed: got.br_startoff >= nextoff, file: fs/xfs/xfs_inode.c, line: 136
....
> XFS (sda3): ino 0x6095c72 func xfs_bmap_add_extent_hole_delay line 2691 data fork:
> XFS (sda3):    ino 0x6095c72 nr 0x0 nr_real 0x0 offset 0x26 blockcount 0x4 startblock 0xc119c4 state 0
> XFS (sda3):    ino 0x6095c72 nr 0x1 nr_real 0x1 offset 0x2a blockcount 0x26 startblock 0xcc457e state 1
> XFS (sda3):    ino 0x6095c72 nr 0x2 nr_real 0x2 offset 0x58 blockcount 0x12 startblock 0xcc45ac state 1
> XFS (sda3):    ino 0x6095c72 nr 0x3 nr_real 0x3 offset 0x70 blockcount 0x15 startblock 0xffffffffe0007 state 0
> XFS (sda3):    ino 0x6095c72 nr 0x4 nr_real 0x3 offset 0x6a blockcount 0x6 startblock 0xcc45be state 0
> XFS (sda3):    ino 0x6095c72 nr 0x5 nr_real 0x4 offset 0xa7 blockcount 0x19 startblock 0x17ff88 state 0

So icur prior to insertion should point to record 0x5, offset 0xa7
(right).  Prev (left) should point to record 0x4, offset 0x6a.

This makes both left and right valid, and while left is adjacent,
it's a different type so isn't contiguous.

So falling through to "case 0" is correct.

But then it inserts it at index 0x3 before record 0x4, not
at index 0x4 before record 0x5.

From xfs_iext_insert():

        for (i = nr_entries; i > cur->pos; i--)
		cur->leaf->recs[i] = cur->leaf->recs[i - 1];
	xfs_iext_set(cur_rec(cur), irec);

This implies cur->pos is wrong. i.e. it made a hole cur->pos = 0x3
and inserted there, not at cur->pos = 0x4.

Can you add debug to trace the iext cursor as
xfs_buffered_write_iomap_begin() ->
  xfs_bmapi_reserve_delalloc() ->
    xfs_bmap_add_extent_hole_delay()->
      xfs_iext_insert()

runs? The iext cursor could have been wrong for some time before
this insert tripped over it, so this may just be the messenger that
something has just smashed the stack (icur is a stack variable).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
