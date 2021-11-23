Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D2CC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 20:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhKWUET (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 15:04:19 -0500
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21863 "EHLO
        sender11-of-o53.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239609AbhKWUER (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 15:04:17 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637697665; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DzM2eRzt0L8TikhhmZMPzT3iVOsRmyYllmVjtkv0q8WLcPgO0y64rJLNBMxCJYsEhjwc17rGBuCevJbzHW8MqgUk1FwukQvwJMy9uAUOyXc2OENGP9zaGP/UG2ANfu9VbrTAJbtBVQYk7zq1HTzD5zrK2pLP6LZZX8A6wrlW9/4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637697665; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=d6PChhahJC0zWQeWe2yIJJUO0ZqtAzmoUgqHNbubrXo=; 
        b=KEFecSSbFsA1NGtt1y4pwJ3j4vEC6llyl/ohLkPogZsiQ1SbC1h4K0OqcgkBtA1vDPdqcWUbKhO2s0tNm5SScPOH6irUKSvl0SavXmthXd5rsrfoX/qEKYyWSeSzog7ApI5dniAw4huGrHW87vyOo6GWUFjFxKouNzESebk/bZA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from [192.168.178.23] (pd95445e6.dip0.t-ipconnect.de [217.84.69.230]) by mx.zoho.eu
        with SMTPS id 1637697663692421.13677058679446; Tue, 23 Nov 2021 21:01:03 +0100 (CET)
Subject: Re: [PATCH 1/2] debian: Generate .gitcensus instead of .census
 (Closes: #999743)
To:     linux-xfs@vger.kernel.org
References: <20211119171241.102173-1-bage@debian.org>
 <20211119171241.102173-2-bage@debian.org>
From:   Bastian Germann <bage@debian.org>
Message-ID: <b4690ab9-540a-758b-475d-a849feacdd3a@debian.org>
Date:   Tue, 23 Nov 2021 21:01:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119171241.102173-2-bage@debian.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

@Darrick: Thanks for caring about the 2nd patch. Is anyone up to review this patch?

Am 19.11.21 um 18:12 schrieb Bastian Germann:
> Fix the Debian build outside a git tree (e.g., Debian archive builds) by
> creating an empty .gitcensus instead of .census file on config.
> 
> Signed-off-by: Bastian Germann <bage@debian.org>
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
> 

