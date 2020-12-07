Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF16C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC502388A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 17:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgLGRAD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:00:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51060 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgLGRAD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 12:00:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GxFv8042004;
        Mon, 7 Dec 2020 16:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=26kdzCAJRnnGfDkzkJ0YAVHbvVCADxUADS+QmchIhlE=;
 b=0A5TF3QdCWQVn3yzyuNVNlssQBAxQFC1eHFEJOqiK4EXWEPlhsqipdE6rTRfHucGra66
 Zv5pF9ibKw45DkUZo06YFUhbvltbvnucalDeDHjCsQqFf53Xo+XwEm9x22HyFsijXXDW
 DaBdfFz9YHM98KcdCuQvAPkN35Xp894cqiEb17F/Hp5ebLlfvD6Ndho4kLQAFqtxvdrS
 yzVNswW9dk1uwCIrBkBSti51sO8pRhOT29BpLvOFflmqwAyWxf6QCr90y5QQbO3fm0Dj
 IAcYYIUTbP/sf6V6HUihK7GkILjCr8w3MphJddZTlNhr9ld3UHKbY4T3ERl+vUNTU0w+ aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 357yqbphn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 16:59:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GocV3085892;
        Mon, 7 Dec 2020 16:59:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kyrg6hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 16:59:11 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7GxAnd024956;
        Mon, 7 Dec 2020 16:59:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 08:59:09 -0800
Date:   Mon, 7 Dec 2020 08:59:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201207165908.GN629293@magnolia>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-4-hsiangkao@redhat.com>
 <20201207134941.GD29249@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207134941.GD29249@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 02:49:41PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 07, 2020 at 08:15:30AM +0800, Gao Xiang wrote:
> >  /*
> > + * Initialise a newly allocated inode and return the in-core inode to the
> > + * caller locked exclusively.
> >   */
> > -static int
> > -xfs_ialloc(
> > -	xfs_trans_t	*tp,
> > -	xfs_inode_t	*pip,
> > -	umode_t		mode,
> > -	xfs_nlink_t	nlink,
> > -	dev_t		rdev,
> > -	prid_t		prid,
> > -	xfs_buf_t	**ialloc_context,
> > -	xfs_inode_t	**ipp)
> > +static struct xfs_inode *
> > +xfs_dir_ialloc_init(
> 
> This is boderline bikeshedding, but I would just call this
> xfs_init_new_inode.
> 
> >  int
> >  xfs_dir_ialloc(
> > @@ -954,83 +908,59 @@ xfs_dir_ialloc(
> >  	xfs_inode_t	**ipp)		/* pointer to inode; it will be
> >  					   locked. */
> >  {
> >  	xfs_inode_t	*ip;
> >  	xfs_buf_t	*ialloc_context = NULL;
> > +	xfs_ino_t	pino = dp ? dp->i_ino : 0;
> 
> Maybe spell out parent_inode?  pino reminds of some of the weird Windows
> code that start all variable names for pointers with a "p".
> 
> > +	/* Initialise the newly allocated inode. */
> > +	ip = xfs_dir_ialloc_init(*tpp, dp, ino, mode, nlink, rdev, prid);
> > +	if (IS_ERR(ip))
> > +		return PTR_ERR(ip);
> > +	*ipp = ip;
> >  	return 0;
> 
> I wonder if we should just return the inode by reference from
> xfs_dir_ialloc_init as well, as that nicely fits the calling convention
> in the caller, i.e. this could become
> 
> 	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid, ipp);
> 
> Note with the right naming we don't really need the comment either,
> as the function name should explain everything.

/me notes that some day he will get around to a formal posting of his
giant inode allocation cleanup series that will wrap these parameters
into a struct so we don't have to pass 8 arguments around, and fix the
inode flag inheritance inconsistencies between userspace and kernel...

--D
