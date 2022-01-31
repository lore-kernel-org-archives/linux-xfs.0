Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7454CC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 12:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377176AbiAaM2Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 07:28:24 -0500
Received: from verein.lst.de ([213.95.11.211]:54534 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378072AbiAaM2R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jan 2022 07:28:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5CA2268AA6; Mon, 31 Jan 2022 13:28:13 +0100 (CET)
Date:   Mon, 31 Jan 2022 13:28:13 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 18/17] xfs_scrub: fix reporting if we can't open raw
 block devices
Message-ID: <20220131122813.GA10300@lst.de>
References: <164263809453.863810.8908193461297738491.stgit@magnolia> <20220128224410.GL13540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128224410.GL13540@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 02:44:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The error checking logic for opening the data, log, and rt device is
> totally broken.  Fix this.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
