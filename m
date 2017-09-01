Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52163 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbdIAUIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 16:08:30 -0400
Date: Fri, 1 Sep 2017 13:08:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: don't set v3 xflags for v2 inodes
Message-ID: <20170901200829.GA11391@infradead.org>
References: <20170830163825.GQ4757@magnolia>
 <20170831131723.GD19544@infradead.org>
 <20170831133420.GB21939@bfoster.bfoster>
 <20170831140932.GB26555@infradead.org>
 <20170831195729.GM3775@magnolia>
 <20170901072149.GA7443@infradead.org>
 <20170901175223.GH3775@magnolia>
 <20170901192958.GA30923@infradead.org>
 <20170901194024.GI3775@magnolia>
 <20170901200632.GJ3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901200632.GJ3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>

On Fri, Sep 01, 2017 at 01:06:32PM -0700, Darrick J. Wong wrote:
> > Yeah, I'll rebase that whole mess...
> 
> ...also, I assume you already fixed up:
> 
> -       di_flags2 = xfs_flags2diflags(ip, fa->fsx_xflags);
> +       di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);

I finally did half an hour ago after starting at crashes that didn't make
any sense for far too long..
