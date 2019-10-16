Return-Path: <SRS0=pjFm=YJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A0BFA3728
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 15:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF383218DE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Oct 2019 15:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=djwong.org header.i=@djwong.org header.b="fCX9rylu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfJPPnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:43:11 -0400
Received: from sweaglesw.org ([216.129.123.154]:43321 "EHLO sweaglesw.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbfJPPnJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Oct 2019 11:43:09 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2019 11:43:09 EDT
Received: by sweaglesw.org (Postfix, from userid 1021)
        id 8CFB1601EE; Wed, 16 Oct 2019 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=djwong.org; s=default;
        t=1571240228; bh=h3oYV1gA0ZvL73gjuk8Z5ATgP8JwISlyPyx6w5cZG8M=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=fCX9ryluxis4h29TYXO7zUEuoPnBSNh3blGnl4VEBQdkgYJq8gXmRBwM5CvvPeBZr
         q38tDILz23mRECkD0WBo2Mn/TOr0BVdy5cpzGwzNbMqRHjGSjrIERFbcK3jSz8KwSN
         aE8ZQePLx35+m75RyR7Ug0wmwqpG/Q0+F/UP5aoi4p8tr9JSLVMx5x2hwJ7rpONOY+
         HiOd6g/nx2581HidOMCT6A8z7DBxZ4RWxmXpqLGxnPZdCUsS88BYd2Hukn59S093/J
         Bm2lmcm+DtUMia2nDnrwOSa0PIyRPScJNtuVnMLg8ANb1d22ubr35livMTul8cSAHe
         Uf/ixPzRS6qiHz5UC9AZxom5Cg/W2xV+3axpqgFttnKjxV4/JO+BghZWzYtXDwqyip
         jIxIA1+lx9VLlzZvy3shARzcp9E5ZGzVxkyKbNDQAga4gfU2jYfZcwP3xcVUyRH+2a
         QDgnFQ932vec37xFIBYLjR6fQxYZZYZgWu3TGpIz+hHlkUH9zFEMkCFVNNl2wYSFLr
         tIJRmZKMjBopfA9RWAoLcAaD8JKgGiY7BgHPHzr6iMENnPBnRegwwPuk9/nI/rLK8B
         AAAEcuLIERRDZTfO4R2ZPR+YJE3gXqso7tbxnPnMxicA9PyakHNdhmBOhhHB0ieOAZ
         PUxXlBc8QDeokRnTEr1OH2x4=
Date:   Wed, 16 Oct 2019 08:37:08 -0700
From:   "Darrick J. Wong" <djwong@djwong.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs <linux-xfs@vger.kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v6 08/12] xfs: refactor suffix_kstrtoint()
Message-ID: <20191016153708.GD1649663@sweaglesw.org>
Reply-To: djwong@djwong.org
References: <157118625324.9678.16275725173770634823.stgit@fedora-28>
 <157118648744.9678.4128365130843690618.stgit@fedora-28>
 <20191016083420.GG29140@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016083420.GG29140@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 16, 2019 at 01:34:20AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 16, 2019 at 08:41:27AM +0800, Ian Kent wrote:
> > The mount-api doesn't have a "human unit" parse type yet so
> > the options that have values like "10k" etc. still need to
> > be converted by the fs.
> > 
> > But the value comes to the fs as a string (not a substring_t
> > type) so there's a need to change the conversion function to
> > take a character string instead.
> > 
> > When xfs is switched to use the new mount-api match_kstrtoint()
> > will no longer be used and will be removed.
> 
> Please use up the full 72 chars available for the commit log.
> 
> > +STATIC int
> > +match_kstrtoint(const substring_t *s, unsigned int base, int *res)
> 
> No need for static on new/heavily modified functions, just use static.
> 
> Note that both this and suffix_kstrtoint don't really follow the
> normal XFS prototype formatting style either.
> 
> > +	const char	*value;
> > +	int ret;
> 
> Similarly here - either you follow the XFS style of tab alignining
> the variable names for all variables, or for none, but a mix is very
> odd.

Please follow the xfs style of tab aligning variables inside xfs.

--D
