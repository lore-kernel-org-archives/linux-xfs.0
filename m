Return-Path: <SRS0=apCn=YD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72740C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 07:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD4321929
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Oct 2019 07:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sL5l04Ih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbfJJH54 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Oct 2019 03:57:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733062AbfJJH54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Oct 2019 03:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cmVO/krAmz0iAXnK2DrI/Zo0nRjnOCzLPpRIvl3zHSU=; b=sL5l04IhMP1D8PYrUWNdqwbND
        7bM+KaKbyhfaq4xIPeDc5aN9sytobZQ0Y6+ia/yYmudNqrAOwvaNfOpc5RxkepP+N/d6t/Tl6zqgN
        67299YDfEnoCOMaQHEiA91R8qvBDjCg1mTCVL0kyQHfjp5owszXd+tVYkv78B8TgIneLaH0/HIBIS
        eaNihYexMr3WpMXMfm0HMOt0csK+XMP8cBWsThhOp6HI++zj7/hcc8Wkt60E5H7tujzqhFieLUdHV
        OlhkxabQPCEkcmmfEi5dfljK6k2BNA3dk7hNITp1WXwCxF+V5lAsuen41MKFq77+10lK5Pa5wAspc
        lkHroLIqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iITKZ-0004LD-Qf; Thu, 10 Oct 2019 07:57:51 +0000
Date:   Thu, 10 Oct 2019 00:57:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, Ian Kent <raven@themaw.net>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v5 08/17] xfs: mount-api - move xfs_parseargs()
 validation to a helper
Message-ID: <20191010075751.GA16305@infradead.org>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
 <157062065250.32346.13350789812067183237.stgit@fedora-28>
 <20191009150206.GF10349@infradead.org>
 <20191009194747.GH13108@magnolia>
 <20191010063824.GA15004@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010063824.GA15004@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 11:38:24PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 09, 2019 at 12:47:47PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 09, 2019 at 08:02:06AM -0700, Christoph Hellwig wrote:
> > > On Wed, Oct 09, 2019 at 07:30:52PM +0800, Ian Kent wrote:
> > > > +#ifndef CONFIG_XFS_QUOTA
> > > > +	if (XFS_IS_QUOTA_RUNNING(mp)) {
> > > > +		xfs_warn(mp, "quota support not available in this kernel.");
> > > > +		return -EINVAL;
> > > > +	}
> > > > +#endif
> > > 
> > > this can use IS_ENABLED.
> > 
> > I didn't think that macro needed a CONFIG_XFS_QUOTA check...?
> 
> Even better if we don't need anything at al..

Actually.  The test is and #ifndef, so yes we ctually need the check.
That being said I think and opencoded m_qflags != 0 instead of
XFS_IS_QUOTA_RUNNING would actually describing the intent to the
reader as we directly manipulate m_qflags elsewhere in the mount
code.
