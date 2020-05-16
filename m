Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC3CC433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34050206D4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:29:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QiWmwBS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgEPS3e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 14:29:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgEPS32 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 14:29:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GIRat8091106;
        Sat, 16 May 2020 18:29:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+szjfTmvJ3FZceOu438GMDWsauQ9CIj1I345DxtQORY=;
 b=QiWmwBS7aTcsRilY9q66mH79FJ7lGiKFjuV2+CDgHZlemwb1mpbPyXgpa2cq2/uBBVEm
 JdM9PWg4OOjby1+ZNi81pt1Zwm51YVA6D74gCeo2l4r0K3XoR9L4ufVhvg2Kmmh/jzLf
 Dv8hbO4zSjK8OMlkAmJ4RJFW8WZ3P2n+tcdtqcfx2KJOPOZGTMzPTb0xjmqeCoVnZ8oG
 5QQDvn2CN7GCTBemZ0km4a8XZ6CUZnGQPN+oMIumT8kkhvtgMyyEDz36WjlFOvCWT6HT
 91TQpsdy460vkdAn4djeJWN7/0bwFv0zsA2DsKuaPcXBiXSp45VBKiAo5yKcfvFJh4wN qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127kqsh0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 18:29:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GISHQx094685;
        Sat, 16 May 2020 18:29:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 312679ebss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 18:29:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04GITOX8012239;
        Sat, 16 May 2020 18:29:24 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 11:29:24 -0700
Date:   Sat, 16 May 2020 11:29:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: move the fork format fields into struct
 xfs_ifork
Message-ID: <20200516182923.GH6714@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-6-hch@lst.de>
 <20200514212541.GL6714@magnolia>
 <20200516135807.GA14540@lst.de>
 <20200516170143.GO1984748@magnolia>
 <20200516180150.GC6714@magnolia>
 <20200516181658.GA22612@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516181658.GA22612@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 16, 2020 at 08:16:58PM +0200, Christoph Hellwig wrote:
> On Sat, May 16, 2020 at 11:01:50AM -0700, Darrick J. Wong wrote:
> > > In my case it was the xfs_scrub run after generic/001 that did it.
> > > 
> > > I think we're covered against null *ifp in most cases because they're
> > > guarded by an if(XFS_IFORK_Q()); it's jut here where I went around
> > > shortcutting.  Maybe I should just fix this function for you... :)
> > 
> > Hmm, that sounded meaner than I intended it to be. :/
> > 
> > Also, it turns out that it's pretty easy to fix this as part of fixing
> > the contorted logic in patch 1 (aka xchk_bmap_check_rmaps) so I'll do
> > that there.
> 
> How about you send a patch to just fix up that function for now,
> and I'll rebase on top of that?

Ok.

--D
