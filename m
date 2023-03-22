Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0793DC6FD1C
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Mar 2023 23:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCVXgJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Mar 2023 19:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCVXgI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Mar 2023 19:36:08 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C07B2366A
        for <linux-xfs@vger.kernel.org>; Wed, 22 Mar 2023 16:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679528159; x=1711064159;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AwL0lpa0BGrmVgQeZv6ZCbP7r3t5dc6HGVJ71kVO95k=;
  b=WV4yVqlPIQxhfKAUI8Sk12SKz9jrs5agQnYeLRTGc1FKU0jOk1K8KZxg
   XDGXE1iFODmQLktT7flaPN7+RsA5LiAU60C/TGe009BOjBPVkexQ+sXyD
   i6Fie0giIEOb8AQ9QNs9M2rxko3ZhxT6NRjdpzR7zI2IuLH1lTwAcRthx
   1CExNpZ917TISYJxw/XA+UhKJlh2Sl70AaHDYg60TvSvd4+Vi84JhK4Fl
   JByx+QgjuHJ1XtNOttiNp9Gg8CX3RqRZUdwPzXiJA2W4eFSd75tGVJvET
   RFPeAaRW/fRwxnuNJyl07K/dU32Ch8zdOKLCjzpq5QzFFYNwkGDcDYtQM
   w==;
X-IronPort-AV: E=Sophos;i="5.98,283,1673884800"; 
   d="scan'208";a="224559474"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Mar 2023 07:35:59 +0800
IronPort-SDR: HOdAAQ8kj1SgKTG7aXngaXYqsuHlQoBzHupqZH69JIhuvhvJi5VbEjMf4tPyfrlmis0xLHJWvx
 pDTim11cHI7k/1JChJ7Y6ziO0eUOy93m5beLnus1pZ/YGkHKPpCL4doZjpfOjpODsJ8vWP2YBH
 +pOpWsUa6PXYQ0B69anyGu1/msFHY02qfedU3CZHlP8N2YNPYhi0qxU9ekgVnW7l3DayylU0BK
 C/QxCWqGC03+1pFsLNOoISWz3wnPYptb4skvOJBuvt1qPaEqQe6dDZ+shBzbtp60GX8bi3i4V8
 90A=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Mar 2023 15:52:16 -0700
IronPort-SDR: p76RleVWywCwxHmrJf4yUuCMegCgK4vuJB7NsHcAvJ2obLmNxLazdBL+i2DNirv09UU+u8e0ZX
 wxd90H0ABFpOTZOdmcs9mmwU85rrccXeufnIVSPCAJ5YJHjQwMnkgPSo/tpcxDivIvNYVDqPyk
 VaN/sQAGilxsn3in1HwF8B9kD85clihEmHiD2jAP3gP5EAn7esgh9cVDcWAqCxUaOQrx/T7dfw
 NzRj/FNrrpUpFrzRC88mtcFpT5HI1qN5fs56A430drBU9CpjWgugOKiEskDp5VDb0++4LVPkZC
 2r0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Mar 2023 16:35:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PhlGR35ghz1RtVn
        for <linux-xfs@vger.kernel.org>; Wed, 22 Mar 2023 16:35:59 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1679528159; x=1682120160; bh=AwL0lpa0BGrmVgQeZv6ZCbP7r3t5dc6HGVJ
        71kVO95k=; b=Lr67VrgbhC3s4IgaiuiL0vs8D/Ua4kh5dhomRxE+jz5XkgQxabc
        WENMxVoUqNTX0w5G5TnD5ksMVtSvckj6Xp2NL5E0XVFJG2SOBtgYIwHbOFX4K+vQ
        +NoOq6kwFqV0/4S7uKo6hs/sFauEla4COXtc0fSND2ZiM8mhMykGj/l5cBcqqRj+
        Q/CEYai6sh8Jw2JMTtDQ1+OSMXDahFrlybdMVOH7jZNj8ECG2T1jHpoBMIeW55Dg
        ++dhr630HKnph5txVv+d84WopPGJdXB93mQWoLh+SkKyW8EVXa7U8QfWBdPI8Yyt
        ozti80ANiztAyiZ+otUmXm0VIb5s7AC3Zlg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XMv2Bs_0AYrg for <linux-xfs@vger.kernel.org>;
        Wed, 22 Mar 2023 16:35:59 -0700 (PDT)
Received: from [10.225.163.96] (unknown [10.225.163.96])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PhlGQ1Zpyz1RtVm;
        Wed, 22 Mar 2023 16:35:58 -0700 (PDT)
Message-ID: <26051414-f4b2-a212-8cc2-f9559c51bbfe@opensource.wdc.com>
Date:   Thu, 23 Mar 2023 08:35:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3 07/10] xfs: convert to kobject_del_and_put()
Content-Language: en-US
To:     Yangtao Li <frank.li@vivo.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230322165905.55389-1-frank.li@vivo.com>
 <20230322165905.55389-6-frank.li@vivo.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230322165905.55389-6-frank.li@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/23/23 01:59, Yangtao Li wrote:
> Use kobject_del_and_put() to simplify code.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Yangtao Li <frank.li@vivo.com>
> Acked-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

