Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CE5C4BA1E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 17:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85BF621D7E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 17:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tKOLxfyi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgBZRz7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:55:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgBZRz7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 12:55:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QHqgu0055346;
        Wed, 26 Feb 2020 17:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ocBJlg2hNFOaQmxqm0W4ZIkH6uaU8CY8uzlO/N7SSzc=;
 b=tKOLxfyiCJ6AC3wAp2tjqV/yASapKI9ylKcELDgEpyMO0OVLBQd0cvF9qq3o5pHyUszK
 CoqJ2EdnOSs59UVsyNJS3rpOh85jUQVGCiIp8yqxCxwYplGpyVVjOjJb+dFsAuMpbZ6Y
 uHUZRNgsSOE/1uWNFFMCSQ4wrBB5SEzKTH1flqR84eg6/YALXMFizNufIFDI3koX4ddu
 duVGGcuTXhhzrePSKc0HPM7DbmbTXUUPjU2XDy121cbD8gyMcyXF13qcyiQwsjLdwnY+
 IZ5wgBObFzyD4Zs79tgsRJTLYPEi4quN8Lo2kU+RozlXS/Bw0wPRfl7IwZMNnLMSHh0O MA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct35bpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 17:55:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QHiOjR116798;
        Wed, 26 Feb 2020 17:55:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ydcs5pgnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 17:55:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01QHtsX5024059;
        Wed, 26 Feb 2020 17:55:54 GMT
Received: from localhost (/10.159.139.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 09:55:53 -0800
Date:   Wed, 26 Feb 2020 09:55:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 7/7] xfs_repair: try to correct sb_unit value from
 secondaries
Message-ID: <20200226175552.GH8045@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086364145.2079685.5986767044268901944.stgit@magnolia>
 <e1830559-69bf-6302-dc85-e3994f680882@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1830559-69bf-6302-dc85-e3994f680882@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 09:42:01AM -0800, Eric Sandeen wrote:
> On 2/4/20 4:47 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If the primary superblock's sb_unit leads to a rootino calculation that
> > doesn't match sb_rootino /but/ we can find a secondary superblock whose
> > sb_unit does match, fix the primary.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> With the previous patch issuing a warning
> 
> +_("sb root inode value %" PRIu64 " valid but in unaligned location (expected %"PRIu64") possibly due to sunit change\n"),
> 
> What does this do in the case where the user intentionally changed the
> sunit, which is (I think) the situation launched this work in the first
> place?

[echoing what we just discussed on irc]

repair will print the above warning, and then it'll try to find either a
backup sb with a sunit value that makes the computation work, or guess
at sunit values until it finds one that makes the computation work.  If
it finds a reasonable sunit value it'll change it back to that.

If the user mounts an old kernel with the same bad sunit value, the
kernel will set it back to the bad value and we wash, rinse, and repeat.

If the user mounts a new kernel with the same bad sunit value, it'll
decline to change the sunit value.

If the user runs the bad-sunit fs against an old xfs_repair it will
descend into madness nuking the root directory, which is why we're
trying to nudge ourselves away from the bad value.

> Will that warning persist in the case of an intentional sunit change?

Yes.

--D

> Thanks,
> -Eric
> 
