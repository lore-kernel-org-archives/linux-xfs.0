Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33395 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdLDS1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Dec 2017 13:27:46 -0500
Date: Mon, 4 Dec 2017 10:27:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] treewide: remove duplicate includes
Message-ID: <20171204182731.GA4903@magnolia>
References: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512337779-16842-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pravin Shedge <pravin.shedge4linux@gmail.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net, sstabellini@kernel.org, x86@kernel.org, mchehab@kernel.org, linux-xfs@vger.kernel.org, mcgrof@kernel.org, ast@kernel.org, shuah@kernel.org, namhyung@kernel.org, mhiramat@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, devel@driverdev.osuosl.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Dec 04, 2017 at 03:19:39AM +0530, Pravin Shedge wrote:
> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Unit Testing:
> 
> - build successful
> - LTP testsuite passes.
> - checkpatch.pl passes
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

<supersnip>

> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 9c42c4e..ab3aef2 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c

These look reasonable, but please send me (and linux-xfs) the three
xfs changes separately so that I can add them to the xfs tree.

(Also, thank you for cc'ing the xfs list for this treewide change...)

--D
