Return-Path: <SRS0=CRyL=CU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92BFC433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 04:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8293D221E7
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Sep 2020 04:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="afws8VhT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgIKErH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Sep 2020 00:47:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55846 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgIKErH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Sep 2020 00:47:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B4dniE166657;
        Fri, 11 Sep 2020 04:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=dTTCxjAZ072xcA8NxeoFcFdIfhRTE4+P0KPM6DJFuQ8=;
 b=afws8VhTdAFcsuBFHbnkQt0C835ehLiLy+z8uJ3Eu9Yac1dsvnJ8PemXUE1uvYvBZgPn
 MTjZCqyNI3Vwy2hccrTIi+nnWBW20d1RtVXW6UHAMlwMdBhvjDh9NeUOkUBK7eVBsy+P
 mJufhklrhXDBMzCUbXIVqZybRlB7Lle7srf59UsYoXPyHSsQUFqSgp9UO3lgLsrpYtwr
 kR7l69uHEBX9yD6jfw7VQCl9Ik2M4uYiSTaSvrCw3DD6KLupHBvUP/lEh4Azc2XCICn7
 ZaEfd5saXvxwm7fdmnOyyHyfX0GcBo7M5A8Q6ZnMWcT71i97aPuN1QGkE/B4fG3StnZU Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23rbw98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 04:46:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08B4jYch141848;
        Fri, 11 Sep 2020 04:46:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33cmewcvcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 04:46:58 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08B4ktTb032181;
        Fri, 11 Sep 2020 04:46:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 21:46:54 -0700
Date:   Thu, 10 Sep 2020 21:46:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "LinuxAdmin.pl - administracja serwerami Linux" <info@linuxadmin.pl>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: xfs_info: no info about XFS version?
Message-ID: <20200911044653.GS7955@magnolia>
References: <01aa416f70d0d780b337fb77756a88a8@linuxadmin.pl>
 <55432d32-83ed-fccd-52ff-70b36a75fd07@sandeen.net>
 <57839a674d8b54baafa40d2b002e19b5@linuxadmin.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57839a674d8b54baafa40d2b002e19b5@linuxadmin.pl>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=865 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=877 mlxscore=0 bulkscore=0 suspectscore=2 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110037
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 11, 2020 at 06:14:09AM +0200, LinuxAdmin.pl - administracja serwerami Linux wrote:
> W dniu 2020-09-10 22:44, Eric Sandeen napisał(a):
> > On 9/10/20 3:26 PM, LinuxAdmin.pl - administracja serwerami Linux wrote:
> > > 
> > > Hello,
> > > 
> > > why there is no info about XFS version on xfs_info?
> > 
> > Yeah, this is confusing.
> > 
> > TBH I think "V4" vs "V5" is a secret developer handshake.  Admins know
> > this as "not-crc-enabled" vs "crc-enabled"
> > 
> > Below is a V4 filesystem, due to crc=0
> 
> That's the point! How you will be determining the version number in V7?
> crc=3 xyz=0 abc=1?
> I know that is V4 (migration to V5 already planned!) but thinking the human
> way - it will be nice to have a simple info of used version :)

Seeing as most software goes downhill after V5 (Word, Windows, Notes...)
we intend to beat the averages by never introducing a V6, and expanding
the feature flags fields instead.

--D

> > -Eric
> > 
> > > # LANG=en_US.UTF-8 xfs_info /dev/sdb1
> > > meta-data=/dev/sdb1              isize=256    agcount=4,
> > > agsize=6553408 blks
> > >          =                       sectsz=512   attr=2, projid32bit=0
> > >          =                       crc=0        finobt=0, sparse=0,
> > > rmapbt=0
> > >          =                       reflink=0
> > > data     =                       bsize=4096   blocks=26213632,
> > > imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=0
> > > log      =internal log           bsize=4096   blocks=12799, version=2
> > >          =                       sectsz=512   sunit=0 blks,
> > > lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > 
> 
> -- 
> LinuxAdmin.pl - administracja serwerami Linux
> Wojciech Błaszkowski
> +48 600 197 207
