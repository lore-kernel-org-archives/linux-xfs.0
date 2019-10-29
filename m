Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E0FCA9EC2
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B17722086A
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 07:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbfJ2HuR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 03:50:17 -0400
Received: from verein.lst.de ([213.95.11.211]:38600 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJ2HuQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 03:50:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5AC9E68AFE; Tue, 29 Oct 2019 08:50:15 +0100 (CET)
Date:   Tue, 29 Oct 2019 08:50:15 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 08/12] xfs: rename the XFS_MOUNT_DFLT_IOSIZE option to
 XFS_MOUNT_ALLOCISZE
Message-ID: <20191029075015.GB18999@lst.de>
References: <20191027145547.25157-1-hch@lst.de> <20191027145547.25157-9-hch@lst.de> <20191028171236.GQ15222@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028171236.GQ15222@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 10:12:36AM -0700, Darrick J. Wong wrote:
> s/ALLOCISZE/ALLOCSIZE/ in the subject
> 
> On Sun, Oct 27, 2019 at 03:55:43PM +0100, Christoph Hellwig wrote:
> > Make the flag match the mount option and usage.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Feel free to fix up when applying the patch :)
