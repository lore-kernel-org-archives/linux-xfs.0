Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73129C4346E
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C50D235FD
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:02:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QHAuO8eT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgIXGCR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:02:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIXGCR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 02:02:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O5xFup005083;
        Thu, 24 Sep 2020 06:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AhTobEaVuDOU7R+snVSB9PTf/DPBREG4lzzz2I0HAQY=;
 b=QHAuO8eTn+qXy23/SNFi4koZsW3N4U6IrY44xxDq9sa+Roy9Qs5gYEmj0VS9piqk6FkL
 WAR4wAWxXd+YFVL3x87QqER35UReFrlY6n12pTXB4slexNDCbltkN3i6PCugALJTm9vi
 dBSdUhlfx1MhHSZtTD3bb0/NdYO1gC4lHG/3QzxJPLh5w4PLC/PMShWChqYBD049jUqQ
 AvdbwRMI60Qr384kIctKY0+uEdLdapml+uBkPQZSWCZYJim3rahtYos4AbdHKYWj/yXQ
 bj215EOETWIRK17RWpfqO9HcADLo7wU//HJ6z1NyM5XgB3xF2naHl4jOqIdMX++KmVSd oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33q5rgmfp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 06:02:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08O5tRbW018163;
        Thu, 24 Sep 2020 06:00:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33nux28htr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 06:00:03 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08O602s3026852;
        Thu, 24 Sep 2020 06:00:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 23:00:02 -0700
Date:   Wed, 23 Sep 2020 23:00:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: coordinate parallel updates to the rt bitmap
Message-ID: <20200924060001.GZ7955@magnolia>
References: <20200923182437.GW7955@magnolia>
 <20200924054041.GA21542@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924054041.GA21542@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=1 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240048
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 06:40:41AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 23, 2020 at 11:24:37AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Actually take the rt lock before updating the bitmap from multiple
> > threads.  This fixes an infrequent corruption problem when running
> > generic/013 and rtinherit=1 is set on the root dir.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/dinode.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/repair/dinode.c b/repair/dinode.c
> > index 57013bf149b2..07f3f83aef8c 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -184,6 +184,7 @@ process_rt_rec(
> >  	xfs_rfsblock_t		*tot,
> >  	int			check_dups)
> >  {
> > +	struct aglock		*lock = &ag_locks[(signed)NULLAGNUMBER];
> 
> Err, what is this weird cast doing here?

Well.... ag_locks is allocated with length ag_locks[agcount + 1], and
then the pointer is incremented so that ag_locks[-1] is the rt lock.

NULLAGNUMBER is cast to xfs_agnumber_t, which is uint32_t, so we have to
cast it back to signed so that we actually do the pointer subtraction(!)

Yeah, I know, it's nuts...

--D

> The rest looks sane.
