Return-Path: <SRS0=+YF0=Z2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A613C43603
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 21:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B3552073C
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Dec 2019 21:57:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Oij7wXFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbfLDV5U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Dec 2019 16:57:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46752 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfLDV5T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Dec 2019 16:57:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4LsMbh056715;
        Wed, 4 Dec 2019 21:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+p0QtgOU3PGQGqiTDp9VWVkmF3teT4O9Gq4nncbCvPA=;
 b=Oij7wXFvTpypy22mi+rPscEBX3WErolSPCU5WvTR2sD9t7SLE/1jAe6tX1+CMzVR8iKY
 Mitv7DeviqL3ZuyWbdCcgbmX1ncN0n740rhq2OLQo8dsFiCHIbaSJRbnOB0W/P0IPcRD
 6gkYp/90wolGZJaMB3+MfK8EzhPAo4dlxHyNbR2dNuf1jrWCTRXekV+YMyXu0AAv3rrH
 AV+ffxjSOz05AZ7ZC8PNnInS3a/+l72ZVqZBl+OkY1IdYyQSRVEIdlMnF40ogCx1AWP8
 2lIFCxSRBxDGsShzO9utQkfbswaJZTGimKr8is1MXd2JjAjg2c0IFt6YP9d0vBqWH0zO 4Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuuhd9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 21:57:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB4LsLs2184382;
        Wed, 4 Dec 2019 21:57:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wnvr0vkkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Dec 2019 21:57:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB4Lv8AB003863;
        Wed, 4 Dec 2019 21:57:08 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Dec 2019 21:57:08 +0000
Date:   Wed, 4 Dec 2019 13:57:06 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, jstancek@redhat.com
Subject: Re: [PATCH] xfs: fix sub-page uptodate handling
Message-ID: <20191204215706.GT7335@magnolia>
References: <20191204172804.6589-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204172804.6589-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912040181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9461 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912040181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 04, 2019 at 06:28:04PM +0100, Christoph Hellwig wrote:
> bio complentions can race when a page spans more than one file system
> block.  Add a spinlock to synchronize marking the page uptodate.
> 
> Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
> Reported-by: Jan Stancek <jstancek@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap/buffered-io.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 512856a88106..340c15400423 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -28,6 +28,7 @@
>  struct iomap_page {
>  	atomic_t		read_count;
>  	atomic_t		write_count;
> +	spinlock_t		uptodate_lock;
>  	DECLARE_BITMAP(uptodate, PAGE_SIZE / 512);
>  };
>  
> @@ -51,6 +52,7 @@ iomap_page_create(struct inode *inode, struct page *page)
>  	iop = kmalloc(sizeof(*iop), GFP_NOFS | __GFP_NOFAIL);
>  	atomic_set(&iop->read_count, 0);
>  	atomic_set(&iop->write_count, 0);
> +	spin_lock_init(&iop->uptodate_lock);
>  	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
>  
>  	/*
> @@ -139,25 +141,38 @@ iomap_adjust_read_range(struct inode *inode, struct iomap_page *iop,
>  }
>  
>  static void
> -iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
> +iomap_iop_set_range_uptodate(struct page *page, unsigned off, unsigned len)
>  {
>  	struct iomap_page *iop = to_iomap_page(page);
>  	struct inode *inode = page->mapping->host;
>  	unsigned first = off >> inode->i_blkbits;
>  	unsigned last = (off + len - 1) >> inode->i_blkbits;
> -	unsigned int i;
>  	bool uptodate = true;
> +	unsigned long flags;
> +	unsigned int i;
>  
> -	if (iop) {
> -		for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
> -			if (i >= first && i <= last)
> -				set_bit(i, iop->uptodate);
> -			else if (!test_bit(i, iop->uptodate))
> -				uptodate = false;
> -		}
> +	spin_lock_irqsave(&iop->uptodate_lock, flags);
> +	for (i = 0; i < PAGE_SIZE / i_blocksize(inode); i++) {
> +		if (i >= first && i <= last)
> +			set_bit(i, iop->uptodate);
> +		else if (!test_bit(i, iop->uptodate))
> +			uptodate = false;
>  	}
>  
> -	if (uptodate && !PageError(page))
> +	if (uptodate)
> +		SetPageUptodate(page);
> +	spin_unlock_irqrestore(&iop->uptodate_lock, flags);
> +}
> +
> +static void
> +iomap_set_range_uptodate(struct page *page, unsigned off, unsigned len)
> +{
> +	if (PageError(page))
> +		return;
> +
> +	if (page_has_private(page))
> +		iomap_iop_set_range_uptodate(page, off, len);
> +	else
>  		SetPageUptodate(page);
>  }
>  
> -- 
> 2.20.1
> 
