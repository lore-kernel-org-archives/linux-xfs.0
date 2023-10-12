Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8866CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbjJLFKI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJLFKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:10:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8C490
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:10:06 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EAB1B6732D; Thu, 12 Oct 2023 07:10:02 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:10:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 1/7] xfs: create a helper to convert rtextents to
 rtblocks
Message-ID: <20231012051002.GA2184@lst.de>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs> <169704721195.1773611.10348820944256520547.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721195.1773611.10348820944256520547.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:04:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper to convert a realtime extent to a realtime block.  Later
> on we'll change the helper to use bit shifts when possible.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
