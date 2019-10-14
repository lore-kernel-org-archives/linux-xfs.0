Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0896C47404
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 07:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF76E2064A
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 07:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfJNHW1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 03:22:27 -0400
Received: from verein.lst.de ([213.95.11.211]:47587 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730172AbfJNHW1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Oct 2019 03:22:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4134968CFC; Mon, 14 Oct 2019 09:22:24 +0200 (CEST)
Date:   Mon, 14 Oct 2019 09:22:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: remove the XLOG_STATE_DO_CALLBACK state
Message-ID: <20191014072224.GF10081@lst.de>
References: <20191009142748.18005-1-hch@lst.de> <20191009142748.18005-9-hch@lst.de> <20191012004145.GP13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191012004145.GP13108@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 05:41:45PM -0700, Darrick J. Wong wrote:
> > -#else
> > -#define xlog_state_callback_check_state(l)	((void)0)
> > -#endif
> 
> So, uh... does this debugging functionality just disappear?  Is it
> unnecessary?  It's not clear (to me anyway) why it's ok for the extra
> checking to go away.

Lets ask the counter question:  What kind of bug do you think this
check would catch?
