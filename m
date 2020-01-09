Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BB7C282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 16:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21C83206ED
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 16:50:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CzqjLMhe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbgAIQu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 11:50:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48782 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733021AbgAIQu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 11:50:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Gh016052060;
        Thu, 9 Jan 2020 16:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=sgIB5fq/mF8cyFRfOXWscoGtQKjjk5rv9KHCM1fB7Mo=;
 b=CzqjLMhe6zCofwp1PJEgEa+a9sI/pt0P5xL4yrSFJEUjEfmqOccyvdhT3HOze1/EpnXn
 iK2KkNTFlvzlLB4HpMJZ7wcc03ljM2+oddcObujJxlXXPuSV5Wldd3sOahXBSAJNqxQV
 lXzmMFlomDi9DaPQvB18amvNQZnUele9fGCdzUCt4oghl9CWeS7dfaEYPvX2tl3wr8Jn
 LLG66D+q+1+LGzmzl038PZKB9Y2ZdNLiqVz81mfsZFAkINFyoZfEAF3QL6jaJ/aAw3fN
 tXwhPvnlq9gE7Qhx1EyfWTQqtYUuxvObtWSa+lOt8VQgwECY6MktgaaoawPYWNfOSVhd kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xaj4uc6hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jan 2020 16:50:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009GhbX3037447;
        Thu, 9 Jan 2020 16:50:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xdmrymf5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jan 2020 16:50:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 009GonwM003887;
        Thu, 9 Jan 2020 16:50:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 08:50:49 -0800
Date:   Thu, 9 Jan 2020 08:50:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix xfs_dir2_sf_entry_t size check
Message-ID: <20200109165048.GB8247@magnolia>
References: <20200109141459.21808-1-vincenzo.frascino@arm.com>
 <c43539f2-aa9b-4afa-985c-c438099732ff@sandeen.net>
 <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a540ee4-6597-c79e-1bce-6592cb2f3eae@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 03:35:46PM +0000, Vincenzo Frascino wrote:
> Hi Eric,
> 
> On 09/01/2020 15:01, Eric Sandeen wrote:
> > On 1/9/20 8:14 AM, Vincenzo Frascino wrote:
> >> xfs_check_ondisk_structs() verifies that the sizes of the data types
> >> used by xfs are correct via the XFS_CHECK_STRUCT_SIZE() macro.
> >>
> >> xfs_dir2_sf_entry_t size is set erroneously to 3 which breaks the
> >> compilation with the assertion below:
> >>
> >> In file included from linux/include/linux/string.h:6,
> >>                  from linux/include/linux/uuid.h:12,
> >>                  from linux/fs/xfs/xfs_linux.h:10,
> >>                  from linux/fs/xfs/xfs.h:22,
> >>                  from linux/fs/xfs/xfs_super.c:7:
> >> In function ‘xfs_check_ondisk_structs’,
> >>     inlined from ‘init_xfs_fs’ at linux/fs/xfs/xfs_super.c:2025:2:
> >> linux/include/linux/compiler.h:350:38:
> >>     error: call to ‘__compiletime_assert_107’ declared with attribute
> >>     error: XFS: sizeof(xfs_dir2_sf_entry_t) is wrong, expected 3

So, working as expected -- with size == 4 the directory metadata block
pointer calculations will be incorrect, and you'll end up with a corrupt
filesystem.

> >>     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
> >>
> >> Restore the correct behavior defining the correct size.
> > 
> > # pahole -C xfs_dir2_sf_entry fs/xfs/xfs.o 
> > 
> > struct xfs_dir2_sf_entry {
> > 	__u8                       namelen;              /*     0     1 */
> > 	__u8                       offset[2];            /*     1     2 */
> > 	__u8                       name[0];              /*     3     0 */

This sounds like gcc getting confused by the zero length array.  Though
it's odd that randconfig breaks, but defconfig doesn't?  This sounds
like one of the kernel gcc options causing problems.

> > 
> > 	/* size: 3, cachelines: 1, members: 3 */
> > 	/* last cacheline: 3 bytes */
> > };
> > 
> > Can you please the same command on your machine, along with which arm abi is
> > in use etc just for clarity?
> >
> 
> The abi is arm32 eabihf. You can reproduce my scenario using randconfig with
> seed 0x72F68201.

Please send the actual .config file produced by randconfig 72f68201...

> In this case I get size 4, hence my patch.
> 
> If I enable xfs on the defconfig though size is 3 accordingly to what you have
> reported. I will continue the investigation.

...and the .config file produced by defconfig, in the hopes that someone
will spot the culprit using differential analysis.  Assuming you haven't
done that already.

--D

> Vincenzo
> 
> > -Eric
> > 
> >> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> >> Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
> >> ---
> >>  fs/xfs/xfs_ondisk.h | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> >> index b6701b4f59a9..ee487ddc60c7 100644
> >> --- a/fs/xfs/xfs_ondisk.h
> >> +++ b/fs/xfs/xfs_ondisk.h
> >> @@ -104,7 +104,7 @@ xfs_check_ondisk_structs(void)
> >>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
> >>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
> >>  	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
> >> -	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
> >> +	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		4);
> >>  	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
> >>  	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
> >>  	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
> >>
> 
> -- 
> Regards,
> Vincenzo

pub   RSA 4096/072FD436 2019-09-02 Vincenzo Frascino <vincenzo.frascino@arm.com>
> sub   RSA 2048/4205BF15 2019-09-02
> sub   RSA 2048/296522AA 2019-09-02
> sub   RSA 2048/7CAB726B 2019-09-02
> 
