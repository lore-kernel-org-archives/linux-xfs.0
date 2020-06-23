Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32C5C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 08:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE97820716
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 08:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MWu+RGos"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731648AbgFWIHk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 04:07:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60984 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730977AbgFWIHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 04:07:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N820wB131892;
        Tue, 23 Jun 2020 08:07:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=evppxrHLAlHWJB8fO2u2KhO/eoEbji1vj2iyG1d11qg=;
 b=MWu+RGosbWiaiCASZXJKIzIlzxx3gcDCGh89bgzUoK20V+UCiSit7YqSzyFtfjKbo537
 4e4ZVydddLRTu50IOrfnl1bJO3By0j0NjdNvNPITOkfVXGFFdypIKobgaXZn/WbtLNXo
 Ayczqdsw/LmY+oWdph6Me33QnffxK9zaVCMDaKuhzDG4XD8hxT8ADQDXut68FZCQztix
 P8/KQ3MkQfCdc5wmI73fsgDETSJ8Jx8Ne7YfaYVIl0z6lxQnNzY8lpOTiGHBAzeabUzD
 j40e59e1l1yg1GylwQZzOiyRHJr/lcGNw5eVMiMUGzsy5f4xtfH5SNV1tXn+Qhw23r/m yA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31sebbbq6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 08:07:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N847og088499;
        Tue, 23 Jun 2020 08:05:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31sv7rdg62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 08:05:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05N85Xih020645;
        Tue, 23 Jun 2020 08:05:33 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 08:05:33 +0000
Date:   Tue, 23 Jun 2020 11:05:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     kernel test robot <lkp@intel.com>, kbuild@lists.01.org,
        Dan Carpenter <error27@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [kbuild] Re: fs/xfs/libxfs/xfs_bmap.c:5563 __xfs_bunmapi() warn:
 Function too hairy. No more merges.
Message-ID: <20200623080527.GY4282@kadam>
References: <202006210453.AJzaq6rh%lkp@intel.com>
 <20200622161532.GD11242@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622161532.GD11242@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230063
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 09:15:32AM -0700, Darrick J. Wong wrote:
> On Sun, Jun 21, 2020 at 04:03:02AM +0800, kernel test robot wrote:
> > CC: kbuild-all@lists.01.org
> > CC: linux-kernel@vger.kernel.org
> > TO: Dave Chinner <dchinner@redhat.com>
> > CC: "Darrick J. Wong" <darrick.wong@oracle.com>
> > CC: Christoph Hellwig <hch@lst.de>
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   4333a9b0b67bb4e8bcd91bdd80da80b0ec151162
> > commit: b0dff466c00975a3e3ec97e6b0266bfd3e4805d6 xfs: separate read-only variables in struct xfs_mount
> > date:   3 weeks ago
> > :::::: branch date: 24 hours ago
> > :::::: commit date: 3 weeks ago
> > config: i386-randconfig-m021-20200621 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > New smatch warnings:
> > fs/xfs/libxfs/xfs_bmap.c:5563 __xfs_bunmapi() warn: Function too hairy.  No more merges.
> > 
> > Old smatch warnings:
> > fs/xfs/libxfs/xfs_bmap.c:5450 __xfs_bunmapi() error: we previously assumed 'tp' could be null (see line 5290)
> > fs/xfs/libxfs/xfs_bmap.c:6123 __xfs_bmap_add() error: potential null dereference 'bi'.  (kmem_alloc returns null)
> 
> Er... does this mean that smatch is smarter about kmem_alloc now?
> 
> Or merely that something/someone tweaked the hair threshold downwards?
> 
> <-- his personal hair threshold is much longer now that it's March 98th.

You must have signed up to the kbuild list.  I normally look over the
warnings and ignore the false positives like this one...

The "Function too hairy.  No more merges." message is internal stuff.
I should turn that off by default.

I don't normally pay a lot of attention to the old warnings but it looks
like the "tp" warning is valid.  On my system, I don't get the warning
because the "too hairy" warning triggers to early.

The __xfs_bmap_add() warning is a false positive because we don't
pass KM_MAYFAIL.  Smatch doesn't track set bits.  It will do eventually.
It's not complicated code to write but it's just a matter of doing the
work.

regards,
dan carpenter

