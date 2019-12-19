Return-Path: <SRS0=RLxe=2J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 645A9C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 00:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3537D2176D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 00:14:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MYk8jo/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLSAOQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 19:14:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLSAOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 19:14:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJ0EDtn136304;
        Thu, 19 Dec 2019 00:14:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=5A1Q0tC8o7f+ot4o1weIHlUp2gILzyTR89di4N/BSLI=;
 b=MYk8jo/L/C9jIUC75FQiwIgf+/6cvLXIGpBzE/FPp0FKkkHG/xmLLhlY3DBJ1KCQoYcg
 UBCs9AvxLxQGgr+geJAZUOqjYEC2f53+G+tbRjEfvSrMIA8kQ/8KuOeCwZHNdmZ8NtB6
 fVSl1b3/YqMESeKS85dV0aBgLWompk2a5zl4VAfH1iglMg16kLih0SHZP1zLScYYzpxI
 cuHb6BQlaZpR4FL+eepa1eqlBF+/Z3FDNI0LtuHYEMpLYTu/SM7z/duxNMsv4kGehHwz
 BYpgJtY9qJPDJ2/6wddCZaYakMC/cj0eVaBdDDfsybXjh3Qaet65xNW94SEdFBof5VO6 uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wvqpqgtn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 00:14:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJ09K5x183777;
        Thu, 19 Dec 2019 00:12:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wyp50a71b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 00:12:10 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBJ0C9Zj025993;
        Thu, 19 Dec 2019 00:12:10 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 16:12:09 -0800
Date:   Wed, 18 Dec 2019 16:12:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] libfrog: move topology.[ch] to libxfs
Message-ID: <20191219001208.GN7489@magnolia>
References: <157671084242.190323.8759111252624617622.stgit@magnolia>
 <157671085471.190323.17808121856491080720.stgit@magnolia>
 <60af7775-96f6-7dcb-9310-47b509c8f0f5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60af7775-96f6-7dcb-9310-47b509c8f0f5@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 18, 2019 at 05:26:44PM -0600, Eric Sandeen wrote:
> On 12/18/19 5:14 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The functions in libfrog/topology.c rely on internal libxfs symbols and
> > functions, so move this file from libfrog to libxfs.
> 
> None of this is used anywhere but mkfs & repair, and it's not really
> part of libxfs per se (i.e. it shares nothing w/ kernel code).
> 
> It used to be in libxcmd.  Perhaps it should just be moved back?

But the whole point of getting it out of libxcmd was that it had nothing
to do with command processing.

I dunno, I kinda wonder if this should just be libxtopo or something.

--D

> -Eric
