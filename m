Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45481C07E99
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 22:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1991461154
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 22:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhGEWMG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 18:12:06 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:43860 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhGEWMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 18:12:06 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 0A0B51B21E5;
        Tue,  6 Jul 2021 08:09:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m0WmL-003BJL-Tt; Tue, 06 Jul 2021 08:09:25 +1000
Date:   Tue, 6 Jul 2021 08:09:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reset child dir '..' entry when unlinking child
Message-ID: <20210705220925.GN664593@dread.disaster.area>
References: <20210703030233.GD24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210703030233.GD24788@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=9oFb0R6jFBLlYLQk3U8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 08:02:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running xfs/168, I noticed a second source of post-shrink
> corruption errors causing shutdowns.
> 
> Let's say that directory B has a low inode number and is a child of
> directory A, which has a high number.  If B is empty but open, and
> unlinked from A, B's dotdot link continues to point to A.  If A is then
> unlinked and the filesystem shrunk so that A is no longer a valid inode,
> a subsequent AIL push of B will trip the inode verifiers because the
> dotdot entry points outside of the filesystem.

So we have a directory inode that is empty and unlinked but held
open, with a back pointer to an invalid inode number? Which can
never be followed, because the directory has been unlinked.

Can't this be handled in the inode verifier? This seems to me to
be a pretty clear cut case where the ".." back pointer should
always be considered invalid (because the parent dir has no
existence guarantee once the child has been removed from it), not
just in the situation where the filesystem has been shrunk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
