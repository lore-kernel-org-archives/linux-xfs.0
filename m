Return-Path: <SRS0=TFM3=YL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A189CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 17:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2B8B21897
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Oct 2019 17:16:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sjwS5aEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404945AbfJRRQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Oct 2019 13:16:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393957AbfJRRQ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Oct 2019 13:16:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IHE01E068934;
        Fri, 18 Oct 2019 17:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=aSAHVE2N15qwAp89Go5A2ulYoQAOTPrYEpZWnXgNjxA=;
 b=sjwS5aEOHwxESjMxXKU9LxcjGg0rXNlYSHs3OA2BivXOKzE49UbugJ4xdxN5iv0hFG++
 Qe+1Rxdb2goRwDKOFmZsXnmwGmz8mJmQNTUOXG/b/efrg7JLo/9cD4pjsC/WJgP/lCLK
 5IBrPkoWeyNopNiqJlzogzi5kawyKX+bbrcguIaoG0+3YyseOvdI6llQCGOnnRGwbsm2
 b46aBpoD+HuTRlkoolURBGnoctSkwPAdrBH3u2mNkDVAuJqLbrCYy80mMJGhHrE7aRfT
 TAtcty0M3Wg3yFSbCMPpDU4F6MWbncrOw3qqrI842WYceLhdQa84ek1QMk7pN+InMq1T 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vq0q454vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 17:16:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9IHDP6O121388;
        Fri, 18 Oct 2019 17:16:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vq0dy26f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Oct 2019 17:16:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9IHGWBB031749;
        Fri, 18 Oct 2019 17:16:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Oct 2019 17:16:32 +0000
Date:   Fri, 18 Oct 2019 10:16:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <esandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: filesystem-dax huge page test fails due to misaligned extents
Message-ID: <20191018171630.GA6719@magnolia>
References: <CAPcyv4jZTM6m7=UdoMrC=QpS4X8W4_6X_t_wM8ZjoYDCc_Z4=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jZTM6m7=UdoMrC=QpS4X8W4_6X_t_wM8ZjoYDCc_Z4=A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9414 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910180157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 18, 2019 at 09:10:34AM -0700, Dan Williams wrote:
> Hi,
> 
> In the course of tracking down a v5.3 regression with filesystem-dax
> unable to generate huge page faults on any filesystem, I found that I
> can't generate huge faults on v5.2 with xfs, but ext4 works. That
> result indicates that the block device is properly physically aligned,
> but the allocator is generating misaligned extents.
> 
> The test fallocates a 1GB file and then looks for a 2MB aligned
> extent. However, fiemap reports:
> 
>         for (i = 0; i < map->fm_mapped_extents; i++) {
>                 ext = &map->fm_extents[i];
>                 fprintf(stderr, "[%ld]: l: %llx p: %llx len: %llx flags: %x\n",
>                                 i, ext->fe_logical, ext->fe_physical,
>                                 ext->fe_length, ext->fe_flags);
>         }
> 
> [0]: l: 0 p: 208000 len: 1fdf8000 flags: 800
> [1]: l: 1fdf8000 p: c000 len: 170000 flags: 800
> [2]: l: 1ff68000 p: 2000c000 len: 1ff70000 flags: 800
> [3]: l: 3fed8000 p: 4000c000 len: 128000 flags: 801
> 
> ...where l == ->fe_logical and p == ->fe_physical.
> 
> I'm still searching for the kernel where this behavior changed, but in
> the meantime wanted to report this in case its something
> straightforward in the allocator. The mkfs.xfs invocation in this case
> was:
> 
>     mkfs.xfs -f -d su=2m,sw=1 -m reflink=0 /dev/pmem0

As we talked about on irc while I waited for a slooow imap server, I
think this is caused by fallocate asking for a larger allocation than
the AG size.  The allocator of course declines this, and bmap code is
too fast to drop the alignment hints.  IIRC Brian and Carlos and Dave
were working on something in this area[1] but I don't think there's been
any progress in a month(?)

Then Dan said agsize=131072, which means 512M AGs, so a 1G fallocate
will never generate an aligned allocation... but a 256M one seems to
work fine on my test vm.

--D

[1] https://lore.kernel.org/linux-xfs/20190912143223.24194-1-bfoster@redhat.com/
