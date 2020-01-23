Return-Path: <SRS0=OHiL=3M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D3EC33CAA
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBABB21734
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jan 2020 22:33:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CXuEAoep"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAWWdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:33:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53018 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgAWWdp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 17:33:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GdUWebdOzBG1VFxN0MYmAkWhKEDT5oznZUTu6ALvPFo=; b=CXuEAoepTyc5kp7702UTCSGUU
        2yQsqLPzcweZE67zGwjQMXXzmwtXhBvlnv33sJNh5Cudn71YLYNid0iAl/2kaovqMjUf4o4Xrl+Zn
        MmljGnlF0JLOc6Gr6daqRPQQIUP0B6tSQY4uf8RCaJyiicSkZ/r9cj7UN7fTVDagDBgOg6oc/P+x2
        2T6EwxnXJGI6scg59sP+TgQg7BuW0m5sL+LkS10Ue8aljjSdE0lMAOMaXqy6ylAtO0KNN8T6U1bfm
        88TjoMPDnztbWVzavGxU8F2lO3PkoBiEKUT+NsDxFshxsW/HfXCUGRGAzMUEyH4ZkW/EdLPk66UM1
        uEt7abMhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iul2l-00025X-Bi; Thu, 23 Jan 2020 22:33:43 +0000
Date:   Thu, 23 Jan 2020 14:33:43 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/29] xfs: merge xfs_attrmulti_attr_remove into
 xfs_attrmulti_attr_set
Message-ID: <20200123223343.GA2669@infradead.org>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-4-hch@lst.de>
 <20200121174145.GD8247@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121174145.GD8247@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 21, 2020 at 09:41:45AM -0800, Darrick J. Wong wrote:
> Does /any/ of this have a testcase?  I couldn't find anywhere that uses
> attrmulti, not even xfsdump.

xfsdump uses it through the jdm_attr_multi wrapper in libhandle.
