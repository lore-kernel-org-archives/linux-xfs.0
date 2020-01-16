Return-Path: <SRS0=yxE5=3F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9369C33CAF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9558B20728
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jan 2020 22:42:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NCy2GnQ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387883AbgAPWmw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:42:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729994AbgAPWmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jan 2020 17:42:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMcJI1078944;
        Thu, 16 Jan 2020 22:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VK4Q8WvGSg9WLBYpSQ/IkxzJLj6bCRUO2ciYpT6DOik=;
 b=NCy2GnQ6V/5N3hOp9HsFUEdYggNuQYhSD4x2n5VGfENFDptOjdiZroTyZIu3LZev6Tu5
 /I00de/0p/COeB2wyWNUolEgNgruv3rHu0IS2xGREfqaMwowBCyVhiARtJXTsMAL5jV+
 u86oHmgtyrfkU38lYlFRMVSkSPkpUCD0ZqIFvVke9cHKn5lMKDO0WUhi5NFUzI1qep6Z
 /kq6j2ny8OhJi61LOghn/gjJJtM/c65it1kQ4zr5Xt9UUK3ERwowdaNKiyB8Z7tonrQE
 NAYdBQASMpcqAAaQO/jYqAiNXfHa+gpPhABls+m2pBzBvfVyvGyrl/fodlZpF+diu5Ln Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xf74sng6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:42:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00GMdK7F027001;
        Thu, 16 Jan 2020 22:40:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xjxp3wwtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 22:40:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00GMeiS4031441;
        Thu, 16 Jan 2020 22:40:44 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 14:40:43 -0800
Date:   Thu, 16 Jan 2020 14:40:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: make xfs_btree_get_buf functions return an
 error code
Message-ID: <20200116224041.GJ8247@magnolia>
References: <157910781961.2028217.1250106765923436515.stgit@magnolia>
 <157910787821.2028217.9307411154179566922.stgit@magnolia>
 <20200116163355.GI3802@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116163355.GI3802@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=962
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 16, 2020 at 08:33:55AM -0800, Christoph Hellwig wrote:
> > -		if (XFS_IS_CORRUPT(args->mp, !bp)) {
> > -			error = -EFSCORRUPTED;
> > +		error = xfs_btree_get_bufs(args->mp, args->tp, args->agno,
> > +				fbno, &bp);
> > +		if (error)
> 
> Should we keep the XFS_IS_CORRUPT checks in some form?   Not sure they
> matter all that much, though.

The XFS_IS_CORRUPT checks exist to report a corrupted filesystem, and
the only errors that the _get_buf* variants can return are runtime
errors like ENOMEM.

> >  	ASSERT(fsbno != NULLFSBLOCK);
> >  	d = XFS_FSB_TO_DADDR(mp, fsbno);
> > -	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
> > -	if (error)
> > -		return NULL;
> > -	return bp;
> > +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, bpp);
> 
> Maybe kill the local variable while you're at it?
> 
> >  	ASSERT(agno != NULLAGNUMBER);
> >  	ASSERT(agbno != NULLAGBLOCK);
> >  	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
> > -	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
> > -	if (error)
> > -		return NULL;
> > -	return bp;
> > +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, bpp);
> 
> Same here.

Will just get rid of them as you suggest later in this thread.

--D
