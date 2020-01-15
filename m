Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B864C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 16:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F36132187F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 16:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XgM/H2ah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgAOQjz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:39:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgAOQjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 11:39:55 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGNIuR189863;
        Wed, 15 Jan 2020 16:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=rKpapYPtanmzfBNAC9pr4Vg7mZH6YevNH3Ff6vutGhc=;
 b=XgM/H2ahStjnVNFtdr30O+Z8MVIFl1wcwwX1euo572AQZS/zFMVlvWW8jBC6E3wxdcQo
 Wh0MW+0G2+C6tXx7oL6FRw5fwFgykkFq/W8WZiFDrz3cIbP6i2zaEvziKT1EXHb3mMgn
 1cXmwwsjXdPAt7iiBlNovRhoxsKN9CEVzLu3z9t9pPWlMMuD0e0p6k+FeFGKEhh8caWm
 4nBGuAL/rdoPo8XB/0HCszUKOkDjvwSUunctrXOhSCTtkrCTUHb9KoDMjg0NufTA78MS
 gzqMwL21XYsUyCB7qN4/jsIRaM8yJxbUTpQX9VwJvFYoM9is4K6U5rErxr14MhbWG4tU Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xf73yn8u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 16:39:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGOVUB119577;
        Wed, 15 Jan 2020 16:39:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1apsa6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 16:39:50 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FGdnNF019842;
        Wed, 15 Jan 2020 16:39:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 08:39:49 -0800
Date:   Wed, 15 Jan 2020 08:39:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink vs ThinLVM
Message-ID: <20200115163948.GF8257@magnolia>
References: <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
 <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
 <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 12:37:52PM +0100, Gionatan Danti wrote:
> On 14/01/20 09:45, Gionatan Danti wrote:
> > On 13/01/20 19:09, Darrick J. Wong wrote:
> > > xfs_io -c 'bmap -c -e -l -p -v <whatever>' test.img
> > 
> > Ok, good to know. Thanks.
> 
> Hi all, I have an additional question about extszinherit/extsize.
> 
> If I understand it correctly, by default it is 0: any non-EOF writes on a
> sparse file will allocate how much space it needs. If these writes are
> random and small enough (ie: 4k random writes), a subsequent sequential read
> of the same file will have much lower performance (because sequential IO are
> transformed in random accesses by the logical/physical block remapping).
> 
> Setting a 128K extszinherit (for the entire filesystem) or extsize (for a
> file/dir) will markedly improve the situation, as much bigger contiguous LBA
> regions can be read for each IO (note: I know SSD and NVME disks are much
> less impacted by fragmentation, but I am mainly speaking about HDD here).
> 
> So, my question: there is anything wrong and/or I should be aware when using
> a 128K extsize, so setting it the same as cowextsize? The only possible
> drawback I can think is a coarse granularity when allocating from the sparse
> file (ie: a 4k write will allocate the full 128k extent).
> 
> Am I missing something?

extszinherit > 0 disables delayed allocation, which means that (in your
case above) if you wrote 1G to a file (using the pagecache) you'd get
8192x 128K calls to the allocator instead of making a single 1G
allocation during writeback.  If you have a lot of memory (or a high vmm
dirty ratio) then you want delalloc over extsize.  Most of the time you
want delalloc, frankly.

--D

> Thanks.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
