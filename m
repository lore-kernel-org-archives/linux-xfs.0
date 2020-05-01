Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31EFC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28BA2073E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GaWb3vpZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgEAR6s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:58:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60222 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbgEAR6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:58:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041HliFj006052;
        Fri, 1 May 2020 17:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NWBvjzekptehOQzNt2LsBL5SsS12mBFiM+eSZvxwSTI=;
 b=GaWb3vpZ6ZdjFHKGhaW73yo88Ob4stg8Kyu0YbIeLQvtQbiJuGu4BfO/0JxImMM2ODHk
 v1knim2MzwjYHbyNYFe3aGng4XIA5EZGRaGZrkHIxvrwwfP/cfXZjXrJzVYp/ZnXQIBr
 ZE3en0A8oFwJonyD4EB2TSNTt83d3zZdFfir90+ik6Q+dEl9TEGCCafkm7Kl49WRXPXt
 w7ubzhVsGNqEJsesG6xyhZgl7wYY7846ZgR6G6pFbFSfNDCf02rIFuiMeYmjB8nSZwim
 rVOuUebGx3U3mstuty/EQYL/F7HvzA0QymAnETsn4yKl3EoWxs8nxGujIB8qpudgsj9i OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30r7f5ucwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 17:58:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041Hl0CI059269;
        Fri, 1 May 2020 17:56:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30r7fbe3df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 17:56:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 041HuhsM001653;
        Fri, 1 May 2020 17:56:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 10:56:42 -0700
Date:   Fri, 1 May 2020 10:56:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/21] xfs: refactor log recovery EFI item dispatch for
 pass2 commit functions
Message-ID: <20200501175641.GX6742@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820771414.467894.16178249031828526203.stgit@magnolia>
 <20200501102844.GA13329@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501102844.GA13329@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 03:28:44AM -0700, Christoph Hellwig wrote:
> > +STATIC int
> > +xlog_recover_extfree_done_commit_pass2(
> > +	struct xlog			*log,
> > +	struct list_head		*buffer_list,
> > +	struct xlog_recover_item	*item,
> > +	xfs_lsn_t			lsn)
> > +{
> 
> ...
> 
> > +	return 0;
> > +}
> > +
> >  const struct xlog_recover_item_type xlog_extfree_intent_item_type = {
> > +	.commit_pass2_fn	= xlog_recover_extfree_intent_commit_pass2,
> >  };
> >  
> >  const struct xlog_recover_item_type xlog_extfree_done_item_type = {
> > +	.commit_pass2_fn	= xlog_recover_extfree_done_commit_pass2,
> >  };
> 
> Nipick: It would be nice to keep all the efi vs efd code together
> with their ops vectors?  Same for the other intent ops.

Ok, will do.

--D
