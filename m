Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32A1C761A6
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Mar 2023 07:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCTH0O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Mar 2023 03:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCTH0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2023 03:26:13 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CFC1CBD5
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 00:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679297172; x=1710833172;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PznhUX2rDF8uhJla7kd2cwVnZx5w5yiNB4r5BQcdnfM=;
  b=O0Ba+VonhtU394oV9+xtdXCgjfpeBs6kPv0lwGLa/qaLgj3mzUbYYkWf
   dg6iipH15s0lia3PzitHUfyHpDjHXibQ7KzUWVKcYwO1Ns52+3T86jbYz
   ZH+83lFmk5M2PzulymjXXRI5pqSKjtJzp/vPzufNanxk04Dt0vBpYbV6D
   ztE2MXe8yZaWyZ7F7aLKNqN3iwraMjPPlcI+k+9wKzxPztHPtntMv0fvP
   fOsv3nAocO1p9OCLlkrO8crteDlrBlYUgl3nFqTED2XdsHByKBkwrn4sU
   1tIbizCxqX2Gplx+eUUQwWRomBxXLtUfaNG40ObiFpg5b3087ojnEldng
   g==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673884800"; 
   d="scan'208";a="330429287"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Mar 2023 15:26:10 +0800
IronPort-SDR: K0NmcIde/igpcJkXyY62KEgZbZ0yDkS2qQuvOzGnMvIJQmO4YrlAkGGH0aXfzHeGfGGj657M2r
 RxrbpXh96ybdLErcA+9mPL/3ck821Zg6sjmw/kBZ34+TtTudx0aMCFWDpBcqZY+1CUQ7wLIhe9
 IYZN/keuLWpbkgbAkQbxGKrrEPYfLNbdsHAVo9wZK0s251vaDPmAbd9Jo6i4slDeCDBOM5a7gx
 RzROIQcBMOeFG59r6eMwbwAgOy6u0/7RqAyJORQrGBFCIJxGjM5nlmz4xJNCE+BcHIsZt0B2g0
 eVU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Mar 2023 23:42:31 -0700
IronPort-SDR: qQ34XvgOd+CZe+DmuonZnUi/E5EJtR1k0uTZ5jBzxSaA/QYmGvaPVvVvWB+yFIE4urdqwJICK0
 J2ujirSGypAJ+BeQsGcZ2cVWzklGtupmUtRs/kM+gY69nF69TZRkSf7sMToZa1q+4OvxcbWoUc
 VWraUyKnkrfa8wCxgCUVNI/IsmKOB2lVP6VfCO5g0XS/0XM2jrX2M6JC+UTXbHDhUhI//2ehGx
 Vj/mkq1CxguzegirIKoEXWPRCTxWe8EsEIk0EkaBEymRqOh/5bU4bukPvGqfCy+Sm3ble0R4GX
 a0A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Mar 2023 00:26:11 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Pg5rL4Qh3z1RtVw
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 00:26:10 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1679297169; x=1681889170; bh=PznhUX2rDF8uhJla7kd2cwVnZx5w5yiNB4r
        5BQcdnfM=; b=Ac3sR0XYJ+rryJ+0bDOPKxCm+dcSwHcMLzkGxuGt8+HwZ87G7ax
        pAFVEfaZLRQ1T7YBu9pTJb2iOB0dq+m2M50+2ySCb+VWMEj6z8KBJcfvkX/VTy5y
        HdsZwpvEu2xSrqc4DcASona2/D8FSQf2eX7sdS1/ZdFCrT/cmr56n/dcPEizamwB
        YvpCPWbz6qWy+PWRiDVh/KqVyD37i1IhQ4/yFHZk59+5WH/VWBjihD6KvLqKMHsL
        iYmgtRtkq5BDuKsPoQJio8UBdylvkAVkIe2vLW8QNxxsm80THSUesX6KayIzGn6+
        /6kD3KtQY7keflXYjvtNZUIrzhBwhIGlsKA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wN09r6ZY-dKx for <linux-xfs@vger.kernel.org>;
        Mon, 20 Mar 2023 00:26:09 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Pg5rB164vz1RtVm;
        Mon, 20 Mar 2023 00:26:01 -0700 (PDT)
Message-ID: <982b6aa9-4adb-acef-d9d7-9a1764a66213@opensource.wdc.com>
Date:   Mon, 20 Mar 2023 16:26:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2, RESEND 01/10] kobject: introduce kobject_del_and_put()
Content-Language: en-US
To:     Yangtao Li <frank.li@vivo.com>, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, xiang@kernel.org, chao@kernel.org,
        huyue2@coolpad.com, jefflexu@linux.alibaba.com, jaegeuk@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        konishi.ryusuke@gmail.com, mark@fasheh.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, richard@nod.at, djwong@kernel.org,
        naohiro.aota@wdc.com, jth@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <e4b8012d-32df-e054-4a2a-772fda228a6a@opensource.wdc.com>
 <20230320071140.44748-1-frank.li@vivo.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230320071140.44748-1-frank.li@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/20/23 16:11, Yangtao Li wrote:
> Hi filesystem maintainers,
> 
>> Hard to comment on patches with this. It is only 10 patches. So send everything please.
> 
> If you are interested in the entire patchset besides Damien,
> please let me know. I'll resend the email later to cc more people.

Yes, I said I am interested, twice already. It is IMPOSSIBLE to review a patch
without the context of other patches before/after said patch. So if you want a
review/ack for zonefs, then send the entire series.

> 
> Thx,
> Yangtao

-- 
Damien Le Moal
Western Digital Research

