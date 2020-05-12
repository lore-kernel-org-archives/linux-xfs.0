Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0E1C2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E445920769
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:27:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ozyhDE/G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgELX1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:27:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgELX1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:27:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNNCSE165410;
        Tue, 12 May 2020 23:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xrlHE8PF6d3CnSopxx5r3bs1Rb1x+b/5SKIjWQuHVUc=;
 b=ozyhDE/GEMVTIhIxoA/PwTRRIeyqFyGopZR25DeKhPkyvCliEV/E/xrKNZIQzNnh6/GR
 uKiLF3HVHowHKmmRzB9TTy9TKyoxRbUHj8v5rbucwdWBLRx8/qz5SfRk6YlJ2gJAAq1o
 lgRnCp+OxiMJ4c1pwFMbNewunIwQFb6QepIFlaLF5axw0xR2UlephoSRbIhPZa88kbrk
 wEw9Om+6Pg3o9PvT3QP/bIxSACnCuTdb3mofJEihRaNEvCaOUMwHkYrQsswhJOPbmt9v
 xC7eK76jieeM9ud/TM4EpPX5YK8stlXq/ArYMYjU9Y3H7Ld8F+JRsBvmJf0iwwKeHMF4 OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3100yfs74w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 23:27:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNOQ5s021505;
        Tue, 12 May 2020 23:27:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3100yjt29e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 23:27:40 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CNRceH028469;
        Tue, 12 May 2020 23:27:39 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 16:27:38 -0700
Date:   Tue, 12 May 2020 16:27:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] xfs: allow adjusting individual quota grace times
Message-ID: <20200512232737.GN6714@magnolia>
References: <ca1d2bb6-6f37-255c-1015-a20c6060d81c@redhat.com>
 <20200511153532.GB11320@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511153532.GB11320@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 11, 2020 at 08:35:32AM -0700, Christoph Hellwig wrote:
> On Sat, May 09, 2020 at 02:47:02PM -0500, Eric Sandeen wrote:
> > So there's no real way to know that the grace period adjustment failed
> > on an older kernel.  We could consider that a bug and fix it, or
> > consider it a change in behavior that we can't just make without
> > at least some form of versioning.  Thoughts?

Well you /could/ roll this new functionality into a new revision of the
ioctl that supports 64bit time values...

> I'd consider a bug, as applications are very unlikely to rely on
> these ignored calls (famous last words..).

...but OTOH that might be a better discussion to have when we start
reviewing the bigtime series.  In the meantime, seeing as xfs_quota
never really let you push out soft grace period expiration anyway, I
guess you could just teach userspace to try to make the change and
declare success if an immediate re-query shows the value changed.

--D
