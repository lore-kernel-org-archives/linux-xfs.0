Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262D3C2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC1562071A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hX1c30WP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfLXQrj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 11:47:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLXQrj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 11:47:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGiT8X098648;
        Tue, 24 Dec 2019 16:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kYfm2KG9tqvqGVMMKheJxao/38Iw4s+jZ5wAmaOvMTs=;
 b=hX1c30WPZY0EQqkX4GI06KxpdrJbu517+1BlKJ92oxC8v+k4Vi0Xs7bhPA1jfVzxvw+4
 e/nAXIeQig8wFMQd6u6CnDqx4eS6hX2csRjQn1U98JEJnNCGxB29UNeRQtqvQugeOyZ2
 v7PkfVQO0PJ5HlUSPgOnvxK24nWNDzmh/3p9XANrGCeinaX/zXnzHkoCxRb2j1I9OXM4
 A06mE/IBCoYdko91JGvnCrFq0JL9+6ywjPIkHqMYPBoozGQtkdHhDlSU5UhquNBIT92k
 T6xeXpRqFcCcCZIYMyiFndvs0nxkUr/Lj4vGKerzup3Xfjm/v1w3j9o0VhEA40scDHaU hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x1bbpvdsf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:47:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGiLM3095248;
        Tue, 24 Dec 2019 16:45:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x3nn5hm46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:45:30 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBOGjTVO028890;
        Tue, 24 Dec 2019 16:45:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 08:45:29 -0800
Date:   Tue, 24 Dec 2019 08:45:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191224164528.GZ7489@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
 <20191218023726.GH12765@magnolia>
 <20191218121033.GA63809@bfoster>
 <20191218211540.GB7489@magnolia>
 <20191219115550.GA6995@bfoster>
 <20191220201717.GQ7489@magnolia>
 <20191224112845.GC24663@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224112845.GC24663@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 03:28:45AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 20, 2019 at 12:17:17PM -0800, Darrick J. Wong wrote:
> > I think directio completions might suffer from the same class of problem
> > though, since we allow concurrent dio writes and dio doesn't do any of
> > the ioend batching that we do with buffered write ioends.
> 
> OTOH direct I/O completions are per-I/O, and not per-extent like
> buffered I/O completions.  Moreover for the case where we don't update
> i_size and don't need a separate log force (overwrites without O_SYNC
> or using fua) we could actually avoid the workqueue entirely with just
> a little work.

<nod>

> > It might also be nice to find a way to unify the ioend paths since they
> > both do "convert unwritten and do cow remapping" on the entire range,
> > and diverge only once that's done.
> 
> They were common a while ago and it was a complete mess.  That is why
> I split them.

And I couldn't figure out a sane way to make them work together so I
guess it's just as well. :)

--D
