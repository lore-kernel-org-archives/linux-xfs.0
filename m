Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D45C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 15:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C23172075A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 15:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dbf7oKln"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgJFP23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 11:28:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51776 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgJFP23 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 11:28:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096FA8Cc057234;
        Tue, 6 Oct 2020 15:28:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YU6AJYFkALbVNT7yEdPQjtB4EFD5W0IGaw0BYcAhNGs=;
 b=Dbf7oKlnfTAZTn0BRBMtA85aWzQyaypNOpOpB1R95HdjZ9iMwrc9A8fYTsmHvFP+2w3Y
 usXlaXK5FAt/SF20zyhtGVDkTFAvhEFj3MGWZMBXNOy2agFL8p887WRxl60qV9BqB/yB
 1xmYeON1B7d3peLH0EWR+Rvo7gTpQdAG3Jw/0R8I18ucu5w4jI0W0o2fmG8eCHxtqtSq
 A0awFZr+bGzhmAbiQ1I8YebC6hUSMheW4JpJ3V0laerSSyn77BguGziCx4WT73MPWMRa
 1SHRoXN3y6B0+5AH2vFo0WXrf6N+0HEpDZmW/abSoPe0PkSZ+8DbDi/b/h/WPtRSrod3 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetavv63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 15:28:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096F5FVM105483;
        Tue, 6 Oct 2020 15:28:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vn5vfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 15:28:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 096FSMFE001619;
        Tue, 6 Oct 2020 15:28:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 08:28:22 -0700
Date:   Tue, 6 Oct 2020 08:28:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201006152821.GW49547@magnolia>
References: <20201005213852.233004-1-preichl@redhat.com>
 <20201005213852.233004-5-preichl@redhat.com>
 <20201006041426.GH49547@magnolia>
 <1796931d-fe5d-2d81-e5bc-2369f89a4688@redhat.com>
 <c2349a06-8ad3-664c-9510-40394fb08288@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2349a06-8ad3-664c-9510-40394fb08288@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=2 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=2 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060100
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 06, 2020 at 09:04:18AM -0500, Eric Sandeen wrote:
> 
> 
> On 10/6/20 5:50 AM, Pavel Reichl wrote:
> >> Also, we're not really releasing the lock itself here, right?  We're
> >> merely updating lockdep's bookkeepping so that the worker can make
> >> itself look like the lock owner (to lockdep, anyway).
> > Hmm...I'm afraid I don't follow - yes we are doing this to satisfy lockdep's bookkeeping,
> > however we actually do this by releasing the lock in one kernel thread and acquiring it in another.
> 
> it's the difference between actually releasing the lock itself, and
> telling lockdep that we're releasing the "ownership" of the lock for tracking
> purposes; I agree that "rwsem_release" is a bit confusingly named.

Yes.

> > 
> >> Does this exist as a helper anywhere in the kernel?  I don't really like
> >> XFS poking into the rw_semaphore innards, though I concede that this
> >> lock transferring dance is probably pretty rare.
> > I'll try to look for it.
> > 
> 
> Other code I see just calls rwsem_release directly - ocfs2, jbd2, kernfs etc.
> 
> I think a clearer comment might suffice, not sure what Darrick thinks, maybe something
> like this:
> 
> +	/*
> +	 * Let lockdep know that we won't own i_lock when we hand off
> +	 * to the worker thread
> +	 */

	/*
	 * Update lockdep's ownership information to reflect that we
	 * will be transferring the ilock from this thread to the
	 * worker.
	 */

> +	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>  	queue_work(xfs_alloc_wq, &args.work);
> +
>  	wait_for_completion(&done);
> +	/* We own the i_lock again */

	/*
	 * Update lockdep's lock ownership information to point to
	 * this thread as the lock owner now that the worker item is
	 * done.
	 */

Perhaps?

--D

> +	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
> 
> and similar comments in the worker:
> 
> +	/* Let lockdep know that we own the i_lock for now */
> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
> ...
> 
> etc
> 
> -Eric
