Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E12C64E7B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 806AE206B7
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 16:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m5+H6i1U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgLAQeF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:34:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgLAQeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Dec 2020 11:34:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GOtMP042620;
        Tue, 1 Dec 2020 16:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=B3xBuLIVS1P8ek+xBfwiD453SPBNWhB49zH092a6nKg=;
 b=m5+H6i1Uy8J9P+t0kpd/n8GXmvRVQXP7oIKOzkmH8oi7EFjt8OJk6RKMwNzLjwpgqhqY
 F6VsGKNL+nmbxBnmp8WdADSnOl/E3emw3ro3wjsCoxdrhuDznIt8JTao5aVtEV4CwI1t
 2GWQhA8HaQx7dgDPW6mT+qNRELaxUu0G+RZHEv9TJ8H1kGS7+BSQ6VCDF8rgeWA2IEdO
 Aaf+cwwvuUvkpqJplUfQmWmIoTXZxIyqEGPfjQkNhQURsZ3qGYqdN9aATPNbUWb9+HZD
 GHGSIuJVESCLIGGc+nu2YI07whT7QxyJJ7oHXYqX0BJUj5uw8duRhK8hUJonju4M5EZv Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egkkg7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 16:33:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1GPKMC028444;
        Tue, 1 Dec 2020 16:33:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540fx7p0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 16:33:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1GXG4C010060;
        Tue, 1 Dec 2020 16:33:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 08:33:16 -0800
Date:   Tue, 1 Dec 2020 08:33:14 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: improve the code that checks recovered rmap
 intent items
Message-ID: <20201201163314.GC143045@magnolia>
References: <160679385987.447963.9630288535682256882.stgit@magnolia>
 <160679388445.447963.9471776418395898485.stgit@magnolia>
 <20201201100535.GE10262@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201100535.GE10262@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 01, 2020 at 10:05:35AM +0000, Christoph Hellwig wrote:
> On Mon, Nov 30, 2020 at 07:38:04PM -0800, Darrick J. Wong wrote:
> > +	if (!xfs_verify_ino(mp, rmap->me_owner) &&
> > +	    !XFS_RMAP_NON_INODE_OWNER(rmap->me_owner))
> > +		return false;
> 
> Wouldn't it make sense to reverse the order of the checks here?

Yep.  Fixed.

> > +	end = rmap->me_startblock + rmap->me_len - 1;
> > +	if (!xfs_verify_fsbno(mp, rmap->me_startblock) ||
> > +	    !xfs_verify_fsbno(mp, end))
> >  		return false;
> 
> Nit: why not simply:
> 
> 	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
> 		return false;
> 	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
> 		return false;
> 
> ?

Yeah.

--D
