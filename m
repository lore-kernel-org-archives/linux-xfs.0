Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CA7C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0CB820657
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgETGaW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 02:30:22 -0400
Received: from verein.lst.de ([213.95.11.211]:47896 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgETGaW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:30:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5467D68C4E; Wed, 20 May 2020 08:30:18 +0200 (CEST)
Date:   Wed, 20 May 2020 08:30:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/11] xfs: move eofblocks conversion function to
 xfs_ioctl.c
Message-ID: <20200520063017.GA2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993912447.976105.10249427349387670469.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993912447.976105.10249427349387670469.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:45:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move xfs_fs_eofblocks_from_user into the only file that actually uses
> it, so that we don't have this function cluttering up the header file.
> 

Thanks, the strange inline function really irked me when looking over the
code:

Reviewed-by: Christoph Hellwig <hch@lst.de>
