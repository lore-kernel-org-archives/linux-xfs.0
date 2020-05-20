Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351DCC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ADB920842
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IT92+Jnz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgETBrO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:47:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:47:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1lBxf027009;
        Wed, 20 May 2020 01:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NvgtAjMeMcsTDKCxs32G4AI/yqi+6YNFRbgdwpNnpOU=;
 b=IT92+JnzYjSir32hKgIY2Drmpo5ZMWa4JHPFWDVGYYte8ndx0klLzVHzbgXhxmzXIO/r
 EqQEZ9TDDIWzr0Q+vyzUt040EkRJNlNuC0RP/V4PmeCGW0wgA+VZis6n39IRfUKTTzeG
 /MsFdAdByhuvV1zRy7veeOC8HdKibvgGs9MmHAMmIL/9WEvZtL/txxHIXqN3r3iSMtQz
 w2TwxHp41UEGT9h+tnpV8w2vAxnL11vpehMONH9xycI8nh5m96cUvjmcl1IEnc9uLtgT
 x9I4ty2UlHzLMTM82/jP2LTvIophIIZsRbElV9sy2oYr4QhMD1LpkqbmHdYBdx4qGqQU Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127kr8jff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:47:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1h8Yh032600;
        Wed, 20 May 2020 01:45:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 312sxtudej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:45:06 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1j5bc024008;
        Wed, 20 May 2020 01:45:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:45:05 -0700
Date:   Tue, 19 May 2020 18:45:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: inode iterator cleanups
Message-ID: <20200520014504.GT17627@magnolia>
References: <20200518170437.1218883-1-hch@lst.de>
 <20200519012337.GE17635@magnolia>
 <20200519064017.GA24876@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519064017.GA24876@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 19, 2020 at 08:40:17AM +0200, Christoph Hellwig wrote:
> On Mon, May 18, 2020 at 06:23:37PM -0700, Darrick J. Wong wrote:
> > On Mon, May 18, 2020 at 07:04:31PM +0200, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > this series cleans up a bunch of lose ends in the inode iterator
> > > functions.
> > 
> > Funny, I was going to send a series next cycle that refactors a fair
> > amount of the incore inode iterators and then collapses the
> > free_cowblocks/free_eofblocks code into a single worker and radix tree
> > tag that takes care of all the speculative preallocation extent gc
> > stuff...
> > 
> > incore walks:
> > https://lore.kernel.org/linux-xfs/157784075463.1360343.1278255546758019580.stgit@magnolia/
> 
> Except for the last few those seem non-brainers tat would could merge
> ASAP..
> 
> The rest also doesn't look bad, so I'll happily defer this series.
> OTOH the first on really should go in, either your or my version :)

Well, I'll send the set for a formal review... :)

--D
