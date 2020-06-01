Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC1DC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 23:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112B92076B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 23:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJHwHMY7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgFAXR4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 19:17:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50480 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgFAXR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 19:17:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051NC4qn047430;
        Mon, 1 Jun 2020 23:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fuVPuD1U1ystmW2zlc96Zs8axlZl6yMmLPVSzosyUcE=;
 b=CJHwHMY7dXZ3is9LtiAelagg/dDD+XpGjk2BJqDCIpXqgznkmlYE8wpKeaYd5OrbuxLi
 D9vW0wPPKQRLgCdtV2RY4RIk91AHHqWUbkDe2dlKpxcsOS+GOIdsxwpRmN+Kp/VkEGPX
 KegpvZYO9PY6TW1sC0n7M1mT+JVwPk74TfccC/IPV9wh/Zeb5UV1ZDfhhOd5jXjIVmnQ
 kL7yadaatipsMyOWXck1geDFhL4Sl2fmEtHTWz96xYEpvSJYgGx7pef4/Haq6ZjO2oO8
 XPe4qMFV5C//jMIL4Yc2fHJFxm0l6Qqbazr3eEpR8rrfn8t9kA1KiUfSvM0I5x2RLgX4 pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31d5qr1cfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 01 Jun 2020 23:17:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051NHMSU137961;
        Mon, 1 Jun 2020 23:17:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31c12n79k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jun 2020 23:17:53 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 051NHrFw017306;
        Mon, 1 Jun 2020 23:17:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 16:17:53 -0700
Date:   Mon, 1 Jun 2020 16:17:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 11/14] xfs: widen ondisk timestamps to deal with y2038
 problem
Message-ID: <20200601231751.GD2162697@magnolia>
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <157784113220.1364230.3763399684650880969.stgit@magnolia>
 <CAOQ4uxj9_6AHPkBmPUpqZ_-nnqgzkwPT4xik=Xi1XQ61JJcTFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj9_6AHPkBmPUpqZ_-nnqgzkwPT4xik=Xi1XQ61JJcTFw@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=1 spamscore=0 bulkscore=0 mlxlogscore=901
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006010170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=928 cotscore=-2147483648
 mlxscore=0 lowpriorityscore=0 suspectscore=1 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 31, 2020 at 03:30:42PM +0300, Amir Goldstein wrote:
> > @@ -265,17 +278,35 @@ xfs_inode_from_disk(
> >         if (to->di_version == 3) {
> >                 inode_set_iversion_queried(inode,
> >                                            be64_to_cpu(from->di_changecount));
> > -               xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
> > +               xfs_inode_from_disk_timestamp(from, &to->di_crtime,
> > +                               &from->di_crtime);
> >                 to->di_flags2 = be64_to_cpu(from->di_flags2);
> >                 to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
> > +               /*
> > +                * Convert this inode's timestamps to bigtime format the next
> > +                * time we write it out to disk.
> > +                */
> > +               if (xfs_sb_version_hasbigtime(&mp->m_sb))
> > +                       to->di_flags2 |= XFS_DIFLAG2_BIGTIME;
> >         }
> 
> This feels wrong.
> incore inode has a union for timestamp.
> This flag should indicate how the union should be interpreted
> otherwise it is going to be very easy to stumble on that in future code.

Hm?  I think you've gotten it backwards.

The incore inode (struct xfs_icdinode) has a struct timespec64.

The ondisk inode (struct xfs_dinode) has a union xfs_timestamp.

xfs_inode_from_disk_timestamp uses the ondisk inode (from) to convert
the ondisk timestamp (&from->di_crtime) to the incore inode
(&to->di_crtime).

In other words, we use the ondisk flag and union to load the ondisk
timestamp into a format-agnostic incore structure.  Then we set BIGTIME
in the incore inode (to->di_flags2).

If and when we write the inode back out to disk, we'll see that BIGTIME
is set in the incore inode, and convert the incore structure into the
bigtime encoding on disk.

> So either convert incore timestamp now or check hasbigtime when
> we write to disk.

That's more or less what this is doing.  We read the timestamp in from
disk in whatever format it's in, and then set ourselves up to write it
back out in bigtime format.

--D

> Thanks,
> Amir.
