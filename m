Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0ADC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09F192076E
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:25:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jqJuByB5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgHRPZc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:25:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgHRPZa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:25:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF7oPF058170;
        Tue, 18 Aug 2020 15:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0M2d49ZTrODkNPmKwGu/GadYp01feo/vCURdWwjRads=;
 b=jqJuByB5GLH1rMG3Sey15zuHlgAtrdkR+aNZTVIq3gHYlLjtWq665urMQIRege/DEHFk
 n58K+Ojyj3ceLLt4QVLnwZDSzQSc+QYdel6RHltvKzcYZB/3JWkUW27oONOI25vmRZWt
 5+WLaKOEFG5XL1sTHM9C3rHcKVu12naeFy5IwYS9iNv5q+g/ClQtuHgNVoh88q1tQwbU
 0KAGSxTosS4un1qU5t6T/v10uPmf0+XmnFba7VZudGSCW59lhzQ9AQR1Tc/tkR0S8a4w
 dNTaNc9781zDq60pBfMNHdJTcqlLorp+x/V5ut0911D4XQ56NO7XDq1JDmxfkI9kFF9E +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nmdhdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:25:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF7mhB119437;
        Tue, 18 Aug 2020 15:25:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32xsm342g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:25:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IFPP1l030135;
        Tue, 18 Aug 2020 15:25:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:25:24 -0700
Date:   Tue, 18 Aug 2020 08:25:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 03/18] xfs: refactor quota expiration timer modification
Message-ID: <20200818152523.GO6096@magnolia>
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
 <159770515211.3958786.7094290347539609121.stgit@magnolia>
 <CAOQ4uxjKta9UgtJ6rWE4Wy9hxGGGJOOxu+LuLY0Mf5i1kR69Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjKta9UgtJ6rWE4Wy9hxGGGJOOxu+LuLY0Mf5i1kR69Ew@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180111
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:21:59PM +0300, Amir Goldstein wrote:
> On Tue, Aug 18, 2020 at 2:24 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Define explicit limits on the range of quota grace period expiration
> > timeouts and refactor the code that modifies the timeouts into helpers
> > that clamp the values appropriately.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There is no refactoring here, but I suppose you want to keep the commit
> names aligned with kernel commits, so

FWIW, these patches of mine where (1) 'xfs: ' is in the subject; (2) the
changes only touch things in libxfs and the bare minimum to avoid build
breakage; and (3) whose commit log don't really match the changes are
straight ports of the kernel-space patches.

I hesitate to use the libxfs-apply script for these patches (even though
Eric will do that when he's resyncing for real) because the source
commit ids will probably never match what ends up in Linus tree.

I don't know if anyone /else/ follows this convention, but in my
xfsprogs series, I try to prefix patches that change /only/ userspace
libxfs with the tag 'libxfs: ', so that reviewers can spend more time on
the patches that tag either libxfs directly or some userspace program.

That said, this is really not obvious.  I've wondered if I should amend
libxfs-apply to be able to quote the source commit subject line so that
it's more obvious when a patch is simply a userspace port.  Would that
help?

--D

> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
