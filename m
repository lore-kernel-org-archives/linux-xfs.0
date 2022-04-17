Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBF1C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 17 Apr 2022 10:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiDQKSr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Apr 2022 06:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233873AbiDQKSq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Apr 2022 06:18:46 -0400
X-Greylist: delayed 905 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 17 Apr 2022 03:16:06 PDT
Received: from sender11-of-o53.zoho.eu (sender11-of-o53.zoho.eu [31.186.226.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E3425EBD
        for <linux-xfs@vger.kernel.org>; Sun, 17 Apr 2022 03:16:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1650189650; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=EzWU1jjsrN2CTTRolpZYndgtvEega7cafivb9IkZCeu+foihaTtFYiRbUVFEfBvCEw0fVT5yaoZRlaTl2Mbvl2CVVAcIYwqhaIYKYRQHowKb7Qz0KNtU309g2uQAjOmFZTiIS2+71WiuXOcMqMkm4DJaU07nZFsDSTG/hPC5hkY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1650189650; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=T8oo0G2292UGYvqCJYep97coqwsc0Ua5om8rLBb/9oE=; 
        b=iuEJXr7ZRo7yet7/099YFZSEFvovux4Q2ranhOBiepazgHeK9Xg13Oe0vNGGSd/9gTb2esGEEpYSySeTCLcJcxCREGYqNtKqsgmqLDct7YRTNX6h58J7GqUf91DV0NDC9IYBQ2/dNMz4KM5P9Nte23ZXSa2eZ5YxBpffCjk0wPI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from [192.168.0.103] (nat2-3.finemedia.pl [188.122.20.100]) by mx.zoho.eu
        with SMTPS id 1650189647934421.1760737456892; Sun, 17 Apr 2022 12:00:47 +0200 (CEST)
Message-ID: <b51a775f-5fcd-a569-6a23-e9c91ab43c5f@debian.org>
Date:   Sun, 17 Apr 2022 12:00:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
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

Hi!

Am 07.12.21 um 13:21 schrieb Bastian Germann:
> Fix the Debian build outside a git tree (e.g., Debian archive builds) by
> creating an empty .gitcensus instead of .census file on config.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

2nd friendly ping on this.
For the last few Debian releases, I applied this.

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

