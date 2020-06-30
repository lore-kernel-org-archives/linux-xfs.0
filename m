Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B51C433E2
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D65C2074D
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qRVVG4Dt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgF3S0x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 14:26:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390787AbgF3S0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 14:26:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UII9tA081122;
        Tue, 30 Jun 2020 18:26:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uzD5GAqpdkZb6hYNDP6sKG5iGmLgQk2eLufO0X8KVOU=;
 b=qRVVG4Dt4hrqFm7Rup+UuTWTuwP9gY494QM2tYO5M07jmB7CHqDe7JI6y7pw6R4e/+ag
 YDSVw0hHOKPXUs4ghKQ38sU2nTN88hFnlj9cXZu7KixOsJtDTuZiON1ccvQ7IBhZA0S3
 aYbes7TfcELTwm69RY1JKOfy9fV3eG2vDdCS8LeSPeLMIWxkkub8l5wHh4NOwB6GCk0E
 fpEGz8ND/Sz5PhmfTrgSivXjcijQUBg1FliSh8q/AjWJWFZEGd6NQ9kxiQGdyjWyx9Xf
 pdJv5JkFuRhYoM/uJZCQuE+ebJXFPRelAhWB9S9Nth6OltTMCX1BnsWtyP7BwoNEMWFo iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrn66p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 18:26:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UIHlZD059843;
        Tue, 30 Jun 2020 18:26:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1x6dcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 18:26:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UIQmse020553;
        Tue, 30 Jun 2020 18:26:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 18:26:47 +0000
Date:   Tue, 30 Jun 2020 11:26:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200630182645.GQ7606@magnolia>
References: <20200623052059.1893966-1-david@fromorbit.com>
 <20200623211910.GG7606@magnolia>
 <20200623221431.GB2005@dread.disaster.area>
 <20200629170048.GR7606@magnolia>
 <CAOQ4uxiuEVW=d+g_3kj+zdTc_ngEkF+nGnJ+M2g1aU3SqsFa+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiuEVW=d+g_3kj+zdTc_ngEkF+nGnJ+M2g1aU3SqsFa+w@mail.gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=955 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=946
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=1 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 06:23:12PM +0300, Amir Goldstein wrote:
> > /me wonders if someone could please check all the *_ops that point to
> > generic helpers to see if we're missing obvious things like lock
> > taking.  Particularly someone who wants to learn about xfs' locking
> > strategy; I promise it won't let out a ton of bees.
> >
> 
> The list was compiled manually by auditing 'git grep '_operations.*=' fs/xfs'
> structs for non xfs_/iomap_/noop_ functions.
> I am not sure if all iomap_ functions are safe in that respect, but I suppose
> those were done recently with sufficient xfs developers review...

The iomap functions shouldn't be taking/releasing any locks at all; it's
up to the filesystem to provide the concurrency controls.

> fs/xfs/xfs_aops.c:const struct address_space_operations
> xfs_address_space_operations = {
>         .error_remove_page      = generic_error_remove_page,
> 
> generic_error_remove_page() calls truncate_inode_page() without MMAPLOCK
> Is that safe? not sure

/me has a funny feeling it isn't, since this does the same thing to the
pagecache as a holepunch.

> fs/xfs/xfs_file.c:static const struct vm_operations_struct xfs_file_vm_ops = {
>         .map_pages      = filemap_map_pages,
> 
> Fixed by $SUBJECT
> 
> fs/xfs/xfs_file.c:const struct file_operations xfs_file_operations = {
>         .splice_read    = generic_file_splice_read,
> 
> Will call xfs_file_read_iter, so looks fine
> 
>        .splice_write   = iter_file_splice_write,
> 
> Will call xfs_file_write_iter, so looks fine
> 
>        .get_unmapped_area = thp_get_unmapped_area,
> 
> Looks fine?
> 
> fs/xfs/xfs_file.c:const struct file_operations xfs_dir_file_operations = {
>         .read           = generic_read_dir,
>         .llseek         = generic_file_llseek,
> 
> No page cache, no dio, no worries?

Right.

--D

> Thanks,
> Amir.
