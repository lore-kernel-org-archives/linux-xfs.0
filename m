Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA85CC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 18:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4B92076D
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 18:59:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aT6Vr+SD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgEFS7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 14:59:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgEFS7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 14:59:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046IrtRX027741;
        Wed, 6 May 2020 18:59:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KzRJMxWmI0GiGhVEmIEHmNXaezv+0CYc8PLo4BvZO6E=;
 b=aT6Vr+SDTrCqM+dYPEerQDMqtZ7BxKQaxXhg8eh/0CyHxhbXGFOfuZ5/SMd/vOiuXRZ+
 CROwUmQo+FGR3fEMONqbjZ/3JO6LOEOftyoQfirR7z3b7qtZv1yn46bZHvPn2jERadus
 hsPVBwn0h8J/W7OWMrgiqsrvsRSjglh17Y6Pfl2hjkFLrOXJ0wXutWhJ+Pxwf2Dc7Vsu
 Jhr8+44dzXjsdnPbOFjEotBDfzDtrBv2pYxTyRiGD9gEwfPcs9+lYO7dxU+eCFXkF/Nz
 ODUlynckmwLNDOgLfLbZyaAzE6//1w6ozNX0MOegwd+gaZoxPqIY5opcO3JYyaf2tQbK aA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30s09rc7ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 18:59:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046Iunl3060927;
        Wed, 6 May 2020 18:59:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdw4vjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 18:59:26 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 046IxPMK014980;
        Wed, 6 May 2020 18:59:25 GMT
Received: from localhost (/10.159.237.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 11:59:24 -0700
Date:   Wed, 6 May 2020 11:59:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/28] xfs: refactor recovered EFI log item playback
Message-ID: <20200506185923.GB6714@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
 <158864112169.182683.14030031632354525711.stgit@magnolia>
 <20200506151812.GR7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506151812.GR7864@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9613 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 06, 2020 at 08:18:12AM -0700, Christoph Hellwig wrote:
> > +static const struct xfs_item_ops xfs_efi_item_ops = {
> > +	.iop_size	= xfs_efi_item_size,
> > +	.iop_format	= xfs_efi_item_format,
> > +	.iop_unpin	= xfs_efi_item_unpin,
> > +	.iop_release	= xfs_efi_item_release,
> > +	.iop_recover	= xfs_efi_item_recover,
> > +};
> > +
> > +
> 
> I guess we can drop the second empty line here.
> 
> >  		switch (lip->li_type) {
> >  		case XFS_LI_EFI:
> > -			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
> > +			error = lip->li_ops->iop_recover(lip, parent_tp);
> >  			break;
> >  		case XFS_LI_RUI:
> >  			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
> > @@ -2893,7 +2853,9 @@ xlog_recover_cancel_intents(
> >  
> >  		switch (lip->li_type) {
> >  		case XFS_LI_EFI:
> > -			xlog_recover_cancel_efi(log->l_mp, ailp, lip);
> > +			spin_unlock(&ailp->ail_lock);
> > +			lip->li_ops->iop_release(lip);
> > +			spin_lock(&ailp->ail_lock);
> 
> This looks a little weird, as I'd expect the default statement
> to handle the "generic" case.  But then again this is all transitional,
> so except for minor nitpick above:

Hmm, that does make more sense; I'll change it.

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
