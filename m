Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EDBC83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 20:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12810206D9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 20:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x8AgWa/a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgD1Uqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 16:46:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgD1Uqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 16:46:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SKcooI021461;
        Tue, 28 Apr 2020 20:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CkNHKmbdpUS2pc4sNOqDYMBYEi0B0Kc8b7TdM9qmU4E=;
 b=x8AgWa/afXCQBIKxBwF5d1Vyg/A4MGIdmiRgoO5+8thW2CzkdWKSvR5hNeHSofPsfZa9
 QbxzSDmcn5Erbg7u4SNq/ULA4OMNKoTOLj2aKmX1Up21XP9/MMp4exCvJTCvN9+VPSej
 Nkeqv+8KQNlPMhVf5rQN+87deATTuw5INCcWCwRHBXgzVnrOCOZyVpqz0oJ+uUsw+JBA
 qo7s1PF/05WFIUV2ZVKDqrcAIWvc1+g4JKjKUg3D6knCh+ZtGnjgI5/6d0WB7QGzBrZ/
 zygn4lZUuOUT8bqDQ6DLkMyX2/fu+1/B92s3gRH0m6eFj+PT4U56Fxz42HK8XbsmsZv+ Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucg2amy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 20:46:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SKbAhO147999;
        Tue, 28 Apr 2020 20:46:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my0eb2hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 20:46:30 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03SKkOKB021379;
        Tue, 28 Apr 2020 20:46:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 13:46:24 -0700
Date:   Tue, 28 Apr 2020 13:46:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/19] xfs: refactor log recovery item sorting into a
 generic dispatch structure
Message-ID: <20200428204623.GF6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752117554.2140829.4901314701479350791.stgit@magnolia>
 <20200425181307.GA16698@infradead.org>
 <20200427220412.GY6742@magnolia>
 <20200428051154.GA24105@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428051154.GA24105@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 10:11:54PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 27, 2020 at 03:04:12PM -0700, Darrick J. Wong wrote:
> > > > +	case XFS_LI_INODE:
> > > > +		return &xlog_inode_item_type;
> > > > +	case XFS_LI_DQUOT:
> > > > +		return &xlog_dquot_item_type;
> > > > +	case XFS_LI_QUOTAOFF:
> > > > +		return &xlog_quotaoff_item_type;
> > > > +	case XFS_LI_IUNLINK:
> > > > +		/* Not implemented? */
> > > 
> > > Not implemented!  I think we need a prep patch to remove this first.
> > 
> > The thing I can't tell is if XFS_LI_IUNLINK is a code point reserved
> > from some long-ago log item that fell out, or reserved for some future
> > project?
> > 
> > Either way, this case doesn't need to be there.
> 
> The addition goes back to:
> 
> commit 1588194c4a13b36badf2f55c022fc4487633f746
> Author: Adam Sweeney <ajs@sgi.com>
> Date:   Fri Feb 25 02:02:01 1994 +0000
> 
>     Add new prototypes and log item types.
> 
> 
> In the imported tree, which only added the definition, and no code
> related to it.  I can't find any code related to it either in random
> checkpoints.

<nod> Dave told me on IRC that it was added in 1994 but never used, so
it's safe to get rid of it entirely.

--D
