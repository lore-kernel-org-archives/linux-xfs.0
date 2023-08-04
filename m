Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067BDC04A6A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 15:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjHDPsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjHDPsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 11:48:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF552D71;
        Fri,  4 Aug 2023 08:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A42E6208C;
        Fri,  4 Aug 2023 15:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90646C433C7;
        Fri,  4 Aug 2023 15:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691164078;
        bh=vmYSL62gE86wbB6w4+ThrjkJq99WbHmmmtt+qKXP5ig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nr4GSOlggk2Oz9nBXHXo+h46NcFd/XRt8m2tXXwlhG5YlAeXfWOpPN9mGlSSFRzJj
         5efF2T8JV8teWdU27xrpkgjTmHIeoiravkzcJqMyoYcU4/Mt5EsDUday9wN/HyS7J1
         nxRc88/Z1+fy8xBmRuO6rupCyU93HGW+UrMxS1wWc1Q8lIHT+rTVKGpM5dZnXvbMd2
         3AN8uwkWvchUdYh7MMWpMA1juA6uypry5mxoyjKWL0wPNsuzOwJc3b7p1SSUOQNRIA
         J7PzhksTmRFAG0xsElJHRDCDmUC/o7NHD347m6XsNGDZeRWAOjkdmEAShUIQfuWj5H
         rbpKgSq4CRptQ==
Date:   Fri, 4 Aug 2023 08:47:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     amir73il@gmail.com, dchinner@redhat.com, yangx.jy@fujitsu.com,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] Fix xfs/179 for 5.10 stable
Message-ID: <20230804154757.GI11352@frogsfrogsfrogs>
References: <20230803093652.7119-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803093652.7119-1-guoqing.jiang@linux.dev>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 03, 2023 at 05:36:50PM +0800, Guoqing Jiang wrote:
> Hi,
> 
> With the two patches applied, xfs/179 can pass in 5.10.188. Otherwise I got
> 
> [root@localhost xfstests]# ./check xfs/179
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 localhost 5.10.188-default #14 SMP Thu Aug 3 15:23:19 CST 2023
> MKFS_OPTIONS  -- -f /dev/loop1
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/scratch
> 
> xfs/179 1s ... [failed, exit status 1]- output mismatch (see /root/xfstests/results//xfs/179.out.bad)
>     --- tests/xfs/179.out	2023-07-13 16:12:27.000000000 +0800
>     +++ /root/xfstests/results//xfs/179.out.bad	2023-08-03 16:55:38.173787911 +0800
>     @@ -8,3 +8,5 @@
>      Check scratch fs
>      Remove reflinked files
>      Check scratch fs
>     +xfs_repair fails
>     +(see /root/xfstests/results//xfs/179.full for details)
>     ...
>     (Run 'diff -u /root/xfstests/tests/xfs/179.out /root/xfstests/results//xfs/179.out.bad'  to see the entire diff)
> 
> HINT: You _MAY_ be missing kernel fix:
>       b25d1984aa88 xfs: estimate post-merge refcounts correctly
> 
> Ran: xfs/179
> Failures: xfs/179
> Failed 1 of 1 tests
> 
> Please review if they are approriate for 5.10 stable.

Seems fine to me, but ... there is no maintainer for 5.10; is your
employer willing to support this LTS kernel?

--D

> Thanks,
> Guoqing
> 
> Darrick J. Wong (2):
>   xfs: hoist refcount record merge predicates
>   xfs: estimate post-merge refcounts correctly
> 
>  fs/xfs/libxfs/xfs_refcount.c | 146 +++++++++++++++++++++++++++++++----
>  1 file changed, 130 insertions(+), 16 deletions(-)
> 
> -- 
> 2.33.0
> 
