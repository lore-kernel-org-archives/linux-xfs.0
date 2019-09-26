Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F476C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 04:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C05B21E6F
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 04:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbfIZEOa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 00:14:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49166 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfIZEOa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Sep 2019 00:14:30 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDLAh-0005BR-JL; Thu, 26 Sep 2019 04:14:28 +0000
Date:   Thu, 26 Sep 2019 05:14:27 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [REPOST PATCH v3 06/16] xfs: mount-api - make xfs_parse_param()
 take context .parse_param() args
Message-ID: <20190926041427.GT26530@ZenIV.linux.org.uk>
References: <156933112949.20933.12761540130806431294.stgit@fedora-28>
 <156933135322.20933.2166438700224340142.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156933135322.20933.2166438700224340142.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 24, 2019 at 09:22:33PM +0800, Ian Kent wrote:

> +	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
> +	if (opt < 0) {
> +		/*
> +		 * If fs_parse() returns -ENOPARAM and the parameter
> +		 * is "source" the VFS needs to handle this option
> +		 * in order to boot otherwise use the default case
> +		 * below to handle invalid options.
> +		 */
> +		if (opt != -ENOPARAM ||
> +		    strcmp(param->key, "source") == 0)
> +			return opt;

Just return opt; here and be done with that.  The comment is bloody
misleading - for one thing, "in order to boot" is really "in order to
mount anything", and the only reason for the kludge is that the
default for "source" (in vfs_parse_fs_param(), triggered in case
when -ENOPARAM had been returned by ->parse_param()) won't get triggered
if you insist on reporting _all_ unknown options on your own.

> +	}

>  	default:
> -		xfs_warn(mp, "unknown mount option [%s].", p);
> +		xfs_warn(mp, "unknown mount option [%s].", param->key);
>  		return -EINVAL;

... here, instead of letting the same vfs_parse_fs_param() handle
the warning.

Or you could add Opt_source for handling that, with equivalent of that
fallback (namely,
                if (param->type != fs_value_is_string)
                        return invalf(fc, "VFS: Non-string source");
                if (fc->source)
                        return invalf(fc, "VFS: Multiple sources");
                fc->source = param->string;
                param->string = NULL;
                return 0;
) done in your ->parse_param().
