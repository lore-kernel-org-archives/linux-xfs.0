Return-Path: <SRS0=XUqT=23=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0126DC33C8C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 21:59:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE45C2072A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 21:58:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WIZaFCAm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAFV67 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 16:58:59 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgAFV67 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jan 2020 16:58:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006Lsjgh033841;
        Mon, 6 Jan 2020 21:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qM6wDfOkpgB7R0VuEaV7sFgdpP9cmoitLkOl/e+H2qw=;
 b=WIZaFCAmwjeN2Chz2OXd1c+jrijhCdH1j9VsZP43N2Xm1sydoV3oTcrWjbL5TfMPok3O
 z/SuNfPP1FdWtuA1+9YXUReVgrXBLJMCFQ2Hp/hVS+F/kTr7XdhmVkX2TfrFQq+6TEjI
 qIoQ250oEzuGpj9WpB0PENcgJukh4oNND6ci/h/QHTnctnH0mv2yzOjjjuMns5giYXoy
 YHRkU7BPodA/EZqmLBof//YhNgDjBeQrC65LqPexGDNW27H/jS/Gueh2cSphVnHQPRy+
 l6jcBTU6FA2g1Vb7y9u8qVU3z1d0sRMM1ry8QrZ2LKLhEBeQLlaOmhcptUl+XQ1cVcMy PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xaj4tt17t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 21:58:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 006LwfA6029081;
        Mon, 6 Jan 2020 21:58:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xb47fuuta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Jan 2020 21:58:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 006LvvI4014934;
        Mon, 6 Jan 2020 21:57:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 13:57:57 -0800
Date:   Mon, 6 Jan 2020 13:57:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        cmaiolino@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengbin13@huawei.com,
        yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH 2/2] xfs: fix stale data exposure problem when punch
 hole, collapse range or zero range across a delalloc extent
Message-ID: <20200106215755.GB472651@magnolia>
References: <20191226134721.43797-1-yukuai3@huawei.com>
 <20191226134721.43797-3-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226134721.43797-3-yukuai3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001060184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001060183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 26, 2019 at 09:47:21PM +0800, yu kuai wrote:
> In xfs_file_fallocate, when punch hole, zero range or collapse range is
> performed, xfs_fulsh_unmap_range() need to be called first. However,
> xfs_map_blocks will convert the whole extent to real, even if there are
> some blocks not related. Furthermore, the unrelated blocks will hold stale
> data since xfs_fulsh_unmap_range didn't flush the correspond dirty pages
> to disk.
> 
> In this case, if user shutdown file system through xfsioctl with cmd
> 'XFS_IOC_GOINGDOWN' and arg 'XFS_FSOP_GOING_FLAGS_LOGFLUSH'. All the
> completed transactions will be flushed to disk, while dirty pages will
> never be flushed to disk. And after remount, the file will hold stale
> data.

Waitaminute, what problem are you trying to solve?

You have a file with a huge delalloc extent because we just wrote a
bunch of 'X' characters to part of a file:

---dddddddddddddddd

Then you want to fallocate or something in the middle of that:

---dddddddddddddddd
           ^^^^------ collapse range these blocks

So we xfs_flush_unmap_range to kill the pagecache on that range:

---dddddddddddddddd
           ^^^^------ xfs_flush_unmap_range()

This triggers writeback, which can convert the entire delalloc range to
a single extent:

---rrrrrrrrrrrrrrrr
           ^^^^^^^^-- This is the range we are writing back
   ^^^^^^^^---------- This range doesn't undergo writeback, but we wrote
                      the extent tree anyway

After committing that update to the log, the fs goes down, which leaves
us with the following after we reboot, mount, and recover the fs:

---rrrrrrrrrrrrrrrr
           ^^^^^^^^-- This part contains 'X'
   ^^^^^^^^---------- This range never underwent writeback, so it's full
		      of junk from the previous owner of the space

So your solution is to split the delalloc reservation to constrain the
allocation to the range that's being operated on?

If so, I think a better solution (at least from the perspective of
reducing fragmentation) would be to map the extent unwritten and force a
post-writeback conversion[1] but I got shot down for performance reasons
the last time I suggested that.

--D

[1] https://lore.kernel.org/linux-xfs/155259894630.30230.10064390935593758177.stgit@magnolia/

> Fix the problem by spliting delalloc extent before xfs_flush_unmap_range
> is called.
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  fs/xfs/xfs_file.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c93250108952..5398102feec9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -786,6 +786,50 @@ xfs_break_layouts(
>  
>  	return error;
>  }
> +int
> +try_split_da_extent(
> +	struct xfs_inode	*ip,
> +	loff_t			offset,
> +	loff_t			len)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		start = XFS_B_TO_FSBT(mp, offset);
> +	xfs_fileoff_t		end = XFS_B_TO_FSBT(mp, offset + len - 1);
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	struct xfs_iext_cursor	cur;
> +	struct xfs_bmbt_irec	imap;
> +	int error;
> +
> +	/*
> +	 * if start belong to a delalloc extent and it's not the first block,
> +	 * split the extent at start.
> +	 */
> +	if (xfs_iext_lookup_extent(ip, ifp, start, &cur, &imap) &&
> +	    imap.br_startblock != HOLESTARTBLOCK &&
> +	    isnullstartblock(imap.br_startblock) &&
> +	    start > imap.br_startoff) {
> +		error = xfs_bmap_split_da_extent(ip, start);
> +		if (error)
> +			return error;
> +		ip->i_d.di_nextents--;
> +	}
> +
> +	/*
> +	 * if end + 1 belong to a delalloc extent and it's not the first block,
> +	 * split the extent at end + 1.
> +	 */
> +	if (xfs_iext_lookup_extent(ip, ifp, end + 1, &cur, &imap) &&
> +	    imap.br_startblock != HOLESTARTBLOCK &&
> +	    isnullstartblock(imap.br_startblock) &&
> +	    end + 1 > imap.br_startoff) {
> +		error = xfs_bmap_split_da_extent(ip, end + 1);
> +		if (error)
> +			return error;
> +		ip->i_d.di_nextents--;
> +	}
> +
> +	return 0;
> +}
>  
>  #define	XFS_FALLOC_FL_SUPPORTED						\
>  		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
> @@ -842,6 +886,9 @@ xfs_file_fallocate(
>  	 */
>  	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
>  		    FALLOC_FL_COLLAPSE_RANGE)) {
> +		error = try_split_da_extent(ip, offset, len);
> +		if (error)
> +			goto out_unlock;
>  		error = xfs_flush_unmap_range(ip, offset, len);
>  		if (error)
>  			goto out_unlock;
> -- 
> 2.17.2
> 
