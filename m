Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F037FC34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 23:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCC63206E2
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 23:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgBQXcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 18:32:17 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44000 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgBQXcR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 18:32:17 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B40C93A1FA0;
        Tue, 18 Feb 2020 10:32:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3ps5-0003xW-Ki; Tue, 18 Feb 2020 10:32:13 +1100
Date:   Tue, 18 Feb 2020 10:32:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 20/31] xfs: open code ATTR_ENTSIZE
Message-ID: <20200217233213.GU10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-21-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-21-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=aUVhQoF2XSUH8qZepWcA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:46PM +0100, Christoph Hellwig wrote:
> Replace an opencoded offsetof and round_up hiden behind to macros
> using the open code variant using the standard helpers.

Could be better written (and typos):

Replace a single use macro containing open-coded variants of
standard helpers with direct calls to the standard helpers.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Otherwise, looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
