Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A8AC432C2
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 10:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 840C6214DA
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 10:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409567AbfIXKqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 06:46:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44207 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409566AbfIXKqK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 06:46:10 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 99A1430860C8;
        Tue, 24 Sep 2019 10:46:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5AA1196AE;
        Tue, 24 Sep 2019 10:46:09 +0000 (UTC)
Date:   Tue, 24 Sep 2019 06:46:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 04/16] xfs: mount-api - refactor suffix_kstrtoint()
Message-ID: <20190924104608.GF13820@bfoster>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
 <156897335421.20210.13545899949665466398.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156897335421.20210.13545899949665466398.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 24 Sep 2019 10:46:10 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 20, 2019 at 05:55:54PM +0800, Ian Kent wrote:
> The mount-api doesn't have a "human unit" parse type yet so
> the options that have values like "10k" etc. still need to
> be converted by the fs.
> 
> But the value comes to the fs as a string (not a substring_t
> type) so there's a need to change the conversion function to
> take a character string instead.
> 
> After refactoring xfs_parseargs() and changing it to use
> xfs_parse_param() match_kstrtoint() will no longer be used
> and will be removed.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> ---

Seems fine since this function goes away shortly anyways:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_super.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 9c1ce3d70c08..6a16750b1314 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -160,13 +160,13 @@ static const struct fs_parameter_description xfs_fs_parameters = {
>  };
>  
>  STATIC int
> -suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
> +suffix_kstrtoint(const char *s, unsigned int base, int *res)
>  {
>  	int	last, shift_left_factor = 0, _res;
>  	char	*value;
>  	int	ret = 0;
>  
> -	value = match_strdup(s);
> +	value = kstrdup(s, GFP_KERNEL);
>  	if (!value)
>  		return -ENOMEM;
>  
> @@ -191,6 +191,20 @@ suffix_kstrtoint(const substring_t *s, unsigned int base, int *res)
>  	return ret;
>  }
>  
> +STATIC int
> +match_kstrtoint(const substring_t *s, unsigned int base, int *res)
> +{
> +	const char	*value;
> +	int ret;
> +
> +	value = match_strdup(s);
> +	if (!value)
> +		return -ENOMEM;
> +	ret = suffix_kstrtoint(value, base, res);
> +	kfree(value);
> +	return ret;
> +}
> +
>  /*
>   * This function fills in xfs_mount_t fields based on mount args.
>   * Note: the superblock has _not_ yet been read in.
> @@ -262,7 +276,7 @@ xfs_parseargs(
>  				return -EINVAL;
>  			break;
>  		case Opt_logbsize:
> -			if (suffix_kstrtoint(args, 10, &mp->m_logbsize))
> +			if (match_kstrtoint(args, 10, &mp->m_logbsize))
>  				return -EINVAL;
>  			break;
>  		case Opt_logdev:
> @@ -278,7 +292,7 @@ xfs_parseargs(
>  				return -ENOMEM;
>  			break;
>  		case Opt_allocsize:
> -			if (suffix_kstrtoint(args, 10, &iosize))
> +			if (match_kstrtoint(args, 10, &iosize))
>  				return -EINVAL;
>  			iosizelog = ffs(iosize) - 1;
>  			break;
> 
