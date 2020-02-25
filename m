Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18BFC35DF9
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B32C42176D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 09:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgBYJFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 04:05:30 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40427 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729153AbgBYJFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 04:05:30 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 04A9F3A2B5B;
        Tue, 25 Feb 2020 20:05:27 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j6W9d-0007uE-VK; Tue, 25 Feb 2020 20:05:25 +1100
Date:   Tue, 25 Feb 2020 20:05:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 15/19] xfs: Add helper function xfs_attr_node_shrink
Message-ID: <20200225090525.GJ10776@dread.disaster.area>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-16-allison.henderson@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=AZmCNVgHFE-d1zejr8QA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:06:07PM -0700, Allison Collins wrote:
> This patch adds a new helper function xfs_attr_node_shrink used to shrink an
> attr name into an inode if it is small enough.  This helps to modularize
> the greater calling function xfs_attr_node_removename.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Can you move this helper function up to early in the patch set?
That way the code gets simpler and less tangled before adding
all the new state machine gubbins?

I suspect that you should do this for all the functions the state
machine breaks up into gotos, too. THat way adding the state machine
is really just changing how the functions that do the work are
called, rather than jumping into the middle of long functions....

I know, it turns it into a longer series, but it also means that all
the refactoring work (which needs to be done anyway) can be
separated and merged while we are still reviewing and working on the
state machine based operations, thereby reducing the size of the
patchset you have to manage and keep up to date over time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
