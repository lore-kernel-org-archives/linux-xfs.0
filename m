Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664D6C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 22:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiBYWWe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 17:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236995AbiBYWWd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 17:22:33 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E18531F635E
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 14:22:00 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0D6D4116E2;
        Fri, 25 Feb 2022 16:21:06 -0600 (CST)
Message-ID: <ec4fef64-cc49-2f7e-069c-50d7a32610d4@sandeen.net>
Date:   Fri, 25 Feb 2022 16:21:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263818283.863810.4750810429299999067.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 16/17] mkfs: add a config file for x86_64 pmem filesystems
In-Reply-To: <164263818283.863810.4750810429299999067.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We have a handful of users who continually ping the maintainer with
> questions about why pmem and dax don't work quite the way they want
> (which is to say 2MB extents and PMD mappings) because they copy-pasted
> some garbage from Google that's wrong.  Encode the correct defaults into
> a mkfs config file and ship that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/Makefile        |    1 +
>  mkfs/dax_x86_64.conf |   19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
>  create mode 100644 mkfs/dax_x86_64.conf
> 
> 
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 0aaf9d06..55d9362f 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -10,6 +10,7 @@ LTCOMMAND = mkfs.xfs
>  HFILES =
>  CFILES = proto.c xfs_mkfs.c
>  CFGFILES = \
> +	dax_x86_64.conf \
>  	lts_4.19.conf \
>  	lts_5.4.conf \
>  	lts_5.10.conf \
> diff --git a/mkfs/dax_x86_64.conf b/mkfs/dax_x86_64.conf
> new file mode 100644
> index 00000000..bc3f3c9a
> --- /dev/null
> +++ b/mkfs/dax_x86_64.conf
> @@ -0,0 +1,19 @@
> +# mkfs.xfs configuration file for persistent memory on x86_64.
> +# Block size must match page size (4K) and we require V5 for the DAX inode
> +# flag.  Set extent size hints and stripe units to encourage the filesystem to
> +# allocate PMD sized (2MB) blocks.
> +
> +[block]
> +size=4096
> +
> +[metadata]
> +crc=1
> +
> +[data]
> +sunit=4096
> +swidth=4096

How would you feel about:

su=2m
sw=1

instead, because I think that explicit units are far more obvious than
"4096 <handwave> 512-byte units" ?

> +extszinherit=512

... though I guess this can only be specified in fsblocks, LOLZ :(

> +daxinherit=1
> +
> +[realtime]
> +extsize=2097152

Pretty weird to set this if you don't have a realtime device but I guess
it works.

-Eric
