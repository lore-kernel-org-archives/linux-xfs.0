Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CC4C34022
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE8AD208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 04:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xx55ov7r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgBSEsh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Feb 2020 23:48:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52142 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgBSEsh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Feb 2020 23:48:37 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4m8M5093690;
        Wed, 19 Feb 2020 04:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3D3izYSJ1n6TIZypm0IKHug2J4h1W805rkEF+JJ6icg=;
 b=xx55ov7rmjOlKKrX222nZ/0W5XiXshSmvH/QAUnC39OARAAMlSWBB9w7Wlz0OxD7+2tC
 jMxGBfv2vPg8SQrYhMiQrCls35mkYvMQpPKjmiK3I3jNk2eqcR8LFe1Hnb1uduJVgTh2
 3wLUKLx1u4AmWNGwAZ+xz7Wfb3o19cvKz1OyoCgdf/J+FNpyhQ4kGZeLJ/Tm1dNRD/rz
 KNo3ZcyiTlIaIFfiRmkdrqbYhbPSqbObJhWOtis90hv0V9J+bSPaj0ZBBJtVHozcXju1
 3sQn6AjNpmV0EDOmC1SYS/UbFxWAraNcm2TgObcJrs76qgd0kESSjftLcZKwLUUzcBc2 og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y8ud10hah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:48:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01J4mOD2115221;
        Wed, 19 Feb 2020 04:48:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2y8ud9qa25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 04:48:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01J4mN9X016859;
        Wed, 19 Feb 2020 04:48:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Feb 2020 20:48:22 -0800
Date:   Tue, 18 Feb 2020 20:48:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
Message-ID: <20200219044821.GK9506@magnolia>
References: <20200214185942.1147742-1-preichl@redhat.com>
 <20200217133521.GD31012@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217133521.GD31012@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9535 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 05:35:21AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 14, 2020 at 07:59:39PM +0100, Pavel Reichl wrote:
> > Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> > __xfs_rwsem_islocked() is a helper function which encapsulates checking
> > state of rw_semaphores hold by inode.
> > 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > Suggested-by: Dave Chinner <dchinner@redhat.com>
> > Suggested-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> >  fs/xfs/xfs_inode.c | 54 ++++++++++++++++++++++++++++++++--------------
> >  fs/xfs/xfs_inode.h |  2 +-
> >  2 files changed, 39 insertions(+), 17 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c5077e6326c7..3d28c4790231 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -345,32 +345,54 @@ xfs_ilock_demote(
> >  }
> >  
> >  #if defined(DEBUG) || defined(XFS_WARN)
> > -int
> > +static inline bool
> > +__xfs_rwsem_islocked(
> > +	struct rw_semaphore	*rwsem,
> > +	bool			shared,
> > +	bool			excl)
> > +{
> > +	bool locked = false;
> > +
> > +	if (!rwsem_is_locked(rwsem))
> > +		return false;
> > +
> > +	if (!debug_locks)
> > +		return true;
> > +
> > +	if (shared)
> > +		locked = lockdep_is_held_type(rwsem, 0);
> > +
> > +	if (excl)
> > +		locked |= lockdep_is_held_type(rwsem, 1);
> > +
> > +	return locked;
> 
> This could use some comments explaining the logic, especially why we
> need the shared and excl flags, which seems very confusing given that
> a lock can be held either shared or exclusive, but not neither and not
> both.

Yes, this predicate should document that callers are allowed to pass in
shared==true and excl==true when the caller wants to assert that either
lock type (shared or excl) of a given lock class (e.g. iolock) are held.

--D
