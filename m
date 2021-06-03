Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF0CC47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CA2613DE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 20:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFCUbk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 16:31:40 -0400
Received: from sandeen.net ([63.231.237.45]:35052 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCUbk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Jun 2021 16:31:40 -0400
Received: from liberator.local (h15.159.16.98.static.ip.windstream.net [98.16.159.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 16C8B4872FA;
        Thu,  3 Jun 2021 15:29:53 -0500 (CDT)
Subject: Re: [PATCH v2 1/2] xfsdump: Revert "xfsdump: handle bind mount
 targets"
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20201103023315.786103-1-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <04428916-1fdc-0958-2ead-8d10fca7f82c@sandeen.net>
Date:   Thu, 3 Jun 2021 15:29:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20201103023315.786103-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/2/20 8:33 PM, Gao Xiang wrote:
> Bind mount mntpnts will be forbided in the next commits
> instead since it's not the real rootdir.
> 
> This cannot be reverted cleanly due to several cleanup
> patches, but the logic is reverted equivalently.
> 
> This reverts commit 25195ebf107dc81b1b7cea1476764950e1d6cc9d.
> 
> Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Sorry this is so ridiculously late:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  dump/content.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/dump/content.c b/dump/content.c
> index 30232d4..c11d9b4 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -1382,17 +1382,10 @@ baseuuidbypass:
>  	}
>  
>  	/* figure out the ino for the root directory of the fs
> -	 * and get its struct xfs_bstat for inomap_build().  This could
> -	 * be a bind mount; don't ask for the mount point inode,
> -	 * find the actual lowest inode number in the filesystem.
> +	 * and get its xfs_bstat_t for inomap_build()
>  	 */
>  	{
>  		stat64_t rootstat;
> -		xfs_ino_t lastino = 0;
> -		int ocount = 0;
> -		struct xfs_fsop_bulkreq bulkreq;
> -
> -		/* Get the inode of the mount point */
>  		rval = fstat64(sc_fsfd, &rootstat);
>  		if (rval) {
>  			mlog(MLOG_NORMAL, _(
> @@ -1404,21 +1397,11 @@ baseuuidbypass:
>  			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
>  		assert(sc_rootxfsstatp);
>  
> -		/* Get the first valid (i.e. root) inode in this fs */
> -		bulkreq.lastip = (__u64 *)&lastino;
> -		bulkreq.icount = 1;
> -		bulkreq.ubuffer = sc_rootxfsstatp;
> -		bulkreq.ocount = &ocount;
> -		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
> +		if (bigstat_one(sc_fsfd, rootstat.st_ino, sc_rootxfsstatp) < 0) {
>  			mlog(MLOG_ERROR,
>  			      _("failed to get bulkstat information for root inode\n"));
>  			return BOOL_FALSE;
>  		}
> -
> -		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
> -			mlog (MLOG_NORMAL | MLOG_NOTE,
> -			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
> -			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
>  	}
>  
>  	/* alloc a file system handle, to be used with the jdm_open()
> 
