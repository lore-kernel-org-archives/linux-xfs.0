Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC4FC43461
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536D820770
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 15:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iDKi3Y1E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIDPmO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 11:42:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgIDPmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 11:42:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084FeZu9054271
        for <linux-xfs@vger.kernel.org>; Fri, 4 Sep 2020 15:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xSL/GZOZHW9kqzeQVGpGzM6NKxHKR1OiofkaE8WegU4=;
 b=iDKi3Y1EcNCIU+fseRd1s2MpeuLL75iMNd6fHsOSojXPtDesjKym16mTqbSsMG5Ajtwi
 0YzU7HZSCMcXT50Nr7TX/VwTaGRu34mzTulouypxSLB9aEqE1YfkNJIcgCTBh4Sgbp0f
 V/PpJ4wM6p31fqMbVGbRPBLl+cTMV+1d7JA8rGo6RjTrIcb9j8XxKr2W/IfZVDHVmMom
 IMwLdriK5KD9NS2m9tf2qXoGycITVamc9STNNakzTeDQueU8ck8pixSwUkDJyuMGviAw
 nTI7G54jt86afyay/CsXdDdKSmjtVylF3ZDST3VPBCZUk4e5kNfmM4GJ1+imxWnaTeUG 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eymq43f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 15:42:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 084FZCA6162257
        for <linux-xfs@vger.kernel.org>; Fri, 4 Sep 2020 15:42:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33bhs4nk67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 15:42:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 084Fg6hb011711
        for <linux-xfs@vger.kernel.org>; Fri, 4 Sep 2020 15:42:06 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Sep 2020 08:42:06 -0700
Date:   Fri, 4 Sep 2020 08:42:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200904154205.GF6096@magnolia>
References: <20200903161724.85328-1-cmaiolino@redhat.com>
 <20200903161859.85511-1-cmaiolino@redhat.com>
 <20200904075328.drcjnnfbq4zn55im@eorzea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904075328.drcjnnfbq4zn55im@eorzea>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=968 spamscore=0 adultscore=0 suspectscore=3 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9734 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=947 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 04, 2020 at 09:53:28AM +0200, Carlos Maiolino wrote:
> On Thu, Sep 03, 2020 at 06:18:59PM +0200, Carlos Maiolino wrote:
> > xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> > xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> > instead of playing with more #includes.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > Changelog:
> > 	V2:
> > 	 - keep macro comments above inline functions
> > 	V3:
> > 	- Add extra spacing in xfs_attr_sf_totsize()
> > 	- Fix open curling braces on inline functions
> > 	- use void * casting on xfs_attr_sf_nextentry()
> > 	V4:
> > 	- Fix open curling braces
> > 	- remove unneeded parenthesis
> > 
> 
> hmmm, my apologies Darrick, looks like my ctrl+c/ctrl+v on the msgid tricked me
> This patch was supposed to be sent as in-reply-to the v3 4/4, looks like I sent
> it to the wrong id. Do you want me to resend everything? Again, my apologies for
> the confusion.

Nah, I already RVB'd it.

--D

> -- 
> Carlos
> 
