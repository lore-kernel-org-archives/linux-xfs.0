Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7256C2D0E8
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 04:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F367206F8
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 04:32:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bnwBx4RM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgDCEc6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 00:32:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgDCEc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 00:32:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0334SPj4163721;
        Fri, 3 Apr 2020 04:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HLaVFg8Hy9yzvqItHeLrxrbBwqJCEIBm8KqbHZJkrpE=;
 b=bnwBx4RMS7T46u94CHJNtJJCxdRcYveQ+pNHN3665TlQdgQwnRFfJzkFu/qPzZJOOV/0
 WCcRM17O65cwq7oTR+6XEu79THJufWfXUz2d9iFOzO5BXDz6UUNaSYmZvRL8PDPIBwPO
 +ngEFhYcn9RB5xhzqLaI9IcIMQbwgWdeKgejDA4Plp8gLOQcvyljFZImVoILeQ3HFiwz
 251FIhBpDvql9FyQezVxZRL4jOYKIm61NMfj4k2AXHbrdmkzC0NaBeJiSkcgAlw531Q4
 6eWM7JVLtur2uVes3E3CcdncoB3/EOEsY3kN5pALc8NjRjsb5zrCPA56P92PlrIyg/jT NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevexee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 04:32:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0334WBFr158384;
        Fri, 3 Apr 2020 04:32:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 302ga3r7mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Apr 2020 04:32:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0334Ws58005542;
        Fri, 3 Apr 2020 04:32:54 GMT
Received: from localhost (/10.159.130.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 21:32:54 -0700
Date:   Thu, 2 Apr 2020 21:32:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: test PF_MEMALLOC interfering with accounting
 file write
Message-ID: <20200403043252.GL80283@magnolia>
References: <20200403033355.140984-1-ebiggers@kernel.org>
 <20200403035657.GK80283@magnolia>
 <20200403040215.GA11203@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403040215.GA11203@sol.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1011 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 09:02:15PM -0700, Eric Biggers wrote:
> On Thu, Apr 02, 2020 at 08:56:57PM -0700, Darrick J. Wong wrote:
> > > +_scratch_mount
> > > +_scratch_unmount
> > 
> > _scratch_cycle_mount
> > 
> > With that fixed,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> 
> That doesn't work because _scratch_cycle_mount does unmount, then mount.
> This test wants mount, then unmount.

LOL, and I even stumbled over the same thing last time.  :(

Test looks fine as it is, and you can still add my RVB.

Ok, time to go do something else.


--D

--D

> - Eric
