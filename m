Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA3BC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2F4922D2C
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 19:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437257AbhART6R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 14:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407188AbhART5v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 14:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3313622B49;
        Mon, 18 Jan 2021 19:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610999831;
        bh=HD7BApLOD9OZ+/qAw5hpcG059FYFGqjKGZ2CZAkohic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oCaF5MQJDsx26VDrruv/6AaWXA8YTL3znQcq5S0lTU15yLwi8Te3haVtSXorbqKEE
         AYqleXfmMdt4Wf2EnukYU1fsiEmCRNg1UiQl337JkERtXKGNIXfEWg337Oqr16hA++
         4UzgayT9pUqutXJReUn6sY8VGv6v8HzV0rBJcB8+co5pf3DxYxA5AdYyc7/Jgio/wx
         c2REFY2gNhtla2TPO5FXpTvg3J1wEDQm7R7CNSzhZPxS5kBfkQ8j7YH7g0cUnBuaHS
         zEQ5A7SPwGPcog5oGtmh/uqhTo7wt1hBYfKSzkk/SgDgN0uYu4in0EWtOwytp3JrKs
         AM3HZWI3z4IOQ==
Date:   Mon, 18 Jan 2021 11:57:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210118195710.GL3134581@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740189.1582286.17385075679159461086.stgit@magnolia>
 <X/8IfJj+qgnl303O@infradead.org>
 <20210114213259.GF1164246@magnolia>
 <20210114223849.GI1164246@magnolia>
 <20210118173628.GB3134885@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118173628.GB3134885@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 05:36:28PM +0000, Christoph Hellwig wrote:
> On Thu, Jan 14, 2021 at 02:38:49PM -0800, Darrick J. Wong wrote:
> > There already /is/ a pwork_threads sysctl knob for controlling
> > quotacheck parallelism; and for the block gc workqueue I add WQ_SYSFS so
> > that you can set /sys/bus/workqueue/devices/xfs-*/max_active.
> 
> Hmm.  A single know that is named to describe that it deals with the
> expected device parallelism might be easier to understand for users.

Where should I add a sysfs attributes for per-fs configuration knobs?  I
don't really want to add "expected parallelism" to /sys/fs/xfs/*/error
because that seems like the wrong place, and /proc/sys/fs/xfs/ is too
global for something that could depend on the device.

--D
