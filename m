Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17CFC43332
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC88764E87
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhBKOFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:05:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232133AbhBKOCb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 09:02:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613052059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUGzK3UEoyscV+QUxhckkZUx3TDOUzmiNSZMU4IFcQY=;
        b=djAFOAqu6eeQ71otx8HW9uor6dBn8O9YTWv9bQq3jskFOPfAUPY7A7H3tM/4FY5lOG+rqh
        GQgvOhEk55XhoH/VW2XhUkCFLyooKL6VEy5nz3V03KnpZstcVLlIhdxC2kJ20v7Fwh7B2Q
        mTOCiYDLuElaKrQvJ0agvfvpLVKYM7A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-BCBeDeLZMkee-pduzSXLRg-1; Thu, 11 Feb 2021 09:00:55 -0500
X-MC-Unique: BCBeDeLZMkee-pduzSXLRg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4ED78710EC;
        Thu, 11 Feb 2021 14:00:54 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1623310023AB;
        Thu, 11 Feb 2021 14:00:54 +0000 (UTC)
Date:   Thu, 11 Feb 2021 09:00:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 6/6] fuzzy: capture core dumps from repair utilities
Message-ID: <20210211140052.GF222065@bfoster>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292581331.3504537.1750366426922427428.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161292581331.3504537.1750366426922427428.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 06:56:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always capture the core dumps when we run repair tools against a fuzzed
> filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/fuzzy |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/common/fuzzy b/common/fuzzy
> index bd08af1c..809dee54 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -307,6 +307,9 @@ _scratch_xfs_fuzz_metadata() {
>  	echo "Verbs we propose to fuzz with:"
>  	echo $(echo "${verbs}")
>  
> +	# Always capture full core dumps from crashing tools
> +	ulimit -c unlimited
> +
>  	echo "${fields}" | while read field; do
>  		echo "${verbs}" | while read fuzzverb; do
>  			__scratch_xfs_fuzz_mdrestore
> 

