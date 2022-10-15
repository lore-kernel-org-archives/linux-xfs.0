Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E17C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Oct 2022 05:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJOFBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 15 Oct 2022 01:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJOFBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 15 Oct 2022 01:01:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CC65E33B;
        Fri, 14 Oct 2022 22:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 929D2B81116;
        Sat, 15 Oct 2022 05:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE26C433D7;
        Sat, 15 Oct 2022 05:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665810110;
        bh=F1oiTjhm+w+eAsnv3v10CF9kD4A28NlZvzmDBuCrxnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gl6QmJk29091XeOrYS+V+vMgwYx3UzUyGKes5mLTKfjQfmv7c7ZewFjlfjXRtiJjj
         JmOVVpFZWP/l5nrqoxU/+B/6lwVzzvRBDAF/QMHWtNcz1/SD+cbGRBOQVDCxYw7nlP
         swbAZZKMSzYyFfFWm+jVO2pPlNAWBUGcrt2F2epqWtMcs/f+LJAlyg1ERlLXaSqxnY
         ovWnl+8PkstT6BHJ5JMawE3gr2fkN1I/JqVKlEGPs8PlNqLVcEI0YaoKth7Du/ADXW
         ToArm3kKdeyUbsppj5c6fNhW5OjlEtzI8TWzZ5vJzrYG8teWp4Te3STuF2ZSeVmmr2
         ozPmwnmVC/J9g==
Date:   Sat, 15 Oct 2022 13:01:44 +0800
From:   Zorro Lang <zlang@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v1.1 1/5] populate: export the metadump description name
Message-ID: <20221015050144.w4bq5vycditc6fgs@zlang-mailbox>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
 <Y0mowyuRHSivs3ho@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0mowyuRHSivs3ho@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 11:21:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make the variable that holds the contents of the metadump description
> file a local variable since we don't need it outside of that function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> ---
> v1.1: dont export POPULATE_METADUMP; change the description a bit
> ---

So you don't need to export the POPULATE_METADUMP anymore? I remembered you
said something broken and "exporting the variable made it work". Before I
merge this patch, hope to double check with you.

Thanks,
Zorro

>  common/populate |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/common/populate b/common/populate
> index cfdaf766f0..ba34ca5844 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -868,15 +868,15 @@ _scratch_populate_cached() {
>  	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
>  	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
>  
> -	# These variables are shared outside this function
> +	# This variable is shared outside this function
>  	POPULATE_METADUMP="${metadump_stem}.metadump"
> -	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
> +	local populate_metadump_descr="${metadump_stem}.txt"
>  
>  	# Don't keep metadata images cached for more 48 hours...
>  	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
>  
>  	# Throw away cached image if it doesn't match our spec.
> -	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
> +	cmp -s "${populate_metadump_descr}" <(echo "${meta_descr}") || \
>  		rm -rf "${POPULATE_METADUMP}"
>  
>  	# Try to restore from the metadump
> @@ -885,7 +885,7 @@ _scratch_populate_cached() {
>  
>  	# Oh well, just create one from scratch
>  	_scratch_mkfs
> -	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
> +	echo "${meta_descr}" > "${populate_metadump_descr}"
>  	case "${FSTYP}" in
>  	"xfs")
>  		_scratch_xfs_populate $@
> 
