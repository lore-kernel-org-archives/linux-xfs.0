Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84144C35656
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A7D2206EF
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 15:54:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jsc8dFfD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBUPyW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:54:22 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbgBUPyV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:54:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFsHP9021089;
        Fri, 21 Feb 2020 15:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Hb92odAAomC1ad+6/QTty3asWJ8myDwTpM93QCvcrCk=;
 b=jsc8dFfDdLPT9YivTHAFn7vP6xWnoCBLHpYQxIuJyimFJa0/NEC/imT5gMwJ1s9bhV4Y
 8yjRuLZQrMBxURuXyPZjFv5t1fg51Ya6Un3ktNqJqKn90YbZttnIIiK1Eb0JE/HmtuOp
 b6KXdj2QBC7HkwEJNhnmDsrOk16m2tjtyp4lx00TUQ+VMTf74l0ujTnSmudC6qoUqHY4
 KA/hBf5rBb2sWsyv0IBn3ZPkPktK+YNp8GYjz9Apv1ZUtjWnp3LCTHo91Q5UE/OmesuN
 0W4/kOIXmS3YdqkcYl3ccSjP21Rvw1KeHF54oWHS9H0P1o01y+DiqSdjw7J6cZHrIQ4L Fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2y8ud1hat2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:54:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01LFpvLX194191;
        Fri, 21 Feb 2020 15:54:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y8udnjutu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Feb 2020 15:54:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01LFsABJ026362;
        Fri, 21 Feb 2020 15:54:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Feb 2020 07:54:10 -0800
Date:   Fri, 21 Feb 2020 07:54:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/18] libxfs: straighten out libxfs_writebuf confusion
Message-ID: <20200221155409.GT9506@magnolia>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216303592.602314.4622638173533560298.stgit@magnolia>
 <20200221145305.GK15358@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221145305.GK15358@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9538 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002210119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 06:53:05AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 05:43:55PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > libxfs_writebuf is not a well named function -- it marks the buffer
> > dirty and then releases the caller's reference.  The actual write comes
> > when the cache is flushed, either because someone explicitly told the
> > cache to flush or because we started buffer reclaim.
> > 
> > Make the buffer release explicit in the callers and rename the function
> > to say what it actually does -- it marks the buffer dirty outside of
> > transaction context.
> 
> FYI, before we made all buffer writes delwri or sync in the kernel the
> equivalent function was called xfs_buf_bawrite.

Heh, yeah... I've been reviewing old Unixen books lately and finally
know where all those weird names came from.

> But I'm not sure that
> was a better name.  But maybe libxfs_buf_mark_dirty is a tad better?

Ok.

--D

> Otherwise looks good.
> 
