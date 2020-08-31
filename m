Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02E32C433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C46DF20719
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 15:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pkax6gqu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHaP66 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 11:58:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42730 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgHaP65 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 11:58:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFs49l169453;
        Mon, 31 Aug 2020 15:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IAwApCEQArX0adqYPz8ally3+AcVONtaz5qoVxZZyxk=;
 b=pkax6gquyxfd5GkCk/XurEn/b64lFFTZvJPkOWaNDI/dWgOb4XpNULn4omHVN6QrcCyd
 4s5KjIM1Gc1/XeG34EtXwiSOicAmOmUaTHVBYSz2EtRbWv1aBhceyiPfuwXZ54cgem4q
 AiVH2wxZmz5JxojXGJjs3m0bjg9QOCRIUEcQw5wZ3HwJJaNn1qGZVXrQx6FnhwLvfYaQ
 NZPqWrjCl527xyTqnL8nDiQKFfe71K+HNXP8z/VDT2302z9FUh4sttl0Eg1+gt4LQaZm
 a7SvZ7xSaQ0c65OBpPJIYB3vnBnV3Z1qAzEY6Wd8l8+QvQSLycJZjzeDDgGiV6AVSM3Y EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 337eyky1vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 15:58:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VFtbda063750;
        Mon, 31 Aug 2020 15:58:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3380xuxrhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 15:58:48 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VFwjpc021605;
        Mon, 31 Aug 2020 15:58:45 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 08:58:44 -0700
Date:   Mon, 31 Aug 2020 08:58:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v5 00/11] xfs: widen timestamps to deal with y2038
Message-ID: <20200831155848.GF6096@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <CAOQ4uxh+fLzGTVbXEB8L__jVQCbw53GxcYYv96=2N0-piHz4-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh+fLzGTVbXEB8L__jVQCbw53GxcYYv96=2N0-piHz4-Q@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310094
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310094
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 31, 2020 at 11:07:14AM +0300, Amir Goldstein wrote:
> On Mon, Aug 31, 2020 at 9:08 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > Hi all,
> >
> > This series performs some refactoring of our timestamp and inode
> > encoding functions, then retrofits the timestamp union to handle
> > timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
> > to the non-root dquot timer fields to boost their effective size to 34
> > bits.  These two changes enable correct time handling on XFS through the
> > year 2486.
> >
> > On a current V5 filesystem, inodes timestamps are a signed 32-bit
> > seconds counter, with 0 being the Unix epoch.  Quota timers are an
> > unsigned 32-bit seconds counter, with 0 also being the Unix epoch.
> >
> > This means that inode timestamps can range from:
> > -(2^31-1) (13 Dec 1901) through (2^31-1) (19 Jan 2038).
> >
> > And quota timers can range from:
> > 0 (1 Jan 1970) through (2^32-1) (7 Feb 2106).
> >
> > With the bigtime encoding turned on, inode timestamps are an unsigned
> > 64-bit nanoseconds counter, with 0 being the 1901 epoch.  Quota timers
> > are a 34-bit unsigned second counter right shifted two bits, with 0
> > being the Unix epoch, and capped at the maximum inode timestamp value.
> >
> > This means that inode timestamps can range from:
> > 0 (13 Dec 1901) through (2^64-1 / 1e9) (2 Jul 2486)
> >
> > Quota timers could theoretically range from:
> > 0 (1 Jan 1970) through (((2^34-1) + (2^31-1)) & ~3) (16 Jun 2582).
> >
> > But with the capping in place, the quota timers maximum is:
> > max((2^64-1 / 1e9) - (2^31-1), (((2^34-1) + (2^31-1)) & ~3) (2 Jul 2486).
> >
> > v2: rebase to 5.9, having landed the quota refactoring
> > v3: various suggestions by Amir and Dave
> > v4: drop the timestamp unions, add "is bigtime?" predicates everywhere
> > v5: reintroduce timestamp unions as *legacy* timestamp unions
> 
> I went over the relevant patches briefly.
> I do not have time for thorough re-review and seems like you have enough
> reviewers already, but wanted to say that IMO v5 is "approachable" for
> novice xfs developers and I can follow the conversions easily, so that's
> probably a good thing ;-)

<nod> Thanks for the review!  Good to see you at LPC last week too!

--D

> Thanks,
> Amir.
