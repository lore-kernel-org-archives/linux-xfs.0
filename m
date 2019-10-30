Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBCACA9EC7
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 22:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47F1E20874
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 22:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NGRMsJT2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfJ3WSi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 18:18:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42158 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfJ3WSi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 18:18:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UMDs0n170350;
        Wed, 30 Oct 2019 22:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=997q3/rxOEsewbFCvvhVN4n9yWYBI+gcbkAMjLXO5IQ=;
 b=NGRMsJT2XmOTSqT2FV11AgUG5uwjtUwf0yvRDGtaauTMLGwFrSxzTjD9eHV5vC6KD+zO
 aj7TNMRPQyhM3k0dzx+nfPoJxsYdx9oEK4wWs8PuEJMTzVM4Eeno9RXzW8D23HaSDfcn
 /3kTE3K/lx9uegCZJSpCaYguXtYPWK5/MTa9R+9oXP78lcnlc2TU3qxkNdQA/4TI1xoV
 +qhzNA8gvESGziWOLt/ih8SEFDMWGY2XSppljBDNmoe1mGejQTROHQHLrkB7f9DHWQC2
 mYMPtSCdpXRlWhWspvvnZ6lUlgwzNSJh5D/0rkqUZChYythjtUDzMtz0S/LKk1x3wuZN VQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vxwhfq9dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 22:18:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9UMI0uA142349;
        Wed, 30 Oct 2019 22:18:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vxwjard4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 22:18:26 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9UMIP5x020548;
        Wed, 30 Oct 2019 22:18:25 GMT
Received: from localhost (/10.145.178.60)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Oct 2019 15:18:25 -0700
Date:   Wed, 30 Oct 2019 15:18:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: namecheck directory entry names before listing
 them
Message-ID: <20191030221825.GU15222@magnolia>
References: <157198048552.2873445.18067788660614948888.stgit@magnolia>
 <157198050564.2873445.4054092614183428143.stgit@magnolia>
 <20191025125628.GD16251@infradead.org>
 <20191025160448.GI913374@magnolia>
 <20191029071615.GB31501@infradead.org>
 <20191029162330.GD15222@magnolia>
 <20191030213202.GA24872@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030213202.GA24872@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910300197
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9426 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910300196
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 30, 2019 at 02:32:02PM -0700, Christoph Hellwig wrote:
> On Tue, Oct 29, 2019 at 09:23:30AM -0700, Darrick J. Wong wrote:
> > > So we'll at least need to document that for now.  And maybe find a way
> > > to not do the work twice eventually in a way that doesn't break repair.
> > 
> > What if we promote EFSCORRUPTED and EFSBADCRC to the vfs (since 5
> > filesystems use them now); change the VFS check function to return that;
> > and then we can just drop the xfs readdir calls to dir2_namecheck?

Having looked more carefully at verify_dirent_name(), I now think XFS
shouldn't drop the xfs_readdir calls to dir2_namecheck because the VFS
namecheck function permits nulls in the middle of the name.  Linus says
the function does that intentionally because (in his opinion) userspace
expects a null terminated string and won't care if namelen is longer
than that.

> EFSCORRUPTED should have moved to common code a long time ago, so that
> is overdue.  Not sure about EFSBADCRC, but that might not be a horrible
> idea either.

We might as well, since ext4 and XFS both standardized on both of those
error codes.

Hm, btrfs uses EUCLEAN and EIO for EFSCORRUPTED and EFSBADCRC,
respectively.  We probably ought to get them on board too.

--D
