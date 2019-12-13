Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3D9C2D0CA
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 22:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7148E22527
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 22:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfLMWZE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 17:25:04 -0500
Received: from sandeen.net ([63.231.237.45]:60036 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfLMWZE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Dec 2019 17:25:04 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9C32D2ABE;
        Fri, 13 Dec 2019 16:24:55 -0600 (CST)
Subject: Re: [PATCH] xfs_restore: Return on error when restoring file or
 symlink
To:     Frank Sorenson <sorenson@redhat.com>, linux-xfs@vger.kernel.org
References: <20191212233248.3428280-1-sorenson@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <72626168-8207-7e05-bc55-f18074e4a5dc@sandeen.net>
Date:   Fri, 13 Dec 2019 16:25:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191212233248.3428280-1-sorenson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/12/19 5:32 PM, Frank Sorenson wrote:
> If an error occurs while opening or truncating a regular
> file, or while creating a symlink, during a restore, no error
> is currently propagated back to the caller, so xfsrestore can
> return SUCCESS on a failed restore.
> 
> Make restore_reg and restore_symlink return an error code
> indicating the restore was incomplete.

Thanks for looking at this, some stuff below

> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>  restore/content.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/restore/content.c b/restore/content.c
> index c267234..5e30f08 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -7429,7 +7429,7 @@ done:
>  
>  /* called to begin a regular file. if no path given, or if just toc,
>   * don't actually write, just read. also get into that situation if
> - * cannot prepare destination. fd == -1 signifies no write. *statp
> + * cannot prepare destination. fd == -1 signifies no write. *rvp
>   * is set to indicate drive errors. returns FALSE if should abort
>   * this iteration.
>   */
> @@ -7486,12 +7486,13 @@ restore_reg(drive_t *drivep,
>  
>  	*fdp = open(path, oflags, S_IRUSR | S_IWUSR);
>  	if (*fdp < 0) {
> -		mlog(MLOG_NORMAL | MLOG_WARNING,
> +		mlog(MLOG_NORMAL | MLOG_ERROR,
>  		      _("open of %s failed: %s: discarding ino %llu\n"),
>  		      path,
>  		      strerror(errno),
>  		      bstatp->bs_ino);
> -		return BOOL_TRUE;
> +		*rvp = RV_INCOMPLETE;
> +		return BOOL_FALSE;
>  	}

I'm really not sure about original intent of the return values here and
when "this iteration should abort"

Before this patch, the function always returned BOOL_TRUE so there's
not much guidance.  Presumably all the "log something and return true"
considered these to be transient errors ...
  
>  	rval = fstat64(*fdp, &stat);
> @@ -7510,10 +7511,12 @@ restore_reg(drive_t *drivep,
>  
>  			rval = ftruncate64(*fdp, bstatp->bs_size);
>  			if (rval != 0) {
> -				mlog(MLOG_VERBOSE | MLOG_WARNING,
> +				mlog(MLOG_VERBOSE | MLOG_ERROR,
>  				      _("attempt to truncate %s failed: %s\n"),
>  				      path,
>  				      strerror(errno));
> +				*rvp = RV_INCOMPLETE;
> +				return BOOL_FALSE;
>  			}
>  		}
>  	}

so this aborts on an open or frtruncate failure, but continues on
an fstat failure or a set_file_owner failure or an XFS_IOC_FSSETXATTR
failure ... 

Was this motivated by ENOSPC, i.e. maybe the open couldn't even create
a new inode?  I could see that possibly being a hard error to stop on,
but given the prior behavior of trying to coninue as much as possible
I'm unsure about the BOOL_FALSE's here.  Setting RV_INCOMPLETE would
still make sense to me though, I think, for anything that caused the restore
to actually be incomplete.

(And this is all a little speculative as nobody really understands
this code anymore....)

-Eric

> @@ -8021,7 +8024,8 @@ restore_symlink(drive_t *drivep,
>  			      bstatp->bs_ino,
>  			      path);
>  		}
> -		return BOOL_TRUE;
> +		*rvp = RV_INCOMPLETE;
> +		return BOOL_FALSE;
>  	}
>  	scratchpath[nread] = 0;
>  	if (!tranp->t_toconlypr && path) {
> @@ -8045,7 +8049,8 @@ restore_symlink(drive_t *drivep,
>  			      bstatp->bs_ino,
>  			      path,
>  			      strerror(errno));
> -			return BOOL_TRUE;
> +			*rvp = RV_INCOMPLETE;
> +			return BOOL_FALSE;
>  		}
>  
>  		/* set the owner and group (if enabled)
> 
