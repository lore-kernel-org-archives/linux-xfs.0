Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C133C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 23:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D532071E
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 23:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jFfzal5n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgFAX4l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 19:56:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57282 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgFAX4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 19:56:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051NquSc104695;
        Mon, 1 Jun 2020 23:56:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=cSHfoPxbZYOrmeEetJB4Qm7LMa9wwNPKOTXQRRfGQ5A=;
 b=jFfzal5nhbJeuZ6l1UBlQa4+fw+7dHETfhMp5JxL4xccgfG6A9z/qgV2wFJbWdvNOEjc
 vfl0PTN4EIS9MzzgZd5OO6jxOxaFIQp65n9GJQ3uL6WA5Gv53Tn91QY7yq/Fqv6S88Ol
 FR9Gh2qTpMvSscjzZY07TUTtj17VDtbyTMeE8HxQfyYw/0i6i7V+g+HTS3PPFqIrHVDW
 5aTz0bUFNeXlXf/2UUTS4DZaudJgx05VvmnVY/fyrcQiM5oHadBPJY3mWW5Hvs77+Cv0
 RoPbiGj5Jh/dUOVPBRCY7kacfSVnnfLmLuOPk/iN/VIrthedoqBowheV3hZdlP3wRaox yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem18dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 01 Jun 2020 23:56:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051NrriA064190;
        Mon, 1 Jun 2020 23:56:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25m3td2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jun 2020 23:56:38 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 051NubJu008856;
        Mon, 1 Jun 2020 23:56:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 16:56:37 -0700
Date:   Mon, 1 Jun 2020 16:56:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 04/14] xfs: fix quota timer inactivation
Message-ID: <20200601235635.GY8230@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784108755.1364230.10581541534925642174.stgit@magnolia>
 <CAOQ4uxjKH4zJo4P8AU=fVBd6HG9wRTmc=Uiy7Q4A30deAeXq=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjKH4zJo4P8AU=fVBd6HG9wRTmc=Uiy7Q4A30deAeXq=g@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006010175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 31, 2020 at 06:04:50PM +0300, Amir Goldstein wrote:
> On Wed, Jan 1, 2020 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > We need to take the inactivated inodes' resource usage into account when
> > we decide if we're actually over quota.
> >
> 
> Does this patch belong in this series?
> Anyway, fine by me.

Oops, heh, this belongs in the deferred inactivation series.

--D

> Thanks,
> Amir.
