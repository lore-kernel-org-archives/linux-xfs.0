Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E65C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 15:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF86260FF2
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 15:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhI0PIx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 11:08:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235057AbhI0PIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 11:08:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632755234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s/FvFYdu4aJ674PkIJoIx3ht1jScIVSeY6fbvyITKSk=;
        b=f8dWPVMU24kf5aw6JbUeUnGhxmbuxH0k4lXvICt8WYeTB1J6P503liP2lQocusm1rXm9Do
        xc5+1IOmCM/l4ObR7aYLw+HuYpu59p39ZCOIzq/OReA7zemGXA4bof0qa4SB3n1WP9SoAs
        xAgRhL8JUvH1o2QsB7BPKygO0NkMF48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-cNJ9ey1-NS-ydfmYzSC7Sw-1; Mon, 27 Sep 2021 11:07:10 -0400
X-MC-Unique: cNJ9ey1-NS-ydfmYzSC7Sw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7867381426E;
        Mon, 27 Sep 2021 15:07:09 +0000 (UTC)
Received: from redhat.com (unknown [10.22.17.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8830B604CC;
        Mon, 27 Sep 2021 15:07:04 +0000 (UTC)
Date:   Mon, 27 Sep 2021 10:07:02 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 2/2] xfsdump: intercept bind mount targets
Message-ID: <20210927150702.jbi57mjiqs7t74bm@redhat.com>
References: <20201103023315.786103-2-hsiangkao@redhat.com>
 <20201103153328.889676-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103153328.889676-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 11:33:28PM +0800, Gao Xiang wrote:
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

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> changes since v2 (Eric):
>  - error out the case where the directory cannot be read;
>  - In any case, stop as soon as we have found "..";
>  - update the mountpoint error message and use i18n instead;
> 
>  dump/content.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/dump/content.c b/dump/content.c
> index c11d9b4..c248e74 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -511,6 +511,55 @@ static bool_t create_inv_session(
>  		ix_t subtreecnt,
>  		size_t strmix);
>  
> +static bool_t
> +check_rootdir(int fd,
> +	      xfs_ino_t ino)
> +{
> +	struct dirent	*gdp;
> +	size_t		gdsz;
> +	bool_t		found = BOOL_FALSE;
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
> +			break;
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
> +			if (!strcmp(p->d_name, "..")) {
> +				if (p->d_ino == ino)
> +					found = BOOL_TRUE;
> +				break;
> +			}
> +		}
> +	}
> +	free(gdp);
> +	return found;
> +}
> +
>  bool_t
>  content_init(int argc,
>  	      char *argv[],
> @@ -1393,6 +1442,14 @@ baseuuidbypass:
>  			      mntpnt);
>  			return BOOL_FALSE;
>  		}
> +
> +		if (!check_rootdir(sc_fsfd, rootstat.st_ino)) {
> +			mlog(MLOG_ERROR,
> +_("%s is not the root of the filesystem (bind mount?) - use primary mountpoint\n"),
> +			     mntpnt);
> +			return BOOL_FALSE;
> +		}
> +
>  		sc_rootxfsstatp =
>  			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
>  		assert(sc_rootxfsstatp);
> -- 
> 2.18.1
> 

