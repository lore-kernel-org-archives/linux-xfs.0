Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466D6C388F9
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A180206DB
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgKCPEB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:04:01 -0500
Received: from sandeen.net ([63.231.237.45]:51722 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbgKCPDu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Nov 2020 10:03:50 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1825E2420;
        Tue,  3 Nov 2020 09:03:46 -0600 (CST)
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20201103023315.786103-1-hsiangkao@redhat.com>
 <20201103023315.786103-2-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 2/2] xfsdump: intercept bind mount targets
Message-ID: <5ac048c3-7db6-4487-78ae-86ee9851c5c8@sandeen.net>
Date:   Tue, 3 Nov 2020 09:03:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103023315.786103-2-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/2/20 8:33 PM, Gao Xiang wrote:
> It's a bit strange pointing at some non-root bind mount target and
> then actually dumping from the actual root dir instead.
> 
> Therefore, instead of searching for the root dir of the filesystem,
> just intercept all bind mount targets by checking whose ino # of
> ".." is itself with getdents.
> 
> Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
> Cc: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since v1:
>  just intercept bind mount targets suggested by Eric on IRC instead,
>  and no need to use XFS_BULK_IREQ_SPECIAL_ROOT since the xfs header
>  files and the kernel on my laptop don't support it, plus
>  xfsdump/xfsrestore are not part of xfsprogs, so a bit hard to
>  sync and make full use of that elegantly.

Thank you for doing this - it seems to be the least intrusive method to
finally fix this problem, I really appreciate you taking the work.

> 
>  dump/content.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
> 
> diff --git a/dump/content.c b/dump/content.c
> index c11d9b4..7a55b92 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -511,6 +511,61 @@ static bool_t create_inv_session(
>  		ix_t subtreecnt,
>  		size_t strmix);
>  
> +static bool_t
> +check_rootdir(int fd,
> +	      xfs_ino_t ino)
> +{
> +	struct dirent	*gdp;
> +	size_t		gdsz;
> +
> +	gdsz = sizeof(struct dirent) + NAME_MAX + 1;
> +	if (gdsz < GETDENTSBUF_SZ_MIN)
> +		gdsz = GETDENTSBUF_SZ_MIN;
> +	gdp = (struct dirent *)calloc(1, gdsz);
> +	assert(gdp);
> +
> +	while (1) {
> +		struct dirent *p;
> +		int nread;
> +
> +		nread = getdents_wrap(fd, (char *)gdp, gdsz);
> +		/*
> +		 * negative count indicates something very bad happened;
> +		 * try to gracefully end this dir.
> +		 */
> +		if (nread < 0) {
> +			mlog(MLOG_NORMAL | MLOG_WARNING,
> +_("unable to read dirents for directory ino %llu: %s\n"),
> +			      ino, strerror(errno));
> +			/* !!! curtis looked at this, and pointed out that

Nobody knows who curtis is, I think we can drop this comment now ;)
If we can't read the directory I think it's fine to simply error out here.

> +			 * we could take some recovery action here. if the
> +			 * errno is appropriate, lseek64 to the value of
> +			 * doff field of the last dirent successfully
> +			 * obtained, and contiue the loop.
> +			 */
> +			nread = 0; /* pretend we are done */
> +		}
> +
> +		/* no more directory entries: break; */
> +		if (!nread)
> +			break;
> +
> +		for (p = gdp; nread > 0;
> +		     nread -= (int)p->d_reclen,
> +		     assert(nread >= 0),
> +		     p = (struct dirent *)((char *)p + p->d_reclen)) {
> +			if (!strcmp(p->d_name, "..") && p->d_ino == ino) {
> +				mlog(MLOG_DEBUG, "FOUND: name %s d_ino %llu\n",
> +				     p->d_name, ino);
> +				free(gdp);
> +				return BOOL_TRUE;
> +			}

I think we can stop as soon as we have found ".." yes?  No need to continue
iterating the directory, either ".." is what we wanted, or it's not, but either
way we are done when we have checked it.  On the off chance that we have
a very large root dir, stopping early might be good.

> +		}
> +	}
> +	free(gdp);
> +	return BOOL_FALSE;
> +}
> +
>  bool_t
>  content_init(int argc,
>  	      char *argv[],
> @@ -1393,6 +1448,13 @@ baseuuidbypass:
>  			      mntpnt);
>  			return BOOL_FALSE;
>  		}
> +
> +		if (!check_rootdir(sc_fsfd, rootstat.st_ino)) {
> +			mlog(MLOG_ERROR,
> +"oops, seems to be a bind mount, please use the actual mountpoint instead\n");

Could there be any other reason for this failure?  Maybe something like:

			mlog(MLOG_ERROR,
_("%s is not the root of the filesystem (bind mount?) - use primary mountpoint\n"),
				mntpnt);

or similar?

in any case I think it needs the i18n _("...") treatment.

Thanks!

-Eric

> +			return BOOL_FALSE;
> +		}
> +
>  		sc_rootxfsstatp =
>  			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
>  		assert(sc_rootxfsstatp);
> 
