Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3980AC07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 06:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C75610FB
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 06:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbhGTF5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 01:57:15 -0400
Received: from verein.lst.de ([213.95.11.211]:53906 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhGTF5O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Jul 2021 01:57:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BCBE68AFE; Tue, 20 Jul 2021 08:37:51 +0200 (CEST)
Date:   Tue, 20 Jul 2021 08:37:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs/220: avoid failure when disabling quota
 accounting is not supported
Message-ID: <20210720063751.GC14747@lst.de>
References: <20210712111146.82734-1-hch@lst.de> <20210712111146.82734-5-hch@lst.de> <20210714233049.GO22402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714233049.GO22402@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 04:30:49PM -0700, Darrick J. Wong wrote:
> > +#
> > +# The sed expression below replaces a notrun to cater for kernels that have
> > +# removed the ability to disable quota accounting at runtime.  On those
> > +# kernel this test is rather useless, and in a few years we can drop it.
> > +xfs_quota -x -c off -c remove $SCRATCH_DEV 2>&1 | \
> 
> Please replace 'xfs_quota' with '$XFS_QUOTA_PROG' in all these tests
> you're touching.
> 
> > +	sed -e '/XFS_QUOTARM: Invalid argument/d'
> 
> Between 'off' and 'remove', which one returned EINVAL?

remove, as the file system is still using the quota files.
