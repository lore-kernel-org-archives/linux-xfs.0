Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5914C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 13:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B3E52075E
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 13:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgEGNml (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 09:42:41 -0400
Received: from verein.lst.de ([213.95.11.211]:46611 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgEGNml (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 09:42:41 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1680568B05; Thu,  7 May 2020 15:42:30 +0200 (CEST)
Date:   Thu, 7 May 2020 15:42:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: split xfs_iformat_fork
Message-ID: <20200507134229.GA23181@lst.de>
References: <20200501081424.2598914-1-hch@lst.de> <20200501081424.2598914-4-hch@lst.de> <20200501133431.GJ40250@bfoster> <20200507122718.GA17936@lst.de> <20200507134022.GE9003@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507134022.GE9003@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 09:40:22AM -0400, Brian Foster wrote:
> On Thu, May 07, 2020 at 02:27:18PM +0200, Christoph Hellwig wrote:
> > On Fri, May 01, 2020 at 09:34:31AM -0400, Brian Foster wrote:
> > > > +	default:
> > > > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> > > > +				sizeof(*dip), __this_address);
> > > > +		return -EFSCORRUPTED;
> > > > +	}
> > > 
> > > Can we fix this function up to use an error variable and return error at
> > > the end like xfs_iformat_attr_work() does? Otherwise nice cleanup..
> > 
> > What would the benefit of a local variable be here?  It just adds a
> > little extra code for no real gain.
> > 
> 
> It looks like the variable is already defined, it's just not used
> consistently. The only extra code are break statements in the switch and
> a return statement at the end of the function, which currently looks odd
> without it IMO.

As of this patch there is no local error variable.  Later on it gets
added, but only used in a single place for the fork verifier.  I find
functions that basically are a big switch statement and return from
each case pretty normal.
