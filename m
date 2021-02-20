Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAD2C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 00:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15F664EFB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 00:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBTA70 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 19:59:26 -0500
Received: from sandeen.net ([63.231.237.45]:55692 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229720AbhBTA70 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Feb 2021 19:59:26 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8F820626297;
        Fri, 19 Feb 2021 18:58:35 -0600 (CST)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
 <161370469026.2389661.9403286204851498334.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 3/4] xfs_repair: factor phase transitions into a helper
Message-ID: <4ba558d6-20e0-9dd4-8d47-904b3b55c284@sandeen.net>
Date:   Fri, 19 Feb 2021 18:58:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161370469026.2389661.9403286204851498334.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/18/21 9:18 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper function to centralize all the stuff we do at the end of
> a repair phase (which for now is limited to reporting progress).  The
> next patch will add more interesting things to this helper.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/xfs_repair.c |   22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 8eb7da53..891b3b23 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -847,6 +847,12 @@ repair_capture_writeback(
>  	pthread_mutex_unlock(&wb_mutex);
>  }
>  
> +static inline void
> +phase_end(int phase)
> +{
> +	timestamp(PHASE_END, phase, NULL);

(future cleanup, remove the unused 3rd arg from this function and make
it a void....)


otherwise this is a trivial no-op, congratulations you gat an RVB! ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> +}
> +
>  int
>  main(int argc, char **argv)
>  {
> @@ -876,7 +882,7 @@ main(int argc, char **argv)
>  	msgbuf = malloc(DURATION_BUF_SIZE);
>  
>  	timestamp(PHASE_START, 0, NULL);
> -	timestamp(PHASE_END, 0, NULL);
> +	phase_end(0);
>  
>  	/* -f forces this, but let's be nice and autodetect it, as well. */
>  	if (!isa_file) {
> @@ -899,7 +905,7 @@ main(int argc, char **argv)
>  
>  	/* do phase1 to make sure we have a superblock */
>  	phase1(temp_mp);
> -	timestamp(PHASE_END, 1, NULL);
> +	phase_end(1);
>  
>  	if (no_modify && primary_sb_modified)  {
>  		do_warn(_("Primary superblock would have been modified.\n"
> @@ -1125,23 +1131,23 @@ main(int argc, char **argv)
>  
>  	/* make sure the per-ag freespace maps are ok so we can mount the fs */
>  	phase2(mp, phase2_threads);
> -	timestamp(PHASE_END, 2, NULL);
> +	phase_end(2);
>  
>  	if (do_prefetch)
>  		init_prefetch(mp);
>  
>  	phase3(mp, phase2_threads);
> -	timestamp(PHASE_END, 3, NULL);
> +	phase_end(3);
>  
>  	phase4(mp);
> -	timestamp(PHASE_END, 4, NULL);
> +	phase_end(4);
>  
>  	if (no_modify)
>  		printf(_("No modify flag set, skipping phase 5\n"));
>  	else {
>  		phase5(mp);
>  	}
> -	timestamp(PHASE_END, 5, NULL);
> +	phase_end(5);
>  
>  	/*
>  	 * Done with the block usage maps, toss them...
> @@ -1151,10 +1157,10 @@ main(int argc, char **argv)
>  
>  	if (!bad_ino_btree)  {
>  		phase6(mp);
> -		timestamp(PHASE_END, 6, NULL);
> +		phase_end(6);
>  
>  		phase7(mp, phase2_threads);
> -		timestamp(PHASE_END, 7, NULL);
> +		phase_end(7);
>  	} else  {
>  		do_warn(
>  _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
> 
