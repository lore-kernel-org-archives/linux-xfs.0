Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D85C2D0E2
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 708C22344C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qH7+gcqz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgIXPJI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:09:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgIXPJH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 11:09:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OF4pVU097419;
        Thu, 24 Sep 2020 15:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D48ry8q0Y64WL/YiVIYNAN4K/D5FGDHwOnnYqCWBl44=;
 b=qH7+gcqz3gdOLTcMGHOQlEwx4cUDXsFKuRhYgOn6X7FgOMy+We1T0xFAmwWq3Xygl7Yu
 DMZWi+MN+T5NuOiBojcCMKau2tYEWQgxUy6K7O4fUW0jnYHGfv3gBkRsuss7vg2OFDjm
 iUfs5mrDhmxlgxa10hRODTUCm6QPe5lBuDlR0OMsp756uKdcGq+BHjXiFhgiR9WLTNOw
 UzWbIhuQ4K5VT+jkeH7Mlmpy/+TYjsLHAKuhoJfGD0ULuuV9amno2ZMbOYETsVzz8GXc
 h33SIgxblpRhie7hOn/B7oAFQiIKRGqeH8AQ4SoI8zCFtRivJ1jZE6QDa8XzuDkNznXy UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnurwmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 15:08:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OF5TL2192119;
        Thu, 24 Sep 2020 15:06:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33nux2wavt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 15:06:57 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08OF6un1015349;
        Thu, 24 Sep 2020 15:06:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 08:06:56 -0700
Date:   Thu, 24 Sep 2020 08:06:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: coordinate parallel updates to the rt bitmap
Message-ID: <20200924150656.GE7955@magnolia>
References: <20200923182437.GW7955@magnolia>
 <20200924054041.GA21542@infradead.org>
 <20200924060001.GZ7955@magnolia>
 <20200924061911.GB27289@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924061911.GB27289@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240116
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 07:19:11AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 23, 2020 at 11:00:01PM -0700, Darrick J. Wong wrote:
> > > > +	struct aglock		*lock = &ag_locks[(signed)NULLAGNUMBER];
> > > 
> > > Err, what is this weird cast doing here?
> > 
> > Well.... ag_locks is allocated with length ag_locks[agcount + 1], and
> > then the pointer is incremented so that ag_locks[-1] is the rt lock.
> 
> At least in the for-next branch it isn't:
> 
> 	ag_locks = calloc(mp->m_sb.sb_agcount, sizeof(struct aglock));
> 
> More importantly, I can't even find other uses of ag_locks for the
> RT subvolume.  Is this hidden in one of your series?

Doh.  Yes, it is, in the realtime rmap series. :( :(

> Either way I think a separate lock for the RT subvolume would make a
> whole lot more sense.

Yes, let's do it that way.

--D
