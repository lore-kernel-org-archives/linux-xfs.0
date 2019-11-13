Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A44C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 05:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC4CB222D0
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 05:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oFNXcOJr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbfKMFUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 00:20:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfKMFUn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 00:20:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD5J7Xl005183;
        Wed, 13 Nov 2019 05:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dT5EO2bBkKQyzL1i8+WmHdMxXlZwfrFdq6+bjO2T+pM=;
 b=oFNXcOJrQrHfARm9y/uSe+zM/7+rtJO2Qw3vM+ke89+lpNueDy3EUrHzxa5QR4KXp+St
 ZrJ8Uqpie42bQg1WsVePzSoETSpbkKPC/Uvlo83QhSZQENMiuKbIaPGBLmJmsUcoEWis
 NypkQLQwjxeFYur+5kkhxhQqk2z+Yu+AEEu0wmlyT2+X4Hc58JY6UtUeGb4FweLxhyKM
 Gk/asmqmd8o25n/ndH7aUV1C+Ax3qGn0YTmB6duu+2LRsbwiZ2ftU3ZiF/7L/zIjRW55
 Ef7tYxDyEL9hdp4MyqF/kG1wvn0XCCbT/+mC2stnzcckizjGg+diW5Y4SI5RQjgxxczy 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndq9rmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 05:20:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD5J8hE146116;
        Wed, 13 Nov 2019 05:20:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w7j054ngw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 05:20:37 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD5KZqx001765;
        Wed, 13 Nov 2019 05:20:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 21:20:35 -0800
Date:   Tue, 12 Nov 2019 21:20:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [RFC][PATCH] xfs: extended timestamp range
Message-ID: <20191113052032.GU6219@magnolia>
References: <20191111213630.14680-1-amir73il@gmail.com>
 <20191111223508.GS6219@magnolia>
 <CAOQ4uxgC8Gz+uyCaV_Prw=uUVNtwv0j7US8sbkfoTphC4Z6b6A@mail.gmail.com>
 <20191112211153.GO4614@dread.disaster.area>
 <20191113035611.GE6219@magnolia>
 <CAOQ4uxi9vzR4c3T0B4N=bM6DxCwj_TbqiOxyOQLrurknnyw+oA@mail.gmail.com>
 <20191113045840.GR6219@magnolia>
 <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh0T-cddZ9gwPcY6O=Eg=2g855jYbjic=VwihYPz2ZeBw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 13, 2019 at 07:17:06AM +0200, Amir Goldstein wrote:
> >
> > Practically speaking I'd almost rather drop the precision in order to
> > extend the seconds range, since timestamp updates are only precise to
> > HZ anyway.
> >
> 
> FWIW, NTFS and CIFS standard is unsigned 64bit of 100 nanoseconds
> counting from Jan 1, 1601.
> 
> >
> > Heh, ok.  I'll add an inode flag and kernel auto-upgrade of timestamps
> > to the feature list.  It's not like we're trying to add an rmap btree to
> > the filesystem. :)
> >
> 
> Exactly.
> 
> > >
> > > All right, so how do we proceed?
> > > Arnd, do you want to re-work your series according to this scheme?
> >
> > Lemme read them over again. :)
> >
> > > Is there any core xfs developer that was going to tackle this?
> > >
> > > I'm here, so if you need my help moving things forward let me know.
> >
> > I wrote a trivial garbage version this afternoon, will have something
> > more polished tomorrow.  None of this is 5.6 material, we have time.
> >
> 
> I wonder if your version has struct xfs_dinode_v3 or it could avoid it.
> There is a benefit in terms of code complexity and test coverage
> to keep the only difference between inode versions in the on-disk
> parsers, while reading into the same struct, the same way as
> old inode versions are read into struct xfs_dinode.
> 
> Oh well, I can wait for tomorrow to see the polished version :-)

Well now we noticed that Arnd also changed the disk quota structure
format too, so that'll slow things down as we try to figure out how to
reconcile 34-bit inode seconds vs. 40-bit quota timer seconds.

(Or whatever happens with that)

--D

> Thanks,
> Amir.
