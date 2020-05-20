Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED3FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D578C205CB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 06:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgETGnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 02:43:16 -0400
Received: from verein.lst.de ([213.95.11.211]:47959 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETGnO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:43:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EAF2168B02; Wed, 20 May 2020 08:43:12 +0200 (CEST)
Date:   Wed, 20 May 2020 08:43:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/11] xfs: use bool for done in xfs_inode_ag_walk
Message-ID: <20200520064312.GI2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993917464.976105.8225510964854349068.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993917464.976105.8225510964854349068.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 06:46:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a boolean variable, so use the bool type.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
