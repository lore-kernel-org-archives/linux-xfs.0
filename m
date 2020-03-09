Return-Path: <SRS0=zudJ=42=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651EFC10F27
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Mar 2020 08:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EB7E20728
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Mar 2020 08:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgCIICz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Mar 2020 04:02:55 -0400
Received: from verein.lst.de ([213.95.11.211]:46546 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCIICz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Mar 2020 04:02:55 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0A1E368B20; Mon,  9 Mar 2020 09:02:53 +0100 (CET)
Date:   Mon, 9 Mar 2020 09:02:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: remove the unused return value from
 xfs_log_unmount_write
Message-ID: <20200309080252.GA31481@lst.de>
References: <20200306143137.236478-1-hch@lst.de> <20200306143137.236478-2-hch@lst.de> <20200306160917.GD2773@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306160917.GD2773@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 11:09:17AM -0500, Brian Foster wrote:
> On Fri, Mar 06, 2020 at 07:31:31AM -0700, Christoph Hellwig wrote:
> > Remove the ignored return value from xfs_log_unmount_write, and also
> > remove a rather pointless assert on the return value from xfs_log_force.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> I guess there's going to be obvious conflicts with Dave's series and
> some of these changes. I'm just going to ignore that and you guys can
> figure it out. :)

I'm glad to rebase this on top of the parts of his series that I think
make sense.  Just wanted to send this out for now to show what I have
in mind in this area.
