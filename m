Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCDEC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 04:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiGKEsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jul 2022 00:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiGKEsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jul 2022 00:48:02 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CD563DD
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 21:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657514875; x=1689050875;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nuTqhrMOdsIJCc5l5OlOEhmwel6CrsBvymyqEdZqFGc=;
  b=MosHXhgzQ6ZIDLf/s6k0Zu3lqlmPuz56aWKmxTogmIbOkUocW4iVNSEb
   8xNv6bM+wqf2P1O8lzZWTrH7kKX8em/7nym6eg1EYdB0ABvcvvtnMXDbo
   040RMqqTSHxnLSmd3IqeM3ggmtaWbPvG+EuOK9NsL41sFTEkKp/6TNd5b
   57XFJnsKRku+YNRd/iStOiLFNjZdQgJwZZ60LlMgvrwY+ZUdcqHYMIw67
   wW8n3Dk5SnBM2dHQ2IHfPvD5aZwluUXzQeANASxnEkzTB0yV5k1ClgFcu
   IBLgsfh27Rpvvw9aAgSgw9he0tKAdXxJrjfajNSEmPyBXwa+t++AIIw6M
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,262,1650902400"; 
   d="scan'208";a="203974959"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jul 2022 12:47:54 +0800
IronPort-SDR: j532JcisN8iWcutGNt0UI9iS59XFqHpT59KU+HQXKMwqR2JrFh9OpqINPLFhAWSD/Wg4CjWi3i
 pF5F+GDVf9/BEhirPe2xT3ChrCQh28GZyLwHmC3D5ZNca05lvLUwBnPks2lCiozWT9Ckbta0pj
 vuLtdjuY2gFMx40q7nObzs0tl83Ae9j0BNbYUm6FGoQ7VhZIETM5YZMg2RDWLI/zKvH8t+CDHM
 rSI1HphJeOFVl6KIHukZ/UvQSQfH3ExgOSBoiXCUo9npYOGzvv8EXaJo0/oXDVpsL6xdbP58Bs
 kPrKgjB5xN1dEbFwqWRObO6Z
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jul 2022 21:09:32 -0700
IronPort-SDR: /n6Uu5OXPcGZ2EjI6F9zCwuz2U+eUbIpNbfzG6XAnp1T6Lc5uLMGV9XzsoZrJUXiH1SNwYOZh6
 fsfDvd2tRjfmXllugomc37eOpybWzOR2DEn2UKZ0erZdh23ZYHlZi5A/enWEHzVrlEhHDBViiR
 gkNQ2elbmY8yKVjKRrYwU9/mofZWdIfkjpzzBTudmPSFzvBmDCfGgMNPQchuLUN0Rn476bohoL
 rHf4rgrdaVaTVEv4YYHZmqw0jf9857fNAyvvroUdhZXdpFiPbbLI7hK0mi0NlZrnq3M6/IWa1w
 MD8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Jul 2022 21:47:55 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LhBG21Pkqz1Rws0
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 21:47:54 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657514873; x=1660106874; bh=nuTqhrMOdsIJCc5l5OlOEhmwel6CrsBvymy
        qEdZqFGc=; b=alBdI8OHo5qi0Ph0TBWmFSspBFsMiRpnQtAlk9jfK8Dt6MbSQFE
        8QMIH+ODq/lyp6MMJsby+y4Us6UJt81oZSKv5vMKYdFajLSmrUM95lFO9i47ZvdF
        nw421smr0zRXRzW3X/v8FAnFqtOUItGD3+m++WpaDvXRbttMW8lxJjGpNEmSdb7x
        UABONt+CCuxrF65FbwGJD9oY+kwZa6eatBb/gAU6cCz1OaYQ+cFhJslalMYbfRVj
        J+j9t8D2Sn9VqG4TaKDbtrSBb5MQtKiPxptHQialI8pjfOb6lBz7ccoorV7D01qM
        MzAykJyxoQ1NeiCdz+yybXQ4u79TCm9JSsw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uWVNX2aEsI-W for <linux-xfs@vger.kernel.org>;
        Sun, 10 Jul 2022 21:47:53 -0700 (PDT)
Received: from [10.225.163.114] (unknown [10.225.163.114])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LhBG00pFFz1RtVk;
        Sun, 10 Jul 2022 21:47:51 -0700 (PDT)
Message-ID: <3b411188-50ec-4844-73c3-afed8dd3fcf2@opensource.wdc.com>
Date:   Mon, 11 Jul 2022 13:47:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/4] zonefs: remove ->writepage
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>
Cc:     Johannes Thumshirn <jth@kernel.org>, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20220711041459.1062583-1-hch@lst.de>
 <20220711041459.1062583-4-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220711041459.1062583-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/11/22 13:14, Christoph Hellwig wrote:
> ->writepage is only used for single page writeback from memory reclaim,
> and not called at all for cgroup writeback.  Follow the lead of XFS
> and remove ->writepage and rely entirely on ->writepages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/zonefs/super.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 053299758deb9..062c3f1da0327 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -232,13 +232,6 @@ static const struct iomap_writeback_ops zonefs_writeback_ops = {
>  	.map_blocks		= zonefs_write_map_blocks,
>  };
>  
> -static int zonefs_writepage(struct page *page, struct writeback_control *wbc)
> -{
> -	struct iomap_writepage_ctx wpc = { };
> -
> -	return iomap_writepage(page, wbc, &wpc, &zonefs_writeback_ops);
> -}
> -
>  static int zonefs_writepages(struct address_space *mapping,
>  			     struct writeback_control *wbc)
>  {
> @@ -266,7 +259,6 @@ static int zonefs_swap_activate(struct swap_info_struct *sis,
>  static const struct address_space_operations zonefs_file_aops = {
>  	.read_folio		= zonefs_read_folio,
>  	.readahead		= zonefs_readahead,
> -	.writepage		= zonefs_writepage,
>  	.writepages		= zonefs_writepages,
>  	.dirty_folio		= filemap_dirty_folio,
>  	.release_folio		= iomap_release_folio,

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
