Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EF3C48BE5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 23:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCA9613F5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 23:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFKXs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 19:48:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhFKXs1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 19:48:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81C2E613A9;
        Fri, 11 Jun 2021 23:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623455188;
        bh=8CBNt9LwbJmGnSZR0A2GXGmNALEyK+rJWFmJKpdo5ac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AkPuYJzkpuBkWdVu1yPwD53SH3tduKpzYMq+XHE+lFlSj0dyL9V2ZExM4a017Enlz
         KdBYwM2005s/HVW+GpwpecpOeHwKnwLmNini1HvGw9M9aMLbhLFFX4ta2AEcqh1bfg
         H1gCKO5wmkEYiXIzRv/ii4JPlDPTtco1AP5WgPMNqpGkzTPQbR8tBdm2fIwqPVQVPj
         60rdDrkTvMGUCcIJi8LZvRikU3HYOQswciTIgZEUuCw5AAGpXcYj2vkrG1supmZg6I
         ZHzAUAM99nRh47OQRHtHuHCVhKG4APlhtHcjKEgfN5wGR0u87OPQNLimdSuQJIfxRm
         Rt6uNWX5KEwVQ==
Date:   Fri, 11 Jun 2021 16:46:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 08/13] fstests: convert nextid to use automatic group
 generation
Message-ID: <YMP103PrnZC2QaE3@gmail.com>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317280590.653489.10114638028601363399.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162317280590.653489.10114638028601363399.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 08, 2021 at 10:20:05AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the nextid script to use the automatic group file generation to
> figure out the next available test id.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tools/nextid |    1 -
>  tools/nextid |   39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 1 deletion(-)
>  delete mode 120000 tools/nextid
>  create mode 100755 tools/nextid
> 
> 
> diff --git a/tools/nextid b/tools/nextid
> deleted file mode 120000
> index 5c31d602..00000000
> --- a/tools/nextid
> +++ /dev/null
> @@ -1 +0,0 @@
> -sort-group
> \ No newline at end of file
> diff --git a/tools/nextid b/tools/nextid
> new file mode 100755
> index 00000000..a65348e8
> --- /dev/null
> +++ b/tools/nextid
> @@ -0,0 +1,39 @@
> +#!/bin/bash
> +
> +# Compute the next available test id in a given test directory.
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ] || [ -n "$2" ] || [ ! -d "tests/$1/" ]; then
> +	echo "Usage: $0 test_dir"
> +	exit 1
> +fi

[ $# != 1 ] would be simpler than [ -z "$1" ] || [ -n "$2" ].

> +line=0

The 'line' variable isn't needed.

> +i=0
> +eof=1
> +
> +while read found other_junk;
> +do
> +	line=$((line+1))
> +	if [ -z "$found" ] || [ "$found" == "#" ]; then
> +		continue
> +	elif ! echo "$found" | grep -q "^$VALID_TEST_NAME$"; then
> +		# this one is for tests not named by a number
> +		continue
> +	fi
> +	i=$((i+1))
> +	id=`printf "%03d" $i`
> +	if [ "$id" != "$found" ]; then
> +		eof=0
> +		break
> +	fi
> +done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | tr - ' ')

The first token matching $VALID_TEST_NAME already implies that it is non-empty
and not "#".  Also, this could be handled by piping to grep:

while read found other_junk; do
	i=$((i+1))
	id=`printf "%03d" $i`
	if [ "$id" != "$found" ]; then
		eof=0
		break
	fi
done < <(cd "tests/$1/" ; ../../tools/mkgroupfile | \
         grep "^$VALID_TEST_NAME\>" | tr - ' ')

- Eric
