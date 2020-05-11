Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29698C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 03:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E764F2082E
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 03:41:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DJuvPN5s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgEKDlf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 23:41:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbgEKDlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 23:41:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04B3WtOh105403;
        Mon, 11 May 2020 03:41:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ckhSUQOucb4BDNBCevRmtv1nDmtoBDnuKXfiXXI+dUY=;
 b=DJuvPN5s+7Oofq/fnegXQJKqSfZdemUefYUZ/ConUtH1Vz8Aw6XE9Y0h0bEBcf+hITZ7
 jOrGARVU78v4RVkQJuA1HJ+RKaBmqRyCAhcvhdsQhh04BDh2psUoklnVeKJo+suTWmUq
 nsQHXw2SiDM1+qhqqfPJwtzOVGVsWn8up/6vFrO38cQ9fOdMOy7/T/Ae1+CevBjMJNnH
 ifrWEoXEd9nWMDaEPN8sXVY/WmbdEtts0Djq/0mljetZ76gJ0OqXGx7+5X7xhfhBZRyr
 o/6YDQHYIjTZcH5zkXM/16ZRcj9qUABpaZsb6hTiW15qMuliuwQHiZUAZQDH6FVHwxWz 1Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30x3gsan3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 May 2020 03:41:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04B3bUP9169318;
        Mon, 11 May 2020 03:41:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30x63ktdhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 May 2020 03:41:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04B3fRCc008971;
        Mon, 11 May 2020 03:41:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 May 2020 20:41:27 -0700
Date:   Sun, 10 May 2020 20:41:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] db: cleanup attr_set_f and attr_remove_f
Message-ID: <20200511034125.GY6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-5-hch@lst.de>
 <e7c3ed39-d007-8d9c-d718-ed5c60f92225@sandeen.net>
 <20200510071104.GA17094@lst.de>
 <29f4bd53-6151-d58f-64ae-830b48ebb3cc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29f4bd53-6151-d58f-64ae-830b48ebb3cc@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9617 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005110027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9617 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110026
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 10, 2020 at 09:09:14AM -0500, Eric Sandeen wrote:
> On 5/10/20 2:11 AM, Christoph Hellwig wrote:
> > On Sat, May 09, 2020 at 12:23:42PM -0500, Eric Sandeen wrote:
> >> On 5/9/20 12:01 PM, Christoph Hellwig wrote:
> >>> Don't use local variables for information that is set in the da_args
> >>> structure.
> >>
> >> I'm on the fence about this one; Darrick had missed setting a couple
> >> of necessary structure members, so I actually see some value in assigning them
> >> all right before we call into libxfs_attr_set .... it makes it very clear what's
> >> being sent in to libxfs_attr_set.
> > 
> > But using additional local variables doesn't help with initialing
> > the fields, it actually makes it easier to miss, which I guess is
> > what happened.  I find the code much easier to verify without the
> > extra variables.
> 
> They seem a bit extraneous, but my problem is I can't keep track of how much
> of the args structure is actually filled out when it's spread out over dozens
> of lines ....  
> 
> *shrug* I dunno. Maybe darrick can cast the tie-breaking vote.  ;)

I mean... I /did/ already RVB this one... :)


--D
