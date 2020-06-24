Return-Path: <SRS0=pOan=AF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F9AC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 14:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B2EC2072E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Jun 2020 14:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ajtbTHey"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403985AbgFXODi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 10:03:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55232 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404024AbgFXODh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 10:03:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ODuaJ9158278;
        Wed, 24 Jun 2020 14:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TyVjr4+jouIS8OWZJwJWTJ5HOA45okGEfTLdyJNkI8w=;
 b=ajtbTHeyupmwLFPfUVQdjHvJ8R2tv6Xocl9KSN9eUDB9EMSJEkPS639QRV6lvq1F5vj/
 hSB0hWBvXmcl7W4TUThzFUFZ/LYLJnTGETuL2PqTgY0xdhcRl6TEDyXuxqNfatNJH9yc
 ogeD+ff5RaXG2o104zhM4eAhFnCkppVYtMwOTTMZtjIYEFHdETTMutmyQSAsz+N3X7VJ
 U2qVpoCwUPJuL5hNCmCKhfZHMqVZDBc7WdJWe9/Fsmnar7+Z5H8m1gng8thKJY3H7I5l
 OUSR4DYoeOWnTpiSyErv8CsUeBqOho9fJ5CmSMB2Bce4pffPKqKbrM0H1OrSZydF5STp Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31uut5k1nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 24 Jun 2020 14:03:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ODw8d0032319;
        Wed, 24 Jun 2020 14:03:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31uur6fhke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jun 2020 14:03:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05OE3Q3E003525;
        Wed, 24 Jun 2020 14:03:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jun 2020 14:03:26 +0000
Date:   Wed, 24 Jun 2020 07:03:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/15] xfs: move the di_flags2 field to struct xfs_inode
Message-ID: <20200624140325.GI7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-13-hch@lst.de>
 <83835142.PHEsXu1aPz@garuda>
 <113775697.lumUs5xBWa@garuda>
 <20200624072537.GC18609@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624072537.GC18609@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1
 phishscore=0 impostorscore=0 cotscore=-2147483648 priorityscore=1501
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006240101
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 09:25:37AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 22, 2020 at 06:53:23PM +0530, Chandan Babu R wrote:
> > On Monday 22 June 2020 6:21:37 PM IST Chandan Babu R wrote:
> > > On Saturday 20 June 2020 12:40:59 PM IST Christoph Hellwig wrote:
> > > > In preparation of removing the historic icinode struct, move the flags2
> > > > field into the containing xfs_inode structure.
> > > >
> > > 
> > > The changes look good to me.
> > > 
> > > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > 
> > The commit "fs/xfs: Update xfs_ioctl_setattr_dax_invalidate()"
> > (e4f9ba20d3b8c2b86ec71f326882e1a3c4e47953) adds the function
> > xfs_ioctl_setattr_prepare_dax() which refers to xfs_icdinode->di_flags2. A
> > rebase should solve this issue.
> 
> That doesn't exist in xfs/for-next yet.  Darrick, do you want me to
> rebase on top of Linus' tree?

Sure?  I haven't really started working on 5.8 fixes branches yet,
but I'll fast-forward for-next up to 5.8-rc1.

--D
