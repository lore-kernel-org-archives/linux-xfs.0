Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636BCC432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 05:47:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33FA72068E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 05:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hl/DEPEr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfKUFrJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 00:47:09 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60516 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKUFrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 00:47:09 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL5jEHi084866;
        Thu, 21 Nov 2019 05:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Sw3SQPLyZyPbEaIz3bp8Lx4/IRI8nvELo5r/uV3fbxo=;
 b=Hl/DEPErOnMCzpgAblMPBb6M3IMwe+ym/MbnvcHqSHOSpMWju+3uyt+deTYpaDyuqbCp
 auD9edT83DkF+BwIX/pXsx4mjf0Mbb5wXAzo81ZUU+rKVywUwgMyoCIzW4dzkiD3m+6v
 wMcqn4Ns0Ub48boWpXqzYJTDfTBlXuNFtRK7UrEs5pfUXaHyHTMYGwmqdvs4bIor9P3b
 6PzEWg6GNyDsXCVCOt/+KaKnSGfbjf3DpfmYR2WcgHCudPkcXEMxHv5yO1jZdwhSKWmv
 CxtWD/dD37b13G2onn7Gbzc4hkzGtD44eFdpqkNpOxRGBRxPx46YVUOgAj6nWXf4UpiT Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rqsr04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 05:47:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAL5h4av023404;
        Thu, 21 Nov 2019 05:45:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wda05c161-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 05:45:04 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAL5ixaB008735;
        Thu, 21 Nov 2019 05:44:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 Nov 2019 21:44:59 -0800
Date:   Wed, 20 Nov 2019 21:44:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/10] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191121054458.GX6219@magnolia>
References: <20191120111727.16119-1-hch@lst.de>
 <20191120111727.16119-4-hch@lst.de>
 <20191120181708.GM6219@magnolia>
 <20191120182035.GA11912@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120182035.GA11912@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=708
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9447 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=774 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210052
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 07:20:35PM +0100, Christoph Hellwig wrote:
> On Wed, Nov 20, 2019 at 10:17:08AM -0800, Darrick J. Wong wrote:
> > > -	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
> > > -				&mapp, &nmap);
> > > +	error = xfs_dabuf_map(dp, bno,
> > > +			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
> > > +			whichfork, &mapp, &nmap);
> > >  	if (error) {
> > >  		/* mapping a hole is not an error, but we don't continue */
> > > -		if (error == -1)
> > > +		if (error == -ENOENT)
> > 
> > Shouldn't this turn into:
> > 
> > if (error || !nmap)
> > 	goto out_free;
> > 
> > Otherwise looks ok to me.
> 
> Yes, it should.  Looks like that hunk got lost in the reshuffle.

With that and the other change I mentioned, it seems to test ok.  Do you
want to respin the patch, or just let me keep my staged version?

--D
