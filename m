Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F92C71155
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 16:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F31F220715
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 16:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BQkPwzUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390619AbgKXQvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:51:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42168 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390576AbgKXQvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 11:51:40 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOGn8Bm181585;
        Tue, 24 Nov 2020 16:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6ThNVkHOC9AGja3ZNyGXzSCfL5A3XXn1xZfdqGwQJik=;
 b=BQkPwzUqENbdymmiSgl2sQCvIpE5rAHVRzDYcuX+/07hrmH59A9IKAACmRZRVyvzMfmF
 R6AJSHVzBA1Cs05f6ZpnnIPSkUrcpAK2T0rKdIIBsaP9WkJruwXlC2Mvx8CP9bv7PRB2
 TYY9nPg+WDoX5DDL9VjyWmRGrmwPdUvtIVTqESZ6yavihcS1o/M4Xlapw5XYdzzRG3V+
 Dcb1VoZ3vuD2sMKmAo+FGMT5qpnYP74W9IFHSBmnjJJYUqylwTH+yPHH1DG+7C2+W7fb
 bMofxeMh6NvkgFi/ugINJlkBN3IJ1cjoR5i5S34HWK77rKrI1xVagN9NEIZscmD/Avw5 Ug== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34xrdav05j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 16:50:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AOGUxM4070501;
        Tue, 24 Nov 2020 16:50:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34yctwr2j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 16:50:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AOGoI17029352;
        Tue, 24 Nov 2020 16:50:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Nov 2020 08:50:17 -0800
Date:   Tue, 24 Nov 2020 08:50:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: show the proper user quota options
Message-ID: <20201124165017.GG7880@magnolia>
References: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
 <20201124003028.GF7880@magnolia>
 <762983f4-6803-2bae-3e21-e7f1dfa95991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <762983f4-6803-2bae-3e21-e7f1dfa95991@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9815 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240104
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 24, 2020 at 04:37:07PM +0800, kaixuxia wrote:
> 
> 
> On 2020/11/24 8:30, Darrick J. Wong wrote:
> > On Mon, Nov 23, 2020 at 05:38:52PM +0800, xiakaixu1987@gmail.com wrote:
> >> From: Kaixu Xia <kaixuxia@tencent.com>
> >>
> >> The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
> >> and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
> >> shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
> >> seems wrong, Fix it and show proper options.
> > 
> > This needs a regression test case to make sure that quota mount options
> > passed in ==> quota options in /proc/mounts, wouldn't you say? ;)
> 
> Hi Darrick,
> 
> The simple test case as follows:
> 
> Before the patch:
>  # mount -o uqnoenforce /dev/vdc1 /data1
>  # cat /proc/mounts | grep xfs
> /dev/vdc1 /data1 xfs rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,usrquota 0 0
> 
> After the patch:
>  # mount -o uqnoenforce /dev/vdc1 /data1
>  # cat /proc/mounts | grep xfs
> /dev/vdc1 /data1 xfs rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,uqnoenforce 0 0
> 
> I'm not sure if a xfstest case is needed:)

It's been broken for a decade and nobody noticed.

YES IT IS.

--D

> 
> Thanks,
> Kaixu
> 
> > 
> > --D
> > 
> >> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> >> ---
> >>  fs/xfs/xfs_super.c | 10 ++++++----
> >>  1 file changed, 6 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >> index e3e229e52512..5ebd6cdc44a7 100644
> >> --- a/fs/xfs/xfs_super.c
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -199,10 +199,12 @@ xfs_fs_show_options(
> >>  		seq_printf(m, ",swidth=%d",
> >>  				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
> >>  
> >> -	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
> >> -		seq_puts(m, ",usrquota");
> >> -	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
> >> -		seq_puts(m, ",uqnoenforce");
> >> +	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
> >> +		if (mp->m_qflags & XFS_UQUOTA_ENFD)
> >> +			seq_puts(m, ",usrquota");
> >> +		else
> >> +			seq_puts(m, ",uqnoenforce");
> >> +	}
> >>  
> >>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
> >>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
> >> -- 
> >> 2.20.0
> >>
> 
> -- 
> kaixuxia
