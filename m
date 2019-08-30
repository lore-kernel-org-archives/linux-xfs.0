Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1541C3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94C1D21721
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfH3FnI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:43:08 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:37647 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbfH3FnH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:43:07 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3D434362A20;
        Fri, 30 Aug 2019 15:43:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3Zge-0003qt-JC; Fri, 30 Aug 2019 15:43:04 +1000
Date:   Fri, 30 Aug 2019 15:43:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] libxfs: move topology declarations into separate
 header
Message-ID: <20190830054304.GD1119@dread.disaster.area>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633308405.1215978.11329921136072672886.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156633308405.1215978.11329921136072672886.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=2i2dSXbQgklr4ZMhXAEA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 01:31:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The topology functions live in libfrog now, which means their
> declarations don't belong in libxcmd.h.  Create new header file for
> them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/libxcmd.h  |   31 -------------------------------
>  include/topology.h |   39 +++++++++++++++++++++++++++++++++++++++
>  libfrog/topology.c |    1 +
>  mkfs/xfs_mkfs.c    |    2 +-
>  repair/sb.c        |    1 +
>  5 files changed, 42 insertions(+), 32 deletions(-)
>  create mode 100644 include/topology.h

I like the idea, but I'm wondering if we should have a similar
setup to libxfs header files here.

i.e. the header file lives in libfrog/, and the install-headers make
command creates include/libxfrog and links them for the build. That
way the includes become namespaced like:

#include "libxfrog/topology,h"

and we don't pollute include with random header files from all
different parts of xfsprogs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
