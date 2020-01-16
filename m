Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A74DC33CAF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D204220748
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:31:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iNbOs/Ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbgAPWbB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:31:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbgAPWbB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 17:31:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMSo5t036047;
        Thu, 16 Jan 2020 22:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=7fD1xy4NCgQLHogWcpG0RzphdWVt3v5Osz+peMEYFdc=;
 b=iNbOs/NscKgHwQ2kWEniwPA/kGIjZcWg3XZSRtt6s54+63BED7AF5bDeaEq39UAzFEtv
 09jiEbLNao0ysdtcShDxed/ExrnDe8vnp5R6KQOaaEurpnQraMpoWpVdpsOasu3tiEg5
 rneiM81HyQ1LA6hog64+vCLKEFjKZOuA6uosHfFmETGWiGqUfkQ6D9vZETWVISrbVS4L
 /riM7yMP1rtXxRzyCnNs1+iaYdBDktEwjIJEmMEMOgmwAMqw7H0TT5LZwMQgLkMNF+SW
 enU296DMcWBvNOusEngn0DIpRoUxT1XLCTsdzjg6XzWnpGsSE5R5Tf+Ag0/f6YuaueHs xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xf73u5d9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:30:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMTCT0003771;
        Thu, 16 Jan 2020 22:30:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xjxp3wj75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:30:47 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00GMUkbT016312;
        Thu, 16 Jan 2020 22:30:46 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 14:30:46 -0800
Date:   Thu, 16 Jan 2020 14:30:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: make xfs_buf_get return an error code
Message-ID: <20200116223043.GG8247@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910783855.2028217.9100808565121356587.stgit@magnolia>
 <20200116161642.GC3802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116161642.GC3802@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=664
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=741 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:16:42AM -0800, Christoph Hellwig wrote:
> On Wed, Jan 15, 2020 at 09:03:58AM -0800, Darrick J. Wong wrote:
> > -				 XFS_FSS_TO_BB(mp, 1));
> > +				 XFS_FSS_TO_BB(mp, 1),
> > +				 &bp);
> 
> Do we need the extra line here?

Whoops, will fix.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
