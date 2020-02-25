Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07619C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE68C21744
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AfpPpJ4r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgBYPIY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:08:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729855AbgBYPIY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:08:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PF2a1x125694;
        Tue, 25 Feb 2020 15:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=kuSg9efEUC6eG8Vv66fVCMMzHw7vsRL4hZaq/RfPV+M=;
 b=AfpPpJ4rFT6XEair3xOqqSvf6NhSfJ0zymLNoMlT2J1zIeaLu8vGt5oN6q67nak5DaF0
 P9EdIg2UI4aaBJkx+1z/ykJF5GsX+X2CGhW8SywQVjXTNDjfN9QWI1OA0CrotmBl6AqV
 ZIuLLUMSKLx+0hyhvzmxNDPYU17CzCa9bOYQqNdjvDtwahZTs0Xb79sVidmpSutG1on0
 4abrC9nxxHACdiq3MrnWPgXF5dC52wuqH3tdunQhY8F1CQQS2oMbGVoXOH+20DM4ezxo
 ILQhEwueu1VzBzaVCQCHrj4ArBNyEG7mCRpIgumLfrcY32WP/LIl4CQ9tgSWIAIA4Ukx fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yd0m1t0pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:08:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PF6cGM021241;
        Tue, 25 Feb 2020 15:08:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ybduwy8jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 15:08:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01PF8HQ8022123;
        Tue, 25 Feb 2020 15:08:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 07:08:16 -0800
Date:   Tue, 25 Feb 2020 07:08:15 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] libxfs: zero the struct xfs_mount when unmounting
 the filesystem
Message-ID: <20200225150815.GB6748@magnolia>
References: <158258947401.451256.14269201133311837600.stgit@magnolia>
 <158258948007.451256.11063346596276638956.stgit@magnolia>
 <4dfc826f-5f46-1dd7-3232-a35bd7b16573@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dfc826f-5f46-1dd7-3232-a35bd7b16573@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=2 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250118
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:57:03PM -0800, Eric Sandeen wrote:
> On 2/24/20 4:11 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Since libxfs doesn't allocate the struct xfs_mount *, we can't just free
> > it during unmount.  Zero its contents to prevent any use-after-free.
> 
> seems fine but makes me wonder what prompted it.  Did we have a use
> after free?

No, just Brian musing about the possibility of it, so I said I'd zero
it out to make a UAF more obvious.

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks for the review.

--D

> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/init.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index d4804ead..197690df 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -904,6 +904,7 @@ libxfs_umount(
> >  	if (mp->m_logdev_targp != mp->m_ddev_targp)
> >  		kmem_free(mp->m_logdev_targp);
> >  	kmem_free(mp->m_ddev_targp);
> > +	memset(mp, 0, sizeof(struct xfs_mount));
> >  
> >  	return error;
> >  }
> > 
