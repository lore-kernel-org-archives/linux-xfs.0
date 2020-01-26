Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C53AC2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7013920716
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:12:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MSROESxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAZWMB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:12:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36230 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgAZWMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:12:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QM7wjX024687;
        Sun, 26 Jan 2020 22:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sk4+PwN+NF+mNKAbn8kuxlF0AI20zLmvCzDsVBRZtP4=;
 b=MSROESxYMWe6HOznQl18Lvkcuxd4RU+6yTYJkWStXnHdKZhmwMq+Rntd62V+MluprGJP
 m7SZDKyXDJHi31ChARjk9ikLMm8vHIAvm0+dYgdESyazqdehDK2oM81i/ZXFLIa/wcx1
 kkOJdgE4HzR3xsVCzIMHRlHr7ckKaZfIsI7BRUfcYJgZCBIzZ/44A7u3+y+dyIwuXBnf
 dAntxJbrfUCHDOKSPRB9k1kL6pmkyLR3aLG/g9vzDERWBTmMc+tDh3kwxyZR4op9/c0X
 ccdph9CmR/cJeGUw7DLPgldHpZVryvh/kISaTQ6jnrVVpr96gOx3ca/+vsncSboOCE7M aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xrdmq4f5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:11:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QM8XDd146172;
        Sun, 26 Jan 2020 22:11:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xrytnpuk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:11:53 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00QMBq6i003782;
        Sun, 26 Jan 2020 22:11:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:11:52 -0800
Date:   Sun, 26 Jan 2020 14:11:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs_repair: fix totally broken unit conversion in
 directory invalidation
Message-ID: <20200126221151.GC3447196@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982504329.2765410.10475555316974599797.stgit@magnolia>
 <20200125231927.GL15222@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125231927.GL15222@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=842
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=905 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 25, 2020 at 03:19:27PM -0800, Christoph Hellwig wrote:
> On Thu, Jan 23, 2020 at 04:17:23PM -0800, Darrick J. Wong wrote:
> > Fix all this stupidity by adding a for loop macro to take care of these
> > details for us so that everyone can iterate all logical directory blocks
> > (xfs_dir2_db_t) that start within a given bmbt record.
> 
> No more magic macro in here (thankfully).  But the rest looks good:

Oops, yeah... Eric, if you decide to take this patch, could you please
drop that second paragraph about the macro?

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thank you for the reviews!

--D
