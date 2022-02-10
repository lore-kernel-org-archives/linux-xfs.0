Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C59EC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Feb 2022 12:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiBJMu3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 07:50:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241733AbiBJMu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Feb 2022 07:50:29 -0500
X-Greylist: delayed 906 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 04:50:28 PST
Received: from sender11-of-o53.zoho.eu (sender11-of-o53.zoho.eu [31.186.226.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78E52633
        for <linux-xfs@vger.kernel.org>; Thu, 10 Feb 2022 04:50:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1644496511; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=V4i3vsKJFiVCDgUxrTmGb2hGwwdNJClcUPMIv6AGV+EdbgvthaLrvg12NufRv/5xf3l/JJsb7ODQsRR/YkzZzNDMzVpukdHO9chDBfh3F05jpb4a7T03kB03zEprEaCRur/h72Sj45RJR3elCFkFXygJn4tMErpyEdwT2VMN/ko=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1644496511; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=G1f3fGELu2Wf/6cZc8tbomVisIHWvHbJXzr53197nJk=; 
        b=Fi1qLF0fK9Eqe/GJ2kYQM53R+jAMGVzC9XGghz9GY8HyCJk+OD4QVzSROLhjmLht1gEwl1QxSz+kj0GJuWmxfgxlYyIFQOwJgIu3Dk+8ssYJMKn6krovwtWrFLOX4xXfXka142xiJebFgxlqOcNMfPIYw/SKq3NIxr/0yRZfsZU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from [192.168.0.101] (nat2-3.finemedia.pl [188.122.20.100]) by mx.zoho.eu
        with SMTPS id 1644496510202463.82356579633154; Thu, 10 Feb 2022 13:35:10 +0100 (CET)
Message-ID: <49b0f548-a3c0-6130-b584-74947a187780@debian.org>
Date:   Thu, 10 Feb 2022 13:35:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 1/1] debian: Generate .gitcensus instead of .census
 (Closes: #999743)
Content-Language: en-US
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
References: <20211207122110.1448-1-bage@debian.org>
 <20211207122110.1448-2-bage@debian.org>
From:   Bastian Germann <bage@debian.org>
In-Reply-To: <20211207122110.1448-2-bage@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey,

I want to remind you of this patch before releasing xfsprogs 5.15.0.

Thanks,
Bastian

Am 07.12.21 um 13:21 schrieb Bastian Germann:
> Fix the Debian build outside a git tree (e.g., Debian archive builds) by
> creating an empty .gitcensus instead of .census file on config.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   debian/rules | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/debian/rules b/debian/rules
> index 615289b4..6d5b82a8 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -43,15 +43,15 @@ built: dibuild config
>   	$(MAKE) $(PMAKEFLAGS) default
>   	touch built
>   
> -config: .census
> -.census:
> +config: .gitcensus
> +.gitcensus:
>   	@echo "== dpkg-buildpackage: configure" 1>&2
>   	$(checkdir)
>   	AUTOHEADER=/bin/true dh_autoreconf
>   	dh_update_autotools_config
>   	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
>   	cp -f include/install-sh .
> -	touch .census
> +	touch .gitcensus
>   
>   dibuild:
>   	$(checkdir)
> @@ -72,7 +72,7 @@ dibuild:
>   clean:
>   	@echo "== dpkg-buildpackage: clean" 1>&2
>   	$(checkdir)
> -	-rm -f built .census mkfs/mkfs.xfs-$(bootpkg)
> +	-rm -f built .gitcensus mkfs/mkfs.xfs-$(bootpkg)
>   	$(MAKE) distclean
>   	-rm -rf $(dirme) $(dirdev) $(dirdi)
>   	-rm -f debian/*substvars debian/files* debian/*.debhelper

