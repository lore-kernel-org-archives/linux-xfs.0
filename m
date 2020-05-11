Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9941EC54E8D
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 15:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6486220675
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 15:32:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jmXxkLdl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgEKPcy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 11:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728084AbgEKPcx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 11:32:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC888C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 08:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mLK+OZ6e080WNCIcNvCOeUu88+0k+26Kgq1GgY1/uFI=; b=jmXxkLdlYYHAMD9SIrI7G1fn4g
        E0zSr7ORyf3uqJXVkpAA9HIoqEYDCPKgCYPD/7UO57kzhXKOaYnkUuCQE5sydBP00RGeQXWP+ZqIT
        TA1pOEzTmZuirtO4oUnCeIT5HHJf20K0f17W1nBepFDnbp9eEnTPWMnYFtWeHS1vWym90Dd+LG4GQ
        Nk88i85N9g1kcUp9XNv8yoT685T4ymoZKTN+/OeDJK4eN0KHpi/PcDyU8pfCl0nBwuVQxxd8GFwOG
        1DDY9JHMqUvbslXrq6A6V+aLwZn+f+d48iVsEZX87ymAgpIK6nbqb/QmkcRpsRd+Vez2VzIEpQwG3
        9ViUv2Ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYAQD-0006l7-8n; Mon, 11 May 2020 15:32:49 +0000
Date:   Mon, 11 May 2020 08:32:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_quota: refactor code to generate id from name
Message-ID: <20200511153249.GA11320@infradead.org>
References: <8b4b7edb-94b2-3bb1-9ede-73674db82330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b4b7edb-94b2-3bb1-9ede-73674db82330@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 12:18:42PM -0500, Eric Sandeen wrote:
> There's boilerplate for setting limits and warnings, where we have
> a case statement for each of the 3 quota types, and from there call
> 3 different functions to configure each of the 3 types, each of which
> calls its own version of id to string function... 
> 
> Refactor this so that the main function can call a generic id to string
> conversion routine, and then call a common action.  This save a lot of
> LOC.
> 
> I was looking at allowing xfs to bump out individual grace periods like
> setquota can do, and this refactoring allows us to add new actions like
> that without copyingall the boilerplate again.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
>  edit.c |  196 ++++++++++++++++-----------------------------------------
>  1 file changed, 51 insertions(+), 145 deletions(-)
> 
> diff --git a/quota/edit.c b/quota/edit.c
> index f9938b8a..70c0969f 100644
> --- a/quota/edit.c
> +++ b/quota/edit.c
> @@ -101,6 +101,42 @@ warn_help(void)
>  "\n"));
>  }
>  
> +static uint32_t
> +id_from_string(
> +	char	*name,
> +	int	type)
> +{
> +	uint32_t	id = -1;
> +
> +	switch (type) {
> +	case XFS_USER_QUOTA:
> +		id = uid_from_string(name);
> +		if (id == -1)
> +			fprintf(stderr, _("%s: invalid user name: %s\n"),
> +				progname, name);
> +		break;
> +	case XFS_GROUP_QUOTA:
> +		id = gid_from_string(name);
> +		if (id == -1)
> +			fprintf(stderr, _("%s: invalid group name: %s\n"),
> +				progname, name);
> +		break;
> +	case XFS_PROJ_QUOTA:
> +		id = prid_from_string(name);
> +		if (id == -1)
> +			fprintf(stderr, _("%s: invalid project name: %s\n"),
> +				progname, name);
> +		break;
> +	default:
> +		ASSERT(0);
> +		break;
> +	}
> +
> +	if (id == -1)
> +		exitcode = 1;
> +	return id;

What about de-duplicating the error printk as well?

static uint32_t
id_from_string(
	char		*name,
	int		type)
{
	uint32_t	id = -1;
	const char	*type = "invalid";

	switch (type) {
	case XFS_USER_QUOTA:
		type = "user";
		id = uid_from_string(name);
		break;
	case XFS_GROUP_QUOTA:
		type = "group";
		id = gid_from_string(name);
		break;
	case XFS_PROJ_QUOTA:
		type = "project";
		id = prid_from_string(name);
		break;
	default:
		ASSERT(0);
		break;
	}

	if (id == -1) {
		fprintf(stderr, _("%s: invalid %s name: %s\n"),
			type, progname, name);
		exitcode = 1;
	}
	return id;
}
