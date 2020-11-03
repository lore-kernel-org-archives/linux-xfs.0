Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E636C388F7
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24AB120786
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WXPDMmdl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgKCSex (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:34:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34952 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgKCSex (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 13:34:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3ITUDL134810;
        Tue, 3 Nov 2020 18:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fsTCcJr/gkUEoQwRTEIQusWfTilkLjQT4spsdDSKjv8=;
 b=WXPDMmdlhtVTbVkXb9fWZH+4sIw14Tp05926+1Pv1jeOx12UWEZHTplhdxh3SbvyB4C4
 T883JerWM/KGTUhfvVYnN3DluPK3z8xnMBFKuRJX2W196Ap3XK2OFFhaR1wy7jf5WL1R
 7oITXaiZO94Wq8ukteK+52vMMgqgOb4BpkWlpBrXJBFVV+ECwNbIuP9h3bGJ8jMTzKdk
 eCXdVc8FQFQSDC6R2IXdznv+2dnutyXhF/SgnmNATIyChRlzfJkZ+tyEYfYanXj49/i8
 fzyty9FK+s2BT2j0sYqzJZr/9X0US7kjC1Q1RN+Yge+2W8z3W8FQFjmuqRZYSK8KTQi/ VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34hhvcavpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 18:34:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3IOqcI155361;
        Tue, 3 Nov 2020 18:34:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34jf48vrrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 18:34:48 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A3IYjLe022389;
        Tue, 3 Nov 2020 18:34:45 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 10:34:45 -0800
Date:   Tue, 3 Nov 2020 10:34:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, fdmanana@kernel.org
Subject: Re: [RFC PATCH] vfs: remove lockdep bogosity in __sb_start_write
Message-ID: <20201103183444.GH7123@magnolia>
References: <20201103173300.GF7123@magnolia>
 <20201103173921.GA32219@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103173921.GA32219@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=881 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=1
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=898
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 05:39:21PM +0000, Christoph Hellwig wrote:
> >  int __sb_start_write(struct super_block *sb, int level, bool wait)
> >  {
> > -	int ret = 1;
> > +	if (!wait)
> > +		return percpu_down_read_trylock(sb->s_writers.rw_sem + level-1);
> >  
> > +	percpu_down_read(sb->s_writers.rw_sem + level-1);
> > +	return 1;
> >  }
> >  EXPORT_SYMBOL(__sb_start_write);
> 
> Please split the function into __sb_start_write and
> __sb_start_write_trylock while you're at it..

Any thoughts on this patch itself?  I don't feel like I have 100% of the
context to know whether the removal is a good idea for non-xfs
filesystems, though I'm fairly sure the current logic is broken.

(Sending a second cleanup patch...)

--D
