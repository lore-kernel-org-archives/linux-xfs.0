Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C353EC4CECD
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CE8520B1F
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 17:56:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cz0OJOAn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgD0R4A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 13:56:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgD0Rz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 13:55:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHtOMF155672;
        Mon, 27 Apr 2020 17:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SqEVD/uKt0SMLe1RNu5ksntPJxEXa2tBkQ1LGlaa+wo=;
 b=cz0OJOAn0PPiB3UOPCOX7FUtIf3fE1cEBe5a2wz++Fe1ZxrIKXqTgn6Nk190q4syFD0k
 +n+3kptoyaV6Zp40xzOe+I4xdrQW68tlb92IAuHiASB6TXX76ljXszsS3uQVNoWLyAyp
 emlaW6ZuPLlyZl6EJyI3N4fsbe0Bvjc6KBowEsJ/QNLpBBhyZqf6K9IYPo3zXrkAhamX
 jEdYgVCG0OwkrYH20eFdbiSFIynhEtl7G8V+muhP9pVot31xZgzTC0b8p9KM9SgmxyFu
 4n/FXi8oeVNOzDXXSYrJTVP5tLplfaxwc7Gf7I73WiyWV8XDgIwWkka5nuXwSwLF0fyF Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucfu563-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:55:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RHc1ju101950;
        Mon, 27 Apr 2020 17:55:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30mxwwp55k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 17:55:50 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RHtncL024989;
        Mon, 27 Apr 2020 17:55:49 GMT
Received: from localhost (/10.159.145.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 10:55:49 -0700
Date:   Mon, 27 Apr 2020 10:55:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/19] xfs: complain when we don't recognize the log item
 type
Message-ID: <20200427175548.GT6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752116938.2140829.6588657626837150802.stgit@magnolia>
 <20200425174210.GA16663@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425174210.GA16663@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 10:42:10AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 21, 2020 at 07:06:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're sorting recovered log items ahead of recovering them and
> > encounter a log item of unknown type, actually print the type code when
> > we're rejecting the whole transaction to aid in debugging.
> 
> The subject seems wrong - we already complain, we are just not very
> specific what we complain about as you mention in the actual commit log.
> 
> With a fixed subject:

ok, changed to:
"xfs: report unrecognized log item type codes during recovery"

--D

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
