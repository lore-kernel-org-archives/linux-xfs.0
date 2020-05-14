Return-Path: <SRS0=gMH0=64=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B217C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47C0F20643
	for <linux-xfs@archiver.kernel.org>; Thu, 14 May 2020 19:23:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eXWkVovg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgENTXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 May 2020 15:23:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbgENTXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 15:23:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJNBCu070092;
        Thu, 14 May 2020 19:23:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=X/C6JpwdNXuRqDnLAxNxAcPxtzbjOxJkFYG+KOWeFxA=;
 b=eXWkVovgXphdt1ZfLb2S42Dk0cdnW1xIixfGpvXBvOP1l75ekKBGMAqR1tENtuhY24o4
 6WFkVUuskNimjdtbu4CHvKSEpcckwU1Oiu1h7Mc7ICMTl4u2GHl/+AgcELgN09Zv/UjK
 JfSPK9wqZCTHNgNGwaBL2tByB5mkEmJxIQD/a/bBH/ZTGSNhGpJaNOxcPCmJblsoN+Dx
 wnwRWwLXKq8v8umryNFHDVz9356XmBs+RjMFI89J35sPs+jgMMsRfoB1hfswyNKeCptH
 fED6gzgW6QfSjORdHCelQW4wkbauHf6XXrKBa2c7iPv6VokpeHLyLSmfLOYjJIiE/Mgx fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3100xwvmav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 19:23:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EJI6e4138962;
        Thu, 14 May 2020 19:23:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3100yhd7bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 19:23:17 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04EJNGr8015289;
        Thu, 14 May 2020 19:23:16 GMT
Received: from localhost (/10.159.232.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 12:23:16 -0700
Date:   Thu, 14 May 2020 12:23:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: remove gratuitous code block in phase5
Message-ID: <20200514192314.GE6714@magnolia>
References: <1dc0bb1a-ce6f-5e22-77ff-b8bb408a3e03@redhat.com>
 <3b728076-0454-104c-312f-511447235f61@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b728076-0454-104c-312f-511447235f61@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005140170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 11, 2020 at 03:32:42PM -0500, Eric Sandeen wrote:
> On 5/11/20 2:20 PM, Eric Sandeen wrote:
> > A commit back in 2008 removed a "for" loop ahead of this code block, but
> > left the indented code block in place. Remove it for clarity and reflow
> > comments & lines as needed.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Never mind, Darrick /just/ did this in his other series.  Weird.  I didn't
> see it there! ;)
> 
> So ignore this patch.

Actually, I see that you fixed all the 80col stuff that I didn't.
Maybe I want this patch over yours after all. :P

--D

> -Eric
> 
