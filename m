Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABFEC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C687F20CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="seAH0+PH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgBYSbD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:31:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55034 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731449AbgBYSbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:31:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PINqIS135880;
        Tue, 25 Feb 2020 18:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=w9fNaPlS/y2ADw028Wd7+5rQOfmsyYmEpnMZg0rb/lE=;
 b=seAH0+PHUdkPpiybXL9eHe5Uzsg+i10BSmz3vmTvbCLw8jJ+zQViC52tnWw2iOEfkOCt
 WklQT2jbBmgEo5nqOucUBYc0xNcrMusvTP4YlFtOimIm/+KMZz71CWr59ZaTPZZliGGg
 qebaQwzSqw4SnCTge29TqLNo0SVRN+HgFedBM6zbWehXdLhASnDXT2EDOYIYtGyiODHs
 56WEdG5Nh/fZvaH7RmexSztN95ZqcOMH0IzxIwJh9xCA7eBPZufuI2QY5iAmKD8Dc6HH
 IKkiozWLuBjhGsgBxguKQjR+QEEjNR+bDaVAVFxHnrKuOsbnoi7v6QDCe9cgFMFRqIkk 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yd093kewx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:30:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIEABh012795;
        Tue, 25 Feb 2020 18:28:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yd17qj0c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:28:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PISo1h016056;
        Tue, 25 Feb 2020 18:28:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:28:50 -0800
Date:   Tue, 25 Feb 2020 10:28:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] libxfs: zero the struct xfs_mount when unmounting
 the filesystem
Message-ID: <20200225182849.GI6740@magnolia>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
 <158258948007.451256.11063346596276638956.stgit@magnolia>
 <20200225174038.GE20570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225174038.GE20570@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=837
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=2 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=2 priorityscore=1501
 phishscore=0 clxscore=1015 mlxlogscore=893 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:40:38AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 04:11:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since libxfs doesn't allocate the struct xfs_mount *, we can't just free
> > it during unmount.  Zero its contents to prevent any use-after-free.
> 
> I don't really this at all.  Seems to be cargo-cult style programming.

Admittedly I'm not convinced it's necessary either, seeing as we control
all the callers, and none of them actually screw this up.  But I defer
to the maintainer. ;)

(If anything I'm more afraid of the "libxfs_xinit_t x;" but that's a
different cleanup for another time.)

--D
