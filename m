Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E406C63697
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 01:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A4922253
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Nov 2020 01:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HjbKZm+l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgKTBF2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 20:05:28 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51708 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgKTBF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Nov 2020 20:05:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK14A4k106187;
        Fri, 20 Nov 2020 01:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TErFelRIExkc80VCupJ2TtqO1oRCGE+ahzFLUusFktA=;
 b=HjbKZm+lJffxxD2UGAs9usBWCdlpkaY+TLwTP7TllsaLfOMq0mmsCaOV2gkAaaK8rZT6
 MMcH9zkyHZSunVVyR8ZYROolegEuyQNJxaSOf0M+5RxnIl2EMtFPN68TgbaWW9ylRwKV
 zhXIjzgMPd+eYSyCfBSBnQ0bo8BZOn6JemGnCfp9wS+Nn8wck0JNHeCxWxyPkj2NgwEs
 Fzm92+9/nCdklPlYGobbbYC5GwJZbz0mcBUg4Xh0oP4/4Asi3LBtYHha1Vxq7dcu7heU
 0xPMLHHUz1kf0nfPUGhrAIxBFiIwbvk4ERESZZoU5oEwiJJ2VotgcgCW1gpsShPHXn/y 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34t7vngdra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 20 Nov 2020 01:05:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AK0tbAb065700;
        Fri, 20 Nov 2020 01:05:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34ts0ujtey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 01:05:23 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AK15MQ7013378;
        Fri, 20 Nov 2020 01:05:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Nov 2020 17:05:22 -0800
Date:   Thu, 19 Nov 2020 17:05:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     bfoster@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 5/9] xfs_db: add inobtcnt upgrade path
Message-ID: <20201120010521.GH9695@magnolia>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521801.880355.2055596956122419535.stgit@magnolia>
 <20201116211351.GT9695@magnolia>
 <cd58a995-7146-abfc-f24e-76b57067cebb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd58a995-7146-abfc-f24e-76b57067cebb@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9810 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011200007
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 18, 2020 at 03:05:42PM -0600, Eric Sandeen wrote:
> On 11/16/20 3:13 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Enable users to upgrade their filesystems to support inode btree block
> > counters.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: set inprogress to force repair (which xfs_admin immediately does),
> > clean up the code to pass around fewer arguments, and try to revert the
> > change if we hit io errors
> > ---
> 
> sooooo the inprogress thing sets off some unexpected behavior.
> 
> In testing this, I noticed that if we have inprogress set, and uknown features/
> version on disk, we go looking for backup superblocks and actually end up
> corrupting the filesystem before bailing out:
> 
> # xfs_repair /dev/pmem0p2 
> Phase 1 - find and verify superblock...
> bad primary superblock - filesystem mkfs-in-progress bit set !!!
> 
> attempting to find secondary superblock...
> .found candidate secondary superblock...
> verified secondary superblock...
> writing modified primary superblock
> sb realtime bitmap inode value 18446744073709551615 (NULLFSINO) inconsistent with calculated value 129
> resetting superblock realtime bitmap inode pointer to 129
> sb realtime summary inode value 18446744073709551615 (NULLFSINO) inconsistent with calculated value 130
> resetting superblock realtime summary inode pointer to 130
> Superblock has unknown compat/rocompat/incompat features (0x0/0x8/0x0).
> Using a more recent xfs_repair is recommended.
> Found unsupported filesystem features.  Exiting now.
> 
> # xfs_db -c check /dev/pmem0p2
> disconnected inode 129, nlink 1
> disconnected inode 130, nlink 1
> 
> so this seems to have exposed a hole in how repair deals with unknown features
> when the inprogress bit is set.
> 
> And TBH scampering off to find backup superblocks to "repair" an inprogress
> filesystem seems like ... not the right thing to do after a feature upgrade.
> 
> I'm not sure what's better, but 
> 
> > bad primary superblock - filesystem mkfs-in-progress bit set !!!
> 
> seems ... unexpected for this purpose.

Yeah.  Dave suggested that I use an incompat flag for this, so I think
I'll do that instead since inprogress is such a mess.

--D

> -Eric
> 
