Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73C2DC433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 16:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E38B221FE
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 16:16:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BavNnjQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgJHQQr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 12:16:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730244AbgJHQQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 12:16:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098G9aHk118435;
        Thu, 8 Oct 2020 16:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=P/aXwAvj+Hf/1kViRPK9nIU/PaZ7pahLY6dOr4Yvuu4=;
 b=BavNnjQVUeyWxOg4moX1kPPsQADDM7o/b2DMjof4vL1+sTVcILBTyriPDFpHlToGNhXE
 n4D1YvxqxmXP7ak1AZoeqYjgjgqzs2mQ2wcNl31v0N1JKV3zo/6hbo108rzTw4HLwC+8
 QHTma2uAZya7jctiTLwkegBf+dcDSZB14P8LBpTqQ/Bl+McNKr0AFnW/bxLGl6n52E4+
 kdBxc/vXL8DfzoGfKgQNxqm0yf5fsEJ8uKZfLY9KAQDdcKXYfJGP0x7Pj/n2hzyIQFQh
 J8d9zVisW6P4sOh3xjFz8y3J9Vg79k3ou6BCSR7SW6sMFot9cOicl++oVWh3MNKV7jWu UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxn8jm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 16:16:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098GFGrD067347;
        Thu, 8 Oct 2020 16:16:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 341xnbwg3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 16:16:42 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098GGfki004242;
        Thu, 8 Oct 2020 16:16:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 09:16:40 -0700
Date:   Thu, 8 Oct 2020 09:16:39 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201008161639.GP6540@magnolia>
References: <20201006191541.115364-1-preichl@redhat.com>
 <20201006191541.115364-5-preichl@redhat.com>
 <20201007012159.GA49547@magnolia>
 <066ebfa6-25a2-aee4-a01c-3803ef716361@sandeen.net>
 <20201007152554.GL49559@magnolia>
 <4cd57497-4670-f96f-01a0-0c587e77548d@redhat.com>
 <20201007215545.GA6540@magnolia>
 <eebc3029-beb3-5b49-08d4-33ae63085411@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eebc3029-beb3-5b49-08d4-33ae63085411@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080121
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 08, 2020 at 03:55:16PM +0200, Pavel Reichl wrote:
> 
> >> Hi,
> >>
> >> thanks for the comments, however for some reason I cannot reproduce
> >> the same memory corruption you are getting.
> > 
> > <shrug> Do you have full preempt enabled?
> 
> Hi, I'm not proud to admit that until now I tested w/o 'CONFIG_PREEMPT=y' :-/
> However at least now I can see the bug you hit and test that the
> proposed change in version #10 fixes that.

<shrug> That just means you get to hit all the stall warnings (which are
fixable with cond_resched()) that I rarely see because preempt kernels
can reschedule at will... :)

> 
> 
> > 
> >> Do you think that moving the 'rwsem_release()' right before the
> >> 'complete()' should fix the problem?
> >>
> >> Something like:
> >>
> >>
> >> +       /*
> >> +        * Update lockdep's lock ownership information to point to
> >> +        * this thread as the thread that scheduled this worker is waiting
> >> +        * for it's completion.
> > 
> > Nit: "it's" is always a contraction of "it is"; "its" is correct
> > (posessive) form here.
> 
> Thanks for noticing. I know the difference...but still I did this
> mistake. I must focus more next time.

No worries, English is a weird language.

"Inflammable means flammable?  What a country!"
          -- Dr. Nick Riviera

--D

> 
> > 
> > Otherwise, this looks fine to me.
> 
> Thanks, version #10 is on list now.
> 
> Bye.
> 
