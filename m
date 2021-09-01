Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C8DC4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 21:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E13C610C7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 21:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344242AbhIAVaf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 17:30:35 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:46321 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344792AbhIAVae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 17:30:34 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 627EC80EA48;
        Thu,  2 Sep 2021 07:29:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLXnS-007bAG-US; Thu, 02 Sep 2021 07:29:26 +1000
Date:   Thu, 2 Sep 2021 07:29:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/5] new: only allow documented test group names
Message-ID: <20210901212926.GB1756565@dread.disaster.area>
References: <163045514980.771564.6282165259140399788.stgit@magnolia>
 <163045517721.771564.12357505876401888990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045517721.771564.12357505876401888990.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=7mY_CRzyQrjIPYwugv4A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:12:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we require all group names to be listed in doc/group-names.txt,
> we can use that (instead of running mkgroupfile) to check if the group
> name(s) supplied by the user actually exist.  This has the secondary
> effect of being a second nudge towards keeping the description of groups
> up to date.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  new |   24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/new b/new
> index 2097a883..44777bd6 100755
> --- a/new
> +++ b/new
> @@ -83,6 +83,14 @@ then
>      exit 1
>  fi
>  
> +# Extract group names from the documentation.
> +group_names() {
> +	grep '^[[:lower:][:digit:]_]' doc/group-names.txt | awk '
> +{if ($1 != "" && $1 != "Group" && $2 != "Name:" && $1 != "all")
> +	printf("%s\n", $1);
> +}'
> +}

Took me a while to realise this was running an awk script for output
slection but using grep for regex based line selection. Awk can do
both of these things just fine, and the result is much more
readable:

group_names() {
	awk '/^[[:lower:][:digit:]_]/ {
		if ($1 != "Group" && $2 != "Name:" && $1 != "all")
			printf("%s\n", $1);
	}' doc/group-names.txt
}


$ awk '/^[[:lower:][:digit:]_]/ { if ($1 != "Group" && $2 != "Name:" && $1 != "all") printf("%s\n", $1); }' t.t
auto
quick
deprecated
acl
admin
aio
atime
....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
