Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DB2C3A59E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 11:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D7B52082F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 11:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHTLYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:24:14 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44533 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729421AbfHTLYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 07:24:14 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DAA5A2ADA52;
        Tue, 20 Aug 2019 21:24:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i02EC-0005DO-6j; Tue, 20 Aug 2019 21:23:04 +1000
Date:   Tue, 20 Aug 2019 21:23:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190820112304.GF1119@dread.disaster.area>
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
 <20190819151335.GB2875@bfoster>
 <718fa074-2c33-280e-c664-6afcc3bfe777@gmail.com>
 <20190820080741.GE1119@dread.disaster.area>
 <62649c5f-5390-8887-fe95-4f873af62804@gmail.com>
 <20190820105101.GA14307@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820105101.GA14307@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=UD9wB-r_hoJu2ZtOc3wA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 06:51:01AM -0400, Brian Foster wrote:
> On Tue, Aug 20, 2019 at 04:53:22PM +0800, kaixuxia wrote:
> FWIW if we do take that approach, then IMO it's worth reconsidering the
> 1-2 liner I originally proposed to fix the locking. It's slightly hacky,
> but really all three options are hacky in slightly different ways. The
> flipside is it's trivial to implement, review and backport and now would
> be removed shortly thereafter when we replace the on-disk whiteout with
> the in-core fake whiteout thing. Just my .02 though..

We've got to keep the existing whiteout method around for,
essentially, forever, because we have to support kernels that don't
do in-memory translations of DT_WHT to a magic chardev inode and
vice versa (i.e. via mknod). IOWs, we'll need a feature bit to
indicate that we actually have DT_WHT based whiteouts on disk.

So we may as well fix this properly now by restructuring the code as
we will still have to maintain this functionality for a long time to
come.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
