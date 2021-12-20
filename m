Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2FAC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Dec 2021 16:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhLTQBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Dec 2021 11:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhLTQBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Dec 2021 11:01:16 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664CAC06173E
        for <linux-xfs@vger.kernel.org>; Mon, 20 Dec 2021 08:01:16 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id de30so9826845qkb.0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Dec 2021 08:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rMUCk2F5lTLSE10R0WTY95GfRQYTIRkYpBk8h2IQc2M=;
        b=XLlxxKc9DM0UFnnTwGlZ4ce0kpVAaGdOS9gG/LzBxLJLyXnKvNSQuFtCgjMvbVOjwC
         HNCdQRdCBMLKCE0bSnNRuzNPPd18qkUOGapg/vl0B/RIwz62y9Mvh8iFTZKfvCro8M3b
         Jucyf8SFuftpPKX3Jx/NgUw0cICtKGp41+CyIF9Gm/vm2zv2zrMkbt1bnX8PcJOs/Vee
         wJSVDrJL0fdk9jn+swcWK/3GAl4npfjz6xwi2mV75WYXqKboInY9Yhe9sMeuyYilawf6
         LepNKnC++Xu5tl0Tl+zBImyZbDAo6odnBgCK43gATYm7fKkyo9898Ywkh/VvRimFMhGb
         XDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rMUCk2F5lTLSE10R0WTY95GfRQYTIRkYpBk8h2IQc2M=;
        b=bGHg366MoenypeRRVkE0ytp7ieBeab+QBlO7Xu9UPHgbAdUHSSBpXJaZAkNaxYj8wb
         MQXp2ZWziFoppBADf64qMDQWagYVCPZN5305BeMg3mPHGb1x2Wo77YgVjplUaTZy/4bj
         e3iWgUXsDBXyl8groL/igEVTuwsTgoALIyn3gIDHLzjxGIrCmbszmq9VQapOEWglE9Uu
         kjWaohg6G7zQQs/CpgV4wIHbvtTdJua2X8vwheOiRK0Y1Nfg4TXpD1aIp3EWaTEAvyjF
         //csVei2gxL8drvXhPxfOPUhwb6oF8TSr6nRQYSTyy0YnhHyddBMKC5QSiUNxOkOFD+5
         FBew==
X-Gm-Message-State: AOAM53286lQ9ZTHNLCxhwykqQt7LUTux/sI19uVR3x2N4yo5bKNL7v4S
        el+VDs7y2P3mS2qMlaEW9w==
X-Google-Smtp-Source: ABdhPJwkMkHhjCu3M29dAqerEfaSjkl+Cb77JNeNJ6ZvhfgaBE5Q03puFyM6pmQ3tKd6h2MF2mbpMw==
X-Received: by 2002:a37:2750:: with SMTP id n77mr9982193qkn.490.1640016075525;
        Mon, 20 Dec 2021 08:01:15 -0800 (PST)
Received: from gabell (209-6-122-159.s2973.c3-0.arl-cbr1.sbo-arl.ma.cable.rcncustomer.com. [209.6.122.159])
        by smtp.gmail.com with ESMTPSA id q30sm11316128qkj.3.2021.12.20.08.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 08:01:15 -0800 (PST)
Date:   Mon, 20 Dec 2021 11:01:13 -0500
From:   Masayoshi Mizuma <msys.mizuma@gmail.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v3 2/2] xfsdump: intercept bind mount targets
Message-ID: <YcCoyZcKnOTz1Waa@gabell>
References: <20201103023315.786103-2-hsiangkao@redhat.com>
 <20201103153328.889676-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103153328.889676-1-hsiangkao@redhat.com>
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

Hi,

This patch works for the filesystem which the inode number of the
root directory is different from the root inode number of the
filesystem without the bind mount.

Please feel free to add:

  Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

The log with the both of the patch:

  # xfs_io -i -c 'bulkstat_single root' /test/MNT1 | awk '/bs_ino = /{print $3}'
  128
  # stat --printf="%i\n" /test/MNT1
  1024
  # xfsdump -L session -M test -f /tmp/2176346.dump /test/MNT1
  xfsdump: using file dump (drive_simple) strategy
  xfsdump: version 3.1.9 (dump format 3.0) - type ^C for status and control
  xfsdump: level 0 dump of localhost:/test/MNT1
  xfsdump: dump date: Mon Dec 20 10:38:27 2021
  xfsdump: session id: edec5c99-062b-41b8-a0c2-6c3c87d7ce75
  xfsdump: session label: "session"
  xfsdump: ino map phase 1: constructing initial dump list
  xfsdump: ino map phase 2: skipping (no pruning necessary)
  xfsdump: ino map phase 3: skipping (only one dump stream)
  xfsdump: ino map construction complete
  xfsdump: estimated dump size: 532800 bytes
  xfsdump: /var/lib/xfsdump/inventory created
  xfsdump: creating dump session media file 0 (media 0, file 0)
  xfsdump: dumping ino map
  xfsdump: dumping directories
  xfsdump: dumping non-directory files
  xfsdump: ending media file
  xfsdump: media file size 1061824 bytes
  xfsdump: dump size (non-dir files) : 0 bytes
  xfsdump: dump complete: 3 seconds elapsed
  xfsdump: Dump Summary:
  xfsdump:   stream 0 /tmp/2176346.dump OK (success)
  xfsdump: Dump Status: SUCCESS

Thanks!
Masa

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
