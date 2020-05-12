Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC2FC2D0FA
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9613B20753
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y+6FUmaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgELXuZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:50:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgELXuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:50:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNmv5S195933;
        Tue, 12 May 2020 23:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0siaDRxhk/6o2O4Vf33EWJHFA2Fpa3EnIP+UUna+siY=;
 b=Y+6FUmaLir7aAR9Mm4VulKltACqzI8dn6hr3tsPsFJEkxP3ub+FtrytZBU9JYHXQgdJB
 mVqMVuqaET59ofiTDCtEhh4nBlv4WnldCXL9pjv5py3nbm6mg8RkcFefbkIrGwsmws9N
 pUFHQfnexFLLppPYpw6KnUrl8Lslaqah/uxDt+nwWoVAQm9WJgaoYVKyT4uRThFX9uDx
 MRh9axJ5/5nrNBw6tAh++rzhZUCtpwUxSpzu6y1aO47XQlHvcoi1J76wYo1fdNvThTCI
 KlUnoAZDbEUUwuScR90gKjp2ajVhaIYt7zGli0q5Ure/HO1fDiNfvfFhKq2Zu863hemL zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3100yfs8r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 23:50:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNgZmm077177;
        Tue, 12 May 2020 23:50:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3100ypcxka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 23:50:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CNoAjW018752;
        Tue, 12 May 2020 23:50:10 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 16:50:10 -0700
Date:   Tue, 12 May 2020 16:50:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200512235009.GS6714@magnolia>
References: <20200501081424.2598914-9-hch@lst.de>
 <20200501155649.GO40250@bfoster>
 <20200501160809.GT6742@magnolia>
 <20200501163809.GA18426@lst.de>
 <20200501165017.GA20127@lst.de>
 <20200501182316.GT40250@bfoster>
 <20200507123411.GB17936@lst.de>
 <20200507134355.GF9003@bfoster>
 <20200507162846.GG9003@bfoster>
 <20200507171857.GA4136@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507171857.GA4136@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 07:18:57PM +0200, Christoph Hellwig wrote:
> On Thu, May 07, 2020 at 12:28:46PM -0400, Brian Foster wrote:
> > To demonstrate, I hacked on repair a bit using an fs with an
> > intentionally corrupted shortform parent inode and had to make the
> > following tweaks to work around the custom fork verifier. The
> > ino_discovery checks were added because phases 3 and 4 toggle that flag
> > such that the former clears the parent value in the inode, but the
> > latter actually updates the external parent tracking. IOW, setting a
> > "valid" inode in phase 3 would otherwise trick phase 4 into using it.
> > I'd probably try to think of something cleaner for that issue if we were
> > to take such an approach.
> 
> Ok, so instead of clearing the parent we'll set it to a guaranteed good
> value (the root ino).  That could kill the workaround I had entirely.

Seems reasonable to me, but someone should try it and see how xfs_repair
reacts.  I think it ought to be fine since it will detect the lack of a
rootdir entry pointing to the damaged dir and move it to lost+found.

--D
