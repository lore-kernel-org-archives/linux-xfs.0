Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C675C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 01:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F01D364EDB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 01:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhBTBAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 20:00:51 -0500
Received: from sandeen.net ([63.231.237.45]:55786 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBTBAv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Feb 2021 20:00:51 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 722B9626292;
        Fri, 19 Feb 2021 19:00:00 -0600 (CST)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
 <161370469573.2389661.2370498929966302970.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/4] xfs_repair: add post-phase error injection points
Message-ID: <0af3d64b-c98c-f785-f9ca-59bcb8dbb2ff@sandeen.net>
Date:   Fri, 19 Feb 2021 19:00:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161370469573.2389661.2370498929966302970.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/18/21 9:18 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create an error injection point so that we can simulate repair failing
> after a certain phase.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Well this is refreshingly simple ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/globals.c    |    3 +++
>  repair/globals.h    |    3 +++
>  repair/xfs_repair.c |    8 ++++++++
>  3 files changed, 14 insertions(+)
> 
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index 110d98b6..537d068b 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -117,3 +117,6 @@ uint64_t	*prog_rpt_done;
>  
>  int		ag_stride;
>  int		thread_count;
> +
> +/* If nonzero, simulate failure after this phase. */
> +int		fail_after_phase;
> diff --git a/repair/globals.h b/repair/globals.h
> index 1d397b35..a9287320 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -162,4 +162,7 @@ extern uint64_t		*prog_rpt_done;
>  extern int		ag_stride;
>  extern int		thread_count;
>  
> +/* If nonzero, simulate failure after this phase. */
> +extern int		fail_after_phase;
> +
>  #endif /* _XFS_REPAIR_GLOBAL_H */
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 891b3b23..33062170 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -362,6 +362,10 @@ process_args(int argc, char **argv)
>  
>  	if (report_corrected && no_modify)
>  		usage();
> +
> +	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
> +	if (p)
> +		fail_after_phase = (int)strtol(p, NULL, 0);
>  }
>  
>  void __attribute__((noreturn))
> @@ -851,6 +855,10 @@ static inline void
>  phase_end(int phase)
>  {
>  	timestamp(PHASE_END, phase, NULL);
> +
> +	/* Fail if someone injected an post-phase error. */
> +	if (fail_after_phase && phase == fail_after_phase)
> +		platform_crash();
>  }
>  
>  int
> 
