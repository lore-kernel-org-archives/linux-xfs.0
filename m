Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04CDC34056
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 17:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996992465D
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 17:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S3YR9Fa9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgBSRL4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 12:11:56 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44904 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgBSRL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 12:11:56 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JH9H9F040237;
        Wed, 19 Feb 2020 17:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zc5ALFd51qBvGVeDg4kRstYkwtJt2bDlZPl3iWWanck=;
 b=S3YR9Fa9MWJ60CYeLdg8oyfnFxcq63h6owUkGtTAMvYOfy0r6TE81DPEUHntJNINGllZ
 Fuj3qqm3D5kIchNDtl9Rs/ud5Z2TIBsEddJpDSiQB5QT8skC2brybXMl8AEzZdRNaR0e
 dVI2p4OyoflRT42QCkx8Xm00CwOrkcGJEXKhdITDPeh8HtaDxlDYmid8vdvA5igJjj3J
 ecUbCqMNgfzDxVdrtUhodJFSpvXJS5p06E/RZGjwLUa04D2OHPxy2U2hwCdfLQwOwKG1
 v3IQsxhNt9g7Be/YXGXXZTt2uJK2aMki0IKaPoaPQVnWknFwbgy+JyhyOMEEs1di7X2K lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y8udkcja3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 17:11:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01JH7bNH098976;
        Wed, 19 Feb 2020 17:09:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y8ud1jqqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 17:09:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01JH9l81024176;
        Wed, 19 Feb 2020 17:09:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 Feb 2020 09:09:47 -0800
Date:   Wed, 19 Feb 2020 09:09:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200219170945.GN9506@magnolia>
References: <20200219135715.GZ30113@42.do-not-panic.com>
 <20200219143227.aavgzkbuazttpwky@andromeda>
 <20200219143824.GR11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219143824.GR11244@42.do-not-panic.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9536 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 adultscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 02:38:24PM +0000, Luis Chamberlain wrote:
> On Wed, Feb 19, 2020 at 03:32:27PM +0100, Carlos Maiolino wrote:
> > On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> > > I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> > > actual modern typical use case for it. I thought this was somewhat
> > > realted to DAX use but upon a quick code inspection I see direct
> > > realtionship.
> > 
> > Hm, not sure if there is any other use other than it's original purpose of
> > reducing latency jitters. Also XFS_RT dates way back from the day DAX was even a
> > thing. But anyway, I don't have much experience using XFS_RT by myself, and I
> > probably raised more questions than answers to yours :P
> 
> What about another question, this would certainly drive the users out of
> the corners: can we remove it upstream?

My DVR and TV still use it to record video data.

I've also been pushing the realtime volume for persistent memory devices
because you can guarantee that all the expensive pmem gets used for data
storage, that the extents will always be perfectly aligned to large page
sizes, and that fs metadata will never defeat that alignment guarantee.

(Granted now they're arguing that having a separate storage device for
metadata will inflate the BOM cost unacceptably, and wouldn't it be
cheaper if we just redesigned XFS to have 2MB blocksize, but I'm not
buying that because the next thing they'll want when pmem becomes cheap
is 1GB blocksize for Big Data applications. :P)

--D

>   Luis
