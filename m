Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF789C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 13:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEFFE20767
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 13:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IavPO43/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGJNx5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 09:53:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42283 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726828AbgGJNx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 09:53:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594389236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mtIuvWkuwTN3qDUtspD4+kB96CZ/SC3n7kkvO9RbS9c=;
        b=IavPO43/Vwfio29rZJBt2ZuHiycQWVLfS7PzhfEcs9255SGp/Kce4sWSpZNeoD/BacVWkn
        Qsi3cygjSbzjlBIQEgpQJ82nBPucQknBAJyJA/cC8qOXHpz5p0yXv99lBWj0BzA3GT83Gi
        +GPv9q/7Itg/tWB8OwpPVdmgM2/nQFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-07-khZlMMRm1mvNMFoGPkA-1; Fri, 10 Jul 2020 09:53:54 -0400
X-MC-Unique: 07-khZlMMRm1mvNMFoGPkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31BD9100AA23;
        Fri, 10 Jul 2020 13:53:53 +0000 (UTC)
Received: from redhat.com (ovpn-115-154.rdu2.redhat.com [10.10.115.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A4F9A17D82;
        Fri, 10 Jul 2020 13:53:49 +0000 (UTC)
Date:   Fri, 10 Jul 2020 08:53:47 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com,
        darrick.wong@oracle.com
Subject: Re: [PATCH] xfsprogs: xfs_quota state command should report ugp
 grace times
Message-ID: <20200710135347.GA249437@redhat.com>
References: <20200709212657.216923-1-billodo@redhat.com>
 <20200710090042.GB30797@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710090042.GB30797@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 10, 2020 at 10:00:42AM +0100, Christoph Hellwig wrote:
> On Thu, Jul 09, 2020 at 04:26:57PM -0500, Bill O'Donnell wrote:
> > Since grace periods are now supported for three quota types (ugp),
> > modify xfs_quota state command to report times for all three.
> 
> This looks like it'll clash with the patch that Darrick just sent..
> 
> > +	if (type & XFS_USER_QUOTA) {
> > +		if (xfsquotactl(XFS_GETQSTATV, dev, XFS_USER_QUOTA,
> > +				0, (void *)&sv) < 0) {
> > +			if (xfsquotactl(XFS_GETQSTAT, dev, XFS_USER_QUOTA,
> > +					0, (void *)&s) < 0) {
> > +				if (flags & VERBOSE_FLAG)
> > +					fprintf(fp,
> > +						_("%s quota are not enabled on %s\n"),
> > +						type_to_string(XFS_USER_QUOTA),
> > +						dev);
> > +				return;
> > +			}
> > +			state_stat_to_statv(&s, &sv);
> >  		}
> >  
> >  		state_qfilestat(fp, mount, XFS_USER_QUOTA, &sv.qs_uquota,
> >  				sv.qs_flags & XFS_QUOTA_UDQ_ACCT,
> >  				sv.qs_flags & XFS_QUOTA_UDQ_ENFD);
> > +		state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
> > +		state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
> > +		state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
> > +	}
> 
> Any chance we could factor this repititive code into a helper?
> 
Yeah, that makes sense. I'll do it.
Thanks-
Bill

