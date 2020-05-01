Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8472EC47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64BF22073E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bMdyoxWK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEAR6i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:58:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbgEAR6h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:58:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041HlT05035490;
        Fri, 1 May 2020 17:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Fdu7yW4BJj3SDdt2s+j9V3JoswQmuEuvvod/j0YJphQ=;
 b=bMdyoxWKx1NPGgBsVfQtfCm8u25O62Hctz34PVHKEOT3FIx5g/9iGWeaOg5p5O74Jf/h
 OMcVK18+cM/SWLxk6PLUfktko/r2b5MmuJjQnPSNGB7olfpe3euteX9aanjroS0RoA+F
 GbackRDVPJFqGjk4j0UWhMhjnc0s9KT7spW2fMY1049XQbemYQd2zLvurjTUhPevyFGy
 QJiIXlmKHE7XrIVYIXlN0LI51pU5LCJg6jWfdXBJrp6jkJP+0TMnUuaXdz4NJaHQ3HQs
 ZK8/zpG9+NoRzRNJ6ubRQmabttyKDR21wqR8pFys8IcijWFVrZ/LC9RX228fci4Rsgga zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30r7f83dfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 17:58:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041HmNMc109816;
        Fri, 1 May 2020 17:58:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30rbr5sm5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 17:58:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 041HwXOW020890;
        Fri, 1 May 2020 17:58:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 10:58:32 -0700
Date:   Fri, 1 May 2020 10:58:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/21] xfs: refactor recovered EFI log item playback
Message-ID: <20200501175832.GY6742@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820773902.467894.5745757511104582380.stgit@magnolia>
 <20200501101947.GA1201@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501101947.GA1201@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 03:19:47AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 29, 2020 at 05:48:59PM -0700, Darrick J. Wong wrote:
> > +STATIC int xfs_efi_recover(struct xfs_mount *mp, struct xfs_efi_log_item *efip);
> 
> Can you just move xfs_efi_item_ops down a bit to avoid the forward
> declaration?  Same for the other patches doing the same.

I can, but then I need a forward declaration of xfs_efi_item_ops,
because xfs_efi_init needs the symbol, and the ->create_intent function
inside the item_ops needs xfs_efi_init.

Still, a forward declaration of a static variable is easier to maintain
than a function decl, so I'll change it.

--D
