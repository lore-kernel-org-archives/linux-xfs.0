Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE
	autolearn=no autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by sandeen.net (Postfix) with ESMTP id 90CAB7B8C
	for <sandeen@sandeen.net>; Wed, 11 Mar 2020 10:52:08 -0500 (CDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgCKPwp (ORCPT <rfc822;sandeen@sandeen.net>);
        Wed, 11 Mar 2020 11:52:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49054 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbgCKPwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 11:52:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Lkz1J4vfspmY1YdUhMUXQ1h3CrkgT8McQF7vpnQybZs=; b=fXxNGYs3r0euHe+/ylBeME777m
        kotOgE06X+05cmq07TSo5JWuS8GYXPZBkviSVOWK9cL5QEEKt1eQOAdf0kzQYFQgawvwzebSJFYZ0
        8uzEUmS5eHg0rl5boqTlWg2W0mzDq6VaRlUFwIlXNckduycQfdbbftBFY07KXgqt4XLfmkKKuE2Aq
        WYLuH7Gfs9yhauSDcGBchCTihDJqI+VTYLvRtfvPyY1G99h+0iG3J37EBQfE8XzjF4bVrO4aO4TK7
        Jnxu2BxDLckYKesnFtmm/ll1DaRBWS2x23INVpsHXzP/by0AZKJi9Gm5AkkqwHnm5ofgy3wdff30G
        6thZ4aag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jC3f2-0001Pu-Ui; Wed, 11 Mar 2020 15:52:44 +0000
Date:   Wed, 11 Mar 2020 08:52:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
Message-ID: <20200311155244.GA5409@infradead.org>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388763048.939081.7269460615856522299.stgit@magnolia>
 <20200311064011.GA25435@infradead.org>
 <20200311154725.GD8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311154725.GD8045@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:47:25AM -0700, Darrick J. Wong wrote:
> On Tue, Mar 10, 2020 at 11:40:11PM -0700, Christoph Hellwig wrote:
> > On Tue, Mar 10, 2020 at 05:47:10PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
> > > instead, but we forgot to teach xfs_rmap_has_other_keys not to return
> > > that magic value to callers.  Fix it now.
> > 
> > This doesn't document the remap of the has_rmap flag.  As far as I can
> > tell that isn't needed now the caller checks for ECANCELED, but it
> > takes a while to figure that out.  It'll need to be documented properly
> > in the commit log.
> 
> "Fix it now by using ECANCELED both to abort the iteration and to signal
> that we found another reverse mapping.  This enables us to drop the
> separate boolean flag." ?

Sounds good.

