Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5F5C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD3D20716
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:24:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ljmiUVLa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgAZWYE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:24:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43574 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgAZWYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:24:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMJ0n9030705;
        Sun, 26 Jan 2020 22:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mygoA9D2KDzZvL/VYE4E1MajQb3g9aJD7uTqFnU9qUI=;
 b=ljmiUVLakf7R0Z4FaEFeZrIqMXB7UKfnqAgiHS7AmGgUJLWVgCiVC0Ar1iO5/Z0SZUmc
 nDou6pOcsgoPcRwx/8t4OhFL9ML8PiRdV6JceMgqKS2HOESJZ9SpGEyzNIfRYsxuSUFZ
 KemCjbhnaReh1bHz93fxitboMKq6Pbi2EkVUMiIYHkiDEOwXNzaXnCspoa89fvSM0/H9
 sS5q3QW7e5Q01UoL59eTJwQ2u6YBbZRhQhFnXP7lrfN/39Nzu8AUNfKknClNlOrB6nkq
 gLOZ2zJwC2VrBl7ooD/0iAlW/JUUXg0S6xi5tKwETROh+dCCBIk/MRlKLcueDHF+8jFr TA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xrdmq4fjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:23:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMJawO175749;
        Sun, 26 Jan 2020 22:23:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xry6nc9kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:23:56 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00QMNu2v012080;
        Sun, 26 Jan 2020 22:23:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:23:55 -0800
Date:   Sun, 26 Jan 2020 14:23:54 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/29] xfs: merge xfs_attr_remove into xfs_attr_set
Message-ID: <20200126222354.GJ3447196@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-3-hch@lst.de>
 <20200121172853.GC8247@magnolia>
 <52723c8f-1634-424c-e1b6-d3195304fc15@oracle.com>
 <20200125232259.GA30917@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125232259.GA30917@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260194
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260194
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 25, 2020 at 03:22:59PM -0800, Christoph Hellwig wrote:
> On Fri, Jan 24, 2020 at 09:17:15PM -0700, Allison Collins wrote:
> 
> [full quote deleted, please follow proper mail netiquette]
> 
> > > (The first thing my brain thought was, "ENOATTR on a set operation
> > > suggests to me that something's seriously broken in the attr code; why
> > > would you mask it?")
> > > 
> > > --D
> > 
> > Would either of you mind if I were to pick up this patch and make a mini set
> > that resolves some of the overlap between our sets?  I'll fix the nits here.
> > Let me know, thanks!
> 
> I'd rather resend the whole thing - it fixes various issues with the
> attr flags handling and removes lots of codes.  I'll try to do so today,
> but Darrick can decide if he just wants to pick parts if that makes life
> easier.

/me would sort of like to keep the whole set together, but I'm pretty
sure we're out of time for 5.6, so ... if there are any patches that are
straight bugfixes, please flag them as such when you resend.

--D
