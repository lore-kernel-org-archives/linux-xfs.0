Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78013C47258
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E86F24955
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eo5s3BVw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgEARCd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:02:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49740 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728975AbgEARCd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:02:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588352552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TXrcIozY4riDYGUNT/qNzscrGyKAlUOYjTdRVse2U3Y=;
        b=eo5s3BVwkNQN+q3XoTttvuRhpIvnW4vTB0Xvu8/lFh+ZHbLfxFDMg0wItoXAq81pB6gIPA
        E9wQynayH0NeO3EMhb075oMkQeg9u28B0Cj7BEE1Ns/VJLU6UTEOKgEMUXkz/l0OPV8pMa
        N0gQcC9E65N275n7kKF+drVgLPMxf58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-e_Exa_j3MtOwS0IGF_dBDw-1; Fri, 01 May 2020 13:02:30 -0400
X-MC-Unique: e_Exa_j3MtOwS0IGF_dBDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6744E1005510;
        Fri,  1 May 2020 17:02:29 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2FCC10016EB;
        Fri,  1 May 2020 17:02:28 +0000 (UTC)
Date:   Fri, 1 May 2020 13:02:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: refactor xfs_inode_verify_forks
Message-ID: <20200501170227.GS40250@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-10-hch@lst.de>
 <20200501155724.GP40250@bfoster>
 <20200501164009.GB18426@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501164009.GB18426@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 06:40:09PM +0200, Christoph Hellwig wrote:
> On Fri, May 01, 2020 at 11:57:24AM -0400, Brian Foster wrote:
> > >  	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> > > -		return __this_address;
> > > -	return xfs_attr_shortform_verify(ip);
> > > +		fa = __this_address;
> > > +	else
> > > +		fa = xfs_attr_shortform_verify(ip);
> > > +
> > > +	if (fa) {
> > > +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> > > +			ip->i_afp->if_u1.if_data, ip->i_afp->if_bytes, fa);
> > > +		return -EFSCORRUPTED;
> > 
> > This explicitly makes !ip->i_afp one of the handled corruption cases for
> > XFS_DINODE_FMT_LOCAL, but then attempts to access it anyways. Otherwise
> > seems Ok modulo the comments on the previous patch...
> 
> No, it keeps the existing bogus behavior, just making the bug more
> obvious by moving the bits closer together :(
> 

The associated code replaced in this patch checks the attr fork pointer:

-               ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
-               xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
-                               ifp ? ifp->if_u1.if_data : NULL,
-                               ifp ? ifp->if_bytes : 0, fa);

Brian

> That being said this is getting fixed later in the series.
> 

