Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD007C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 14:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8878A64E76
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Feb 2021 14:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhBVOOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 09:14:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232433AbhBVONL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 09:13:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614003104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yql1FFhAWSi9nl6lpHRpIvAXxZSno3A/E6Yi0jzDGqg=;
        b=GfJolx6ZohhoBGBFXYP9mEFdLbaTDrVgvmI4DrkKUtw1+pX3geuXXM9fBCuueQWxnZ9xit
        4N8kQEo3g4Modx+dpgpVl2Du9P/oIV+L3OCqtSF+Ff41uWvCr1DbAPX0imj79R90/bOzDF
        oQ7VlgKGMV7UaiGjDQvBUQAqFIoqJqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-IYQou6TGOc-hrfaYAXi2-A-1; Mon, 22 Feb 2021 09:11:43 -0500
X-MC-Unique: IYQou6TGOc-hrfaYAXi2-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1178F1005501;
        Mon, 22 Feb 2021 14:11:42 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9153260622;
        Mon, 22 Feb 2021 14:11:41 +0000 (UTC)
Date:   Mon, 22 Feb 2021 09:11:39 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: factor phase transitions into a helper
Message-ID: <20210222141139.GC886774@bfoster>
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
 <161370469026.2389661.9403286204851498334.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161370469026.2389661.9403286204851498334.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 07:18:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a helper function to centralize all the stuff we do at the end of
> a repair phase (which for now is limited to reporting progress).  The
> next patch will add more interesting things to this helper.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

