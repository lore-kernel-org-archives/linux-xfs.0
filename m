Return-Path: <SRS0=bIZx=BU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87FCC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 00:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB5A2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 00:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHJAJj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Aug 2020 20:09:39 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:47659 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbgHJAJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Aug 2020 20:09:38 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 554DDD5BCD3;
        Mon, 10 Aug 2020 10:09:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k4vNc-0008Rf-PQ; Mon, 10 Aug 2020 10:09:32 +1000
Date:   Mon, 10 Aug 2020 10:09:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200810000932.GH2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=8zQI7oPrHZscO10ZPH8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=208827
> 
> --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
> On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=208827
> > 
> >             Bug ID: 208827
> >            Summary: [fio io_uring] io_uring write data crc32c verify
> >                     failed
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4

FWIW, I can reproduce this with a vanilla 5.8 release kernel,
so this isn't related to contents of the XFS dev tree at all...

In fact, this bug isn't a recent regression. AFAICT, it was
introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
reproduce. More info once I've finished bisecting it....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
