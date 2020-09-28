Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D0BC2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 21:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2440E206FC
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 21:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgI1VKn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 17:10:43 -0400
Received: from sandeen.net ([63.231.237.45]:40826 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgI1VKn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Sep 2020 17:10:43 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1770B616653;
        Mon, 28 Sep 2020 16:09:59 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160013466518.2932378.9536364695832878473.stgit@magnolia>
 <160013468391.2932378.13825727040727340226.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/4] mkfs: don't allow creation of realtime files from a
 proto file
Message-ID: <0c291ac5-bc70-facf-53b5-42b6edb26eca@sandeen.net>
Date:   Mon, 28 Sep 2020 16:10:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <160013468391.2932378.13825727040727340226.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/14/20 8:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If someone runs mkfs with rtinherit=1, a realtime volume configured, and
> a protofile that creates a regular file in the filesystem, mkfs will
> error out with "Function not implemented" because userspace doesn't know
> how to allocate extents from the rt bitmap.  Catch this specific case
> and hand back a somewhat nicer explanation of what happened.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

hch has a point about "maybe we should fix it" but it seems like it's
not somewhere we really need to spend development effort right now.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/proto.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 9db8fe2d6447..20a7cc3bb5d5 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -244,6 +244,12 @@ newfile(
>  		nb = XFS_B_TO_FSB(mp, len);
>  		nmap = 1;
>  		error = -libxfs_bmapi_write(tp, ip, 0, nb, 0, nb, &map, &nmap);
> +		if (error == ENOSYS && XFS_IS_REALTIME_INODE(ip)) {
> +			fprintf(stderr,
> +	_("%s: creating realtime files from proto file not supported.\n"),
> +					progname);
> +			exit(1);
> +		}
>  		if (error) {
>  			fail(_("error allocating space for a file"), error);
>  		}
> 
