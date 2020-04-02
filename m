Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8422BC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 15:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E3E2072E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 15:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W3D36CZk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbgDBPQh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:16:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388744AbgDBPQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 11:16:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032F9eIm135622;
        Thu, 2 Apr 2020 15:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=edIdGnyQ64CeIiBHAg0H6RXHgg+XYdPThEw3tq95hfY=;
 b=W3D36CZkVManu/nOy6Mlud5EKZH51tf4hhLw8gO78Q6PkRpd0s6XUwo6v5EgQCsoUBYT
 Vvnx9+NNNc0NDTc7nd6rMxGJPet+fB7fwrmuugo/uv8uzuIWPNSzHizWK9QXrne9oFrc
 Ve5uA88dT1JZn5CTDUvrGw6RrZ2n1uD5xUq5J3ouhLIxDTBmlsdqib9kTjHEgidfvNDd
 2YDc6Kde+IFLGBx1j+R7dFjpQXKndHFpcVEu3qJpzesx3qonHD7nXjCPXmNqKCCBW9vH
 L0d+pGKOqQPpWqJTgTkcXQayFlW+ZWgfcVY5+bacdO803IQds/76Xi9YV7qWRL1s/2WD Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 303cevc3gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 15:16:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032F77Ww077906;
        Thu, 2 Apr 2020 15:14:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 302g2js0s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 15:14:33 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032FEWF6012995;
        Thu, 2 Apr 2020 15:14:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 08:14:32 -0700
Date:   Thu, 2 Apr 2020 08:14:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: reflink should force the log out if mounted with
 wsync
Message-ID: <20200402151431.GG80283@magnolia>
References: <20200402041705.GD80283@magnolia>
 <20200402075108.GB17191@infradead.org>
 <20200402084930.GA26523@infradead.org>
 <20200402145344.GE80283@magnolia>
 <20200402145648.GA23488@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402145648.GA23488@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 02, 2020 at 07:56:48AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 02, 2020 at 07:53:44AM -0700, Darrick J. Wong wrote:
> > > > Looks reasonable.  That being said I really hate the way we handle
> > > > this - I've been wanting to rework the wsync/dirsync code to just mark
> > > > as transaction as dirsync or wsync and then let xfs_trans_commit handle
> > > > checking if the file system is mounted with the option to clean this
> > > > mess up.  Let me see if I could resurrect that quickly.
> > > 
> > > Resurrected and under testing now.  While forward porting your patch
> > > I noticed it could be much simpler even without the refactor by just
> > > using xfs_trans_set_sync.  The downside of that is that the log force
> > > is under the inode locks, but so are the log forces for all other wysnc
> > > induced log forces.  So I think you should just submit this in the
> > > simplified version matching the rest of the wsync users as a fix. If
> > > we want to optimize it later on that should be done as a separate patch
> > > and for all wsync/dirsync users.
> > 
> > Can you please send in a Reviewed-by so I can get this moving? :)
> 
> In case the above wasn't clear: I don't think this is the right way
> to go.  Just to fix the reflink vs wsync bug I think we want a
> one-liner like this:

Sorry, I thought "you should just submit this in the simplified version"
was referring to the first patch I sent, as opposed to the cleanups
you're testing.

> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index b0ce04ffd3cd..e2cc7b84ca6c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -948,6 +948,7 @@ xfs_reflink_update_dest(
>  
>  	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
>  
> +	xfs_trans_set_sync(tp);

This isn't enough because this is only the last transaction in the
reflink sequence if we have to set the destination inode's size.  If
(say) we're reflinking a range inside EOF of two files that were already
sharing blocks, we still won't force the log out.

The other thing I thought of was simply invoking fsync after dropping
the iolock, but that seemed like more work than was strictly necessary
to land the reflink transactions on disk.

--D

>  	error = xfs_trans_commit(tp);
>  	if (error)
>  		goto out_error;
