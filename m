Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6737C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jun 2022 04:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242106AbiFUEf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 00:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFUEf5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jun 2022 00:35:57 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3331A12ADD;
        Mon, 20 Jun 2022 21:35:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 368215ECB2E;
        Tue, 21 Jun 2022 14:35:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o3VcE-009B2n-PY; Tue, 21 Jun 2022 14:35:50 +1000
Date:   Tue, 21 Jun 2022 14:35:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Shida Zhang <starzhangzsd@gmail.com>
Cc:     djwong@kernel.org, zhangshida@kylinos.cn,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: return when delta equals 0 in xfs_mod_freecounter
Message-ID: <20220621043550.GP227878@dread.disaster.area>
References: <20220621031113.1222877-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621031113.1222877-1-zhangshida@kylinos.cn>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b14aaa
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=7-415B0cAAAA:8
        a=VVchs2K6gwcUi-N_qr0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 21, 2022 at 11:11:13AM +0800, Shida Zhang wrote:
> There are cases that xfs_mod_freecounter() will get called when delta
> equals 0 while it's unnecessary.

AFAICT all of the call paths are guarded by checks to ensure the
delta is, in fact, not zero. i.e. if the delta is zero, we shouldn't
be calling xfs_mod_fdblocks() or xfs_mod_frextents() at all.

Can you explain in more detail what code path leads to delta = 0
here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
