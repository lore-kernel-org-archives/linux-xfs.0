Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530C3C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1379622DCC
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 01:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbhALBXO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbhALBXO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 20:23:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DC9022EBE;
        Tue, 12 Jan 2021 01:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610414553;
        bh=QHgmuAaUbF7wm+8JwJemZ/y7Tolh68UlZintgOkldKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R1xafNa6M/9suhXGSRYw/3wAEO4IeUfHCRiCYUto44NENufJUyTRlTnoDE3Br35qw
         NpAH8747s+0ERVMJoF+mEBW5AwfIgsTv2OqcJ4swyuMjIV4/0kEiZ5eJDGrj7S6NEP
         elhtv2T1iA1LSnIBFutPjAwmLikJQcuI3FGiY33CKCOuSO2dp4o83IwlPJ9xYrbLTu
         I7kXi5poaMXU7ujhVjQ6czfBxJlKv7fTZ3NJIXOOxQeaYVXlwOMTOiRuBdMwS0qJM8
         BnPpQtN8UC0e8Pq6jOy5GZOfPGxeP7xeKKlXho9UHhUVbjrzt6N93znWvhWf8LufJn
         qGnX7+1qvQWzQ==
Date:   Mon, 11 Jan 2021 17:22:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] misc: fix valgrind complaints
Message-ID: <20210112012233.GI1164246@magnolia>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
 <161017372088.1142776.17470250928392025583.stgit@magnolia>
 <20210111172746.GA848188@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111172746.GA848188@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:27:46PM +0000, Christoph Hellwig wrote:
> On Fri, Jan 08, 2021 at 10:28:40PM -0800, Darrick J. Wong wrote:
> >  	char		hbuf [MAXHANSIZ];
> >  	int		ret;
> > -	uint32_t	handlen;
> > +	uint32_t	handlen = 0;
> >  	xfs_fsop_handlereq_t hreq;
> >  
> > +	memset(&hreq, 0, sizeof(hreq));
> > +	memset(hbuf, 0, MAXHANSIZ);
> 
> Using empty initializers at declaration time is simpler and sometimes
> more efficient.  But either way will work fine.

I'll fix that then, and get rid of two more typedef usages.

--D
