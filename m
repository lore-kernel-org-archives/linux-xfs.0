Return-Path: <SRS0=oH8U=3G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79929C33C9E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 23:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4935B22464
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jan 2020 23:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pF6jokDf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgAQXo1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 18:44:27 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbgAQXo1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 18:44:27 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HNSwKO008683;
        Fri, 17 Jan 2020 23:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=i5kw4raycYbiJFke8q0cTHo1fPhqi6TbVMxw3BpJEuY=;
 b=pF6jokDf0x7zageCGEgILeh5WMRVVdEpQIPVIGC7nFZe7H93J7cItqZpIqEv1yMePTvI
 NyUvxDHaAqij58M1jYSeIYgowglL4UczkpipdlLjVGcTFSpD+9NLUcQfL0QdVHNvhZV0
 pZqgIoZUWMxpOEMV6ljXoqYcZAYfo5T7C/Dolw3eU7IMprE3TlvO8C9D6UjsO50w4Dlx
 IinEehikXdak3r9+9tSVA35MC7qyA2VpZL8ictE+3p5tx9o5Z3BFd04Ktuw/93VqZoyD
 FE90VGesTeYWRL/h4RDwnvZowwroL1jYXPu+/iMgKYSDdrosXxrezgltYJYwsmjOyB9u Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xf7403fjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 23:44:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00HNSutW064040;
        Fri, 17 Jan 2020 23:42:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xjxp60t1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 23:42:23 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00HNgKRR019255;
        Fri, 17 Jan 2020 23:42:22 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jan 2020 15:42:20 -0800
Date:   Fri, 17 Jan 2020 15:42:19 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gionatan Danti <g.danti@assyoma.it>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink vs ThinLVM
Message-ID: <20200117234219.GM8257@magnolia>
References: <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
 <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
 <20200113165341.GE8247@magnolia>
 <f61995d7-9775-0035-8700-2b92c63bd23f@assyoma.it>
 <20200113180914.GI8247@magnolia>
 <8e96231f-8fc6-b178-9e83-84cbb9af6d2e@assyoma.it>
 <9d8e8614-9ae1-30ee-f2b4-1e45b90b27f8@assyoma.it>
 <20200115163948.GF8257@magnolia>
 <761fcf8f9d68ee221a35d15c1a7120c5@assyoma.it>
 <e3dd598260d9f92c3b2c91cb81540e37@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3dd598260d9f92c3b2c91cb81540e37@assyoma.it>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 17, 2020 at 10:58:15PM +0100, Gionatan Danti wrote:
> Il 15-01-2020 18:45 Gionatan Danti ha scritto:
> > Let me briefly describe the expected workload: thinly provisioned
> > virtual image storage. The problem with "plain" sparse file (ie:
> > without extsize hint) is that, after some time, the underlying vdisk
> > file will be very fragmented: consecutive physical blocks will be
> > assigned to very different logical blocks, leading to sub-par
> > performance when reading back the whole file (eg: for backup purpose).
> > 
> > I can easily simulate a worst-case scenario with fio, issuing random
> > write to a pre-created sparse file. While the random writes complete
> > very fast (because they are more-or-less sequentially written inside
> > the sparse file), reading back that file will have very low
> > performance: 10 MB/s vs 600+ MB/s for a preallocated file.
> 
> I would like to share some other observation/results, which I hope can be
> useful for other peoples.
> 
> Further testing shows that "cp --reflink" an highly fragmented files is a
> relatively long operation, easily in the range of 30s or more, during which
> the guest virtual machine is basically denied any access to the underlying
> virtual disk file.

How many fragments, and how big of a sparse file?

--D

> While the number of fragments required to reach reflink time of 30+ seconds
> is very high, this would be a quite common case when using thinly
> provisioned virtual disk files. With sparse file, any write done at guest OS
> level has a very good chance to create its own fragment (ie: allocating a
> discontiguous chunk as seen by logical/physical block mapping), leading to
> very fragmented files.
> 
> So, back to main topic: reflink is an invaluable tool, to be used *with*
> (rather than instead of) thin lvm:
> - thinlvm is the right tool for taking rolling volume snapshot;
> - reflink is extremely useful for "on-demand" snapshot of key files.
> 
> Thank you all for the very detailed and useful information you provided.
> Regards.
> 
> -- 
> Danti Gionatan
> Supporto Tecnico
> Assyoma S.r.l. - www.assyoma.it
> email: g.danti@assyoma.it - info@assyoma.it
> GPG public key ID: FF5F32A8
