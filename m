Return-Path: <SRS0=afpP=AJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BF2C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Jun 2020 22:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001F320672
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Jun 2020 22:37:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0VwWWjk6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgF1WhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Jun 2020 18:37:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60860 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgF1WhN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jun 2020 18:37:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05SMTcdC081425;
        Sun, 28 Jun 2020 22:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=nMEyD8Y7ig3QtxqXtj+sHSTf4FnF09pwORVkx6Vgt+4=;
 b=0VwWWjk6BNTgVK676Hj55AKzuckmau9tkDnKZi716/5jQWUoIlniTQDB8KQHcVAQIFGU
 /kpdHTdjpKYhxoTq2fSwAnA/ic/tKGMtc5gLGUIawet6snp/QB1UhZhqR9eyXmzyc0kC
 3iR+fxsdoTMEqtV4pUaj3QtcEUiBIag1KdkfoIzmSKmTVMGo0U2COROVhPWMRz+4FFuR
 zuzPM9wDjAe3ZuLdf6i6uaZssk7qLgeWGtKjWxbgAUPfg0gNq3ygmA0HwKsJeSIIz71e
 kIK/4d5bGtmfMcWfd/76dbDFPR19dKPp3RwXMPgrzN6B8dCfW/TLS2EAlkaqokjbFl7s sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrmukh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 28 Jun 2020 22:37:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05SMYRvl057224;
        Sun, 28 Jun 2020 22:37:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvpx7wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Jun 2020 22:37:07 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05SMb09M026927;
        Sun, 28 Jun 2020 22:37:00 GMT
Received: from localhost (/10.159.142.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 28 Jun 2020 22:37:00 +0000
Date:   Sun, 28 Jun 2020 15:36:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Edwin =?iso-8859-1?B?VPZy9ms=?= <edwin@etorok.net>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] xfs: reflink cleanups
Message-ID: <20200628223659.GQ7606@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <69dc29c4d0f3e80b4a8c8dfc559cbdd5ebce1428.camel@etorok.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69dc29c4d0f3e80b4a8c8dfc559cbdd5ebce1428.camel@etorok.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9666 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9666 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280168
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 28, 2020 at 01:06:08PM +0100, Edwin Török wrote:
> On Wed, 2020-06-24 at 18:17 -0700, Darrick J. Wong wrote:
> > Mr. Torok: Could you try applying these patches to a recent kernel to
> > see if they fix the fs crash problems you were seeing with
> > duperemove,
> > please?
> 
> Hi,
> 
> Thanks for the fix.
> 
> I've tested commit e812e6bd89dc6489ca924756635fb81855091700 (reflink-
> cleanups_2020-06-24) with my original test, and duperemove has now
> finished successfully:
> 
> [...]
> Comparison of extent info shows a net change in shared extents of:
> 237116676
> 
> There were some hung tasks reported in dmesg, but they recovered
> eventually:
> [32142.324709] INFO: task pool:5190 blocked for more than 120 seconds.
> [32504.821571] INFO: task pool:5191 blocked for more than 120 seconds.
> [32625.653640] INFO: task pool:5191 blocked for more than 241 seconds.
> [32746.485671] INFO: task pool:5191 blocked for more than 362 seconds.
> [32867.318072] INFO: task pool:5191 blocked for more than 483 seconds.
> [34196.472677] INFO: task pool:5180 blocked for more than 120 seconds.
> [34317.304542] INFO: task pool:5180 blocked for more than 241 seconds.
> [34317.304627] INFO: task pool:5195 blocked for more than 120 seconds.
> [34438.136740] INFO: task pool:5180 blocked for more than 362 seconds.
> [34438.136816] INFO: task pool:5195 blocked for more than 241 seconds.
> 
> The blocked tasks were alternating between these 2 stacktraces:
> [32142.324715] Call Trace:
> [32142.324721]  __schedule+0x2d3/0x770
> [32142.324722]  schedule+0x55/0xc0
> [32142.324724]  rwsem_down_read_slowpath+0x16c/0x4a0
> [32142.324726]  ? __wake_up_common_lock+0x8a/0xc0
> [32142.324750]  ? xfs_vn_fiemap+0x32/0x80 [xfs]
> [32142.324752]  down_read+0x85/0xa0
> [32142.324769]  xfs_ilock+0x8a/0x100 [xfs]
> [32142.324784]  xfs_vn_fiemap+0x32/0x80 [xfs]
> [32142.324785]  do_vfs_ioctl+0xef/0x680
> [32142.324787]  ksys_ioctl+0x73/0xd0
> [32142.324788]  __x64_sys_ioctl+0x1a/0x20
> [32142.324789]  do_syscall_64+0x49/0xc0
> [32142.324790]  entry_SYSCALL_64_after_hwframe+0x44/0xa
> 
> [32504.821577] Call Trace:
> [32504.821583]  __schedule+0x2d3/0x770
> [32504.821584]  schedule+0x55/0xc0
> [32504.821587]  rwsem_down_write_slowpath+0x244/0x4d0
> [32504.821588]  down_write+0x41/0x50
> [32504.821610]  xfs_ilock2_io_mmap+0xc8/0x230 [xfs]
> [32504.821628]  ? xfs_reflink_remap_blocks+0x11f/0x2a0 [xfs]
> [32504.821643]  xfs_reflink_remap_prep+0x51/0x1f0 [xfs]
> [32504.821660]  xfs_file_remap_range+0xbe/0x2f0 [xfs]
> [32504.821662]  ? security_capable+0x3d/0x60
> [32504.821664]  vfs_dedupe_file_range_one+0x12d/0x150
> [32504.821665]  vfs_dedupe_file_range+0x156/0x1e0
> [32504.821666]  do_vfs_ioctl+0x4a6/0x680
> [32504.821667]  ksys_ioctl+0x73/0xd0
> [32504.821668]  __x64_sys_ioctl+0x1a/0x20
> [32504.821669]  do_syscall_64+0x49/0xc0
> [32504.821670]  entry_SYSCALL_64_after_hwframe+0x44/0xa
> 
> Looking at /proc/$(pidof duperemove)/fd it had ~80 files open at one
> point, which causes a lot of seeking on a HDD if it was trying to
> dedupe them all at once so I'm not too worried about these hung tasks.
> 
> Running an xfs_repair after the duperemove finished showed no errors.
> 
> > 
> > v2: various cleanups suggested by Brian Foster
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my git trees, which are linked below.
> > 
> > This is an extraordinary way to destroy everything.  Enjoy!
> 
> To be safe I've created an LVM snapshot before trying it.

Yay!  Thank you for testing this out!  Sorry it broke in the first
place, though. :/

--D

> Best regards,
> --Edwin
> 
