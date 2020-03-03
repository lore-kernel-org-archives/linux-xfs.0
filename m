Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4EA7C3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 15:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9FCC20866
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 15:49:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E4AiSd/w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgCCPtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 10:49:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgCCPtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 10:49:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023FfIRo078612;
        Tue, 3 Mar 2020 15:48:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8+2x6VoDfGWE5qtPVMjPO+fEBpnfkQqx3CbzwLidRPY=;
 b=E4AiSd/wrNbOCIOdM70jFLq/YPpXDAdWZYKjN0bdcvlkWjrgc2pd0H6txkJ+bfrUTxtB
 cQPrZ5RY65iIERHwZJsLoYrrbY/RQs4A8h/yq/hP6gpbc0Gd8/DKuHFsP7ldRiqRaark
 pMQT7V/soRHL9Fa1qcYfC5B6/f5lko0c1N010/+9oOKbTrJ0HZpsvoz06VZc3zVa0/we
 CdQvxXQoYHKSmYyIKkpc1PfJiGf5XPE8iu+R7uZgHT409BMHAKvfKe6SwiPSbSQuM3ZR
 UpE+3GbWh177ubIlGtLt7XAOhIh3eX0Oazn3SKXZy0uWiNq3L3Bw+3blBZ7e0LXHERDS wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yghn33xk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 15:48:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023FibsJ027176;
        Tue, 3 Mar 2020 15:48:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yg1p4qhby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Mar 2020 15:48:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023FmuAV027377;
        Tue, 3 Mar 2020 15:48:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 07:48:56 -0800
Date:   Tue, 3 Mar 2020 07:48:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/14] xfs: preserve default grace interval during
 quotacheck
Message-ID: <20200303154854.GY8045@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784107520.1364230.49128863919644273.stgit@magnolia>
 <ff58d07d-f6d7-647d-204e-59999b31dfba@sandeen.net>
 <13bd156b-3cf0-23d2-475e-9889156f284a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13bd156b-3cf0-23d2-475e-9889156f284a@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030113
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 09:03:37PM -0600, Eric Sandeen wrote:
> On 2/18/20 8:55 PM, Eric Sandeen wrote:
> > On 12/31/19 7:11 PM, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> When quotacheck runs, it zeroes all the timer fields in every dquot.
> >> Unfortunately, it also does this to the root dquot, which erases any
> >> preconfigured grace interval that the administrator may have set.  Worse
> >> yet, the incore copies of those variables remain set.  This cache
> >> coherence problem manifests itself as the grace interval mysteriously
> >> being reset back to the defaults at the /next/ mount.
> >>
> >> Fix it by resetting the root disk dquot's timer fields to the incore
> >> values.
> > 
> > Uh, so, even with this, it seems that we don't properly set up default time
> > limits on the first mount.  Looking into it...
> 
> Sorry.  This was actually a regression from my timer-per-type series.  :(
> 
> so ignore this critique, it's my fault. ;)

But will you (or anyone really) please review this fix?

--D

> -Eric
