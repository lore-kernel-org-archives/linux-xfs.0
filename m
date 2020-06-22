Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375AFC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 16:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1262120738
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 16:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zXW2LN44"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbgFVQPk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 12:15:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgFVQPk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 12:15:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MG1apv035164;
        Mon, 22 Jun 2020 16:15:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+ARcNTVj9JeieFQM4yNAXTATUkdDa5jjVt9oS6gn01s=;
 b=zXW2LN44QkQzB+wg2bdjney+ZHeJXZkDVupqzNM61sHhh0UrCEqLbyP50RUs8nrHFrN6
 7St/EJEAoRChJYdx6EehqC+TNk8ULnA2+6RgmhaBiRGGGYrMN3czqlWKktwZC6JX2nNr
 v55YrachthYkX79AONZHfn+4RE1htKDzNTG1RxcIK+Q990hyS/4YxgVa9+NSEkL96sdG
 iU2Qv3Rdn27AfTRUCRV71UkyZ3ZM5q3WYgelT8iWviOeSTDM9MzTiOA/DcfBbEJMUF6H
 CtmEfAmnvcE0KMgwEnJhZef1lygp/ITR1NFsYPTrxKHK3A2xVBiATE9r15qVF3Rgf8ku Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31sebb8c1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 16:15:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05MFx4dY153421;
        Mon, 22 Jun 2020 16:15:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31svcvagch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:15:34 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05MGFXRP007654;
        Mon, 22 Jun 2020 16:15:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 16:15:33 +0000
Date:   Mon, 22 Jun 2020 09:15:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild@lists.01.org, Dan Carpenter <error27@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [kbuild] fs/xfs/libxfs/xfs_bmap.c:5563 __xfs_bunmapi() warn:
 Function too hairy. No more merges.
Message-ID: <20200622161532.GD11242@magnolia>
References: <202006210453.AJzaq6rh%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006210453.AJzaq6rh%lkp@intel.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220117
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 21, 2020 at 04:03:02AM +0800, kernel test robot wrote:
> CC: kbuild-all@lists.01.org
> CC: linux-kernel@vger.kernel.org
> TO: Dave Chinner <dchinner@redhat.com>
> CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> CC: Christoph Hellwig <hch@lst.de>
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   4333a9b0b67bb4e8bcd91bdd80da80b0ec151162
> commit: b0dff466c00975a3e3ec97e6b0266bfd3e4805d6 xfs: separate read-only variables in struct xfs_mount
> date:   3 weeks ago
> :::::: branch date: 24 hours ago
> :::::: commit date: 3 weeks ago
> config: i386-randconfig-m021-20200621 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> New smatch warnings:
> fs/xfs/libxfs/xfs_bmap.c:5563 __xfs_bunmapi() warn: Function too hairy.  No more merges.
> 
> Old smatch warnings:
> fs/xfs/libxfs/xfs_bmap.c:5450 __xfs_bunmapi() error: we previously assumed 'tp' could be null (see line 5290)
> fs/xfs/libxfs/xfs_bmap.c:6123 __xfs_bmap_add() error: potential null dereference 'bi'.  (kmem_alloc returns null)

Er... does this mean that smatch is smarter about kmem_alloc now?

Or merely that something/someone tweaked the hair threshold downwards?

<-- his personal hair threshold is much longer now that it's March 98th.

--D

> 
> # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b0dff466c00975a3e3ec97e6b0266bfd3e4805d6
> git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> git remote update linus
> git checkout b0dff466c00975a3e3ec97e6b0266bfd3e4805d6
> vim +5563 fs/xfs/libxfs/xfs_bmap.c

<snip> a ton of git blame output
