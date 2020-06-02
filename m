Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7390EC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 00:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53B91206A4
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 00:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aKqvzyAE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgFBAJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 20:09:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36806 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgFBAJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 20:09:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05206ZxF127373;
        Tue, 2 Jun 2020 00:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iMZYfltTJ/+xdvBPhzscRuOKN8RsYslJJw85eX4DoB8=;
 b=aKqvzyAENATozFXJHU70Urk1HzPMPZz2OxW07oaBN5GxuLutj4lven4zJRUV7zw1fPC+
 4GBiVN7Zs13kOJ7xSip3ycAXuN3Dwwgfsqkb+BBDMkHiYWzhqezj82Zpk+paVvrmI85i
 /fQWY7o1xaG9bLYHIAZkTFn/CXJw+rXrAknwYqWej54rxxIgQc3HpPAx5f1o8HWybsxa
 W6kvh415c0nz/yFXEJ14ksyHXeTXBYN2R5bZ7qvhzwmK3C2mEHWI1fqQPv5mbjBcYlxl
 DNCAWzhaUJuZH00cdTvO1wd1D42lXfWT9hT7zo7WLhI3KUx0EEKLHYIhRap4466im7nK zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem19n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 00:09:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05207siT112815;
        Tue, 2 Jun 2020 00:09:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25m4pyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 00:09:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05209kJ7014300;
        Tue, 2 Jun 2020 00:09:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 17:09:46 -0700
Date:   Mon, 1 Jun 2020 17:09:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 00/14] xfs: widen timestamps to deal with y2038
Message-ID: <20200602000945.GF2162697@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <CAOQ4uxjhrW3EkzNm8y7TmCTWQS82VreAVy608X7naaLPfWSFeA@mail.gmail.com>
 <20200526155724.GJ8230@magnolia>
 <CAOQ4uxgq+i1+q1=_bT=M_HoWWMuDaA8dqQK3m+iJZ8d+LBgA0w@mail.gmail.com>
 <CAOQ4uxi7k0YP4gavw+Zd1jcxMmnpaic6iQ=uALRsxgsFReUhdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi7k0YP4gavw+Zd1jcxMmnpaic6iQ=uALRsxgsFReUhdw@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006010177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 31, 2020 at 08:31:54PM +0300, Amir Goldstein wrote:
> > > I plan to rebase the whole series after 5.8-rc1, but if you'd like to
> > > look at the higher level details (particularly in the quota code, which
> > > is a bit murky) sooner than later, I don't mind emailing out what I have
> > > now.
> > >
> >
> > No need. I can look at high level details on your branch.
> > Will hold off review comments until rebase unless I find something
> > that calls for your attention.
> >
> 
> I went over the code in:
> a7091aa0d632 xfs: enable big timestamps
> 
> I did not find any correctness issues.
> I commented on what seems to me like a trap for future bugs
> with how the incore timestamps are converted.
> 
> So besides "widen ondisk timestamps" and "enable bigtime for quota timers",
> feel free to add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> For patches that do not change on rebase.

Ok, thanks for the first round of review!  See you after -rc1. :)

--D

> Thanks,
> Amir.
