Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF250C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5BC12084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 19:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xyxRcOf1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgBYTkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:40:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40950 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgBYTkQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:40:16 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJWX4e012387;
        Tue, 25 Feb 2020 19:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LbCck8MyYr1loRlnGmNzrxtHXpqhxPVl+Ih5r2VI480=;
 b=xyxRcOf1rnkzkiqXQHt3KnDJuyqE56Nc8/CPafYKmdKPsXkqBHT1u4zVmTaXjt8Er0kj
 owqS4JrgXyZUSIF5qUFTUndQsPY8GVICoZzUDK+BLBVWNj6GItpxMd0pU1AyDUjG5t5F
 crPv14DB0ZLQjJAJVaVg7hV63k4uQt4CW7AMeH6GlzN9BHNxzi6zzwHDtbpRf9IP9q8p
 HJq1GY7v5eiETy+mj9rp0jRAP38EIBvIDFh6glOlEJHzXZDjwYsE5kuRCM+LgEBolchx
 oYF8KjH7bXiV6URuPTn8Qum6+f459YmOig8X459bCMYGGZrFIwx7Rv4oberUW3Qdi4A6 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yd0m1up2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:40:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PJWC9p102297;
        Tue, 25 Feb 2020 19:40:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yd0vvc3tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 19:40:12 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PJeBqq029133;
        Tue, 25 Feb 2020 19:40:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 11:40:11 -0800
Date:   Tue, 25 Feb 2020 11:40:10 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] libfrog: move topology.[ch] to libxfs
Message-ID: <20200225194010.GU6740@magnolia>
References: <157671084242.190323.8759111252624617622.stgit@magnolia>
 <157671085471.190323.17808121856491080720.stgit@magnolia>
 <60af7775-96f6-7dcb-9310-47b509c8f0f5@sandeen.net>
 <20191219001208.GN7489@magnolia>
 <b48693ed-3c4d-bfc8-c82f-48f871b2dc77@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b48693ed-3c4d-bfc8-c82f-48f871b2dc77@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 07:04:32PM -0600, Eric Sandeen wrote:
> On 12/18/19 6:12 PM, Darrick J. Wong wrote:
> > On Wed, Dec 18, 2019 at 05:26:44PM -0600, Eric Sandeen wrote:
> >> On 12/18/19 5:14 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> The functions in libfrog/topology.c rely on internal libxfs symbols and
> >>> functions, so move this file from libfrog to libxfs.
> >>
> >> None of this is used anywhere but mkfs & repair, and it's not really
> >> part of libxfs per se (i.e. it shares nothing w/ kernel code).
> >>
> >> It used to be in libxcmd.  Perhaps it should just be moved back?
> > 
> > But the whole point of getting it out of libxcmd was that it had nothing
> > to do with command processing.
> 
> Yeah I almost asked that.  ;)
>  
> > I dunno, I kinda wonder if this should just be libxtopo or something.
> 
> bleargh, not sure what it gains us to keep creating little internal libraries,
> either.
> 
> I guess I don't really care, tbh.  Doesn't feel right to shove unrelated stuff
> into libxfs/ though, when its main rationale is to share kernel code.

OTOH, not having it is now getting in the way of me being able to turn
XFS_BUF_SET_PRIORITY into a static inline function because the priority
functions reference libxfs_bcache, which ofc only exists in libxfs.  We
have gotten away with this because the preprocessor doesn't care, but
the compiler will.

--D

> -Eric
