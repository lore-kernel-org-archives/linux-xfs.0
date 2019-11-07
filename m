Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A02C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 20:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A55C7206A3
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 20:42:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R3PrJaJL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfKGUmF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 15:42:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59296 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfKGUmE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 15:42:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7Kdn7l183760;
        Thu, 7 Nov 2019 20:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=omJ2X88pyWxFvOGZdrmUDDv0VsiNmhxdueOiuGgReZI=;
 b=R3PrJaJLEhuHDLq82kN5ky+48stv8GMdzahChZcZ3+9NKXKOjGDbz3Zgc7PWzDIp2wdY
 2lugmDtijP3K0HWTgPUHrTRQ0kG69qkbrekTAOMpIwoYFPgAJoAD3dsvTu+6TEpA2qH4
 sHxVLC3+eT/5T15OjLiNYgiIXNhy1cljv68PSdaBhjYgeRfdgNZunZ5+NZUm6Yuqeugn
 D9jmvz9Id0P7XH0z+9Xi8T9uBr1jhkTmnzsb+ofvXxlPOOOHE1Q3x8N9xmpV6qrfk2h9
 Gh90LQPkmXkjJZJlK9aau5cI1pJTtMqhlZnp4nmTBexRPmuDlYFzKs/PgpXcbYOyal7f Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w18xhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 20:41:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA7KYFAB114759;
        Thu, 7 Nov 2019 20:41:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w41wj4uf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Nov 2019 20:41:52 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA7Kfpwu011794;
        Thu, 7 Nov 2019 20:41:51 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 12:41:51 -0800
Date:   Thu, 7 Nov 2019 12:41:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191107204149.GD6219@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309576284.46520.16933998796526579184.stgit@magnolia>
 <20191107083450.GC6729@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107083450.GC6729@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 12:34:50AM -0800, Christoph Hellwig wrote:
> > -	while (xfs_btree_islastblock(acur.cnt, 0)) {
> > +	error = xfs_btree_islastblock(acur.cnt, 0, &is_last);
> > +	if (error)
> > +		goto out;
> > +	while (is_last) {
> 
> This transformation looks actually ok, but is highly non-obvious.
> I think you want a prep patch just killing the pointless while first.

Yeah, killing the while was a little more involved than I thought it
would be, but it's done.

--D
