Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72BCC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 04:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbiC1EJp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 00:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiC1EJn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 00:09:43 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77FC4F474
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 21:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648440483; x=1679976483;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=oxTyd3rceR0vk+a2kVnjlgDvw92SFnOgS7fo6r3xGyg=;
  b=bAqkB6zqQVKJZqbOHf/nvxY3LDey9vvyrfedq0KWZY30agkBmJ6yQDjY
   jZp1tH6mz73e8yt0GI/x5LGXoIHCU7wdOQAPYqmIa1jUt4s2Ddrl9qrpV
   d/AXdl+yiTEO5+GAIG9M86xSbaglCBaZRsuFXJxks7UEj1ED9OzynE7CB
   /LlhNlJrtHltuDXjeD/z4yHWEnLolmgrxguHqFKTJMTpdO6FyijjM2N71
   9BPNIKsC9IEHOJUhVJrnVGbP+XPS0gIcEOp0Plz5Scg0SgY49NfHkXieF
   TcIZp5Z/DKQMM8+/fjD82uhI0X29Ptt4dQd6pf+cm3SzV0gwdZz3p4k95
   g==;
X-IronPort-AV: E=Sophos;i="5.90,216,1643644800"; 
   d="scan'208";a="308365151"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2022 12:08:02 +0800
IronPort-SDR: u+7Bo9q5Fi4RAgAIJowEqTcC039j71KtmZ7lpJHoIxY7FIsTAjLdzcgfHZmEzKRvdwFoDJ0zXi
 zxkMhbQTQVNFb7tqoZwK/6EfVzpL+/wOL87z3BHokCnrW63yP7SUnrjx+OQdKUE7I2HtYT1I5T
 IYlEf/CZF2I66vxyH1YrdkV0GsZRSCnn2MYHuJASkiA+83heH7FdATGTUvve1wiul+RB9GxIwh
 RpGU4SOYb8B8gGp5ge81l31gl5WFGKRGY/gBhNg4MFw4sSz/zImKharUcQ/KsEo+w4LeWng9Fr
 U9GCSCqDUO5AKr8x0bsJAyDw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 20:38:55 -0700
IronPort-SDR: L9b7rUGme9b4unG0HpiFQDwVFkF6alRs/fpDmvUBF7uYEuw6hfvcAKSsvIf0UPQntW4YetGSq9
 w+44JkBfU4PFsGVYcdgXEG5ZxmoAT4yx/3sZlNPJ09TIbdsV6UzjbclFNjTV/DSr2hgi3oA/M9
 BSEFt18LXsZVCv0X5vzYpSCLq0FBaZWxubshl/1QQSR0K757TEiS9M60qdH8YvAj/gioh+V8iR
 kuAe63nFOP6pFq7siVFEXeo3p1NVg2d7tJ1Oc5Pwll9vep30/6qDzDw9RZFPPINsrmy+/7TUD8
 Xpw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2022 21:08:03 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KRfLV0SXsz1SVp3
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 21:08:02 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648440481; x=1651032482; bh=oxTyd3rceR0vk+a2kVnjlgDvw92SFnOgS7f
        o6r3xGyg=; b=r1TdfNgpBJ9Ir4clrvE2JsrJNnc4D9y1eV92c7t5rqiT/gH3Zcj
        R3HySJsZO+PyLwH2oia15Zzd70Iqy3Ak1GfknxjzmcLvD+skVe+mqQgAcPGBNLBG
        bTBKcKJ+vz9dFlWGLsjzyj3gsIerhue0zmJv8ynV9mkUD1Su4gICi24+EJHNyQVI
        2ZbqormjA753XjETi3cNdvYS8Qj1nFrC4KABZps2ENpzgk+PIMTam4WJlGjBMy1I
        Ob/VxoFX0HRv4fA2NANEcYC95t4P5cybh98QWpUGKA90WhWv3QARIm96zBELivy/
        sgaC0E5Yo5DcCSuZ5J+RFPgMdGUY+iPzwwA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dDZoxDltm0Xz for <linux-xfs@vger.kernel.org>;
        Sun, 27 Mar 2022 21:08:01 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KRfLR56N9z1Rvlx;
        Sun, 27 Mar 2022 21:07:59 -0700 (PDT)
Message-ID: <222e0a61-d046-89fc-d46b-ac8da3ca7828@opensource.wdc.com>
Date:   Mon, 28 Mar 2022 13:07:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] fs: xfs: add NULL pointer check
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     cgel.zte@gmail.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com,
        chandan.babu@oracle.com, bfoster@redhat.com,
        allison.henderson@oracle.com, lv.ruyi@zte.com.cn,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
References: <20220328032642.2371596-1-lv.ruyi@zte.com.cn>
 <32fad707-fdab-75a6-f7e5-d356a0b86983@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <32fad707-fdab-75a6-f7e5-d356a0b86983@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/28/22 12:40, Damien Le Moal wrote:
> On 3/28/22 12:26, cgel.zte@gmail.com wrote:
>> From: Lv Ruyi <lv.ruyi@zte.com.cn>
>>
>> kmem_zalloc() is a memory allocation function which can return NULL when
>> some internal memory errors happen. It is safer to check NULL pointer.
>>
>> Reported-by: Zeal Robot <zealci@zte.com.cn>
>> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
>> ---
>>  fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 014daa8c542d..e6694f49f563 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -1571,6 +1571,8 @@ xfs_attr3_leaf_compact(
>>  	trace_xfs_attr_leaf_compact(args);
>>  
>>  	tmpbuffer = kmem_alloc(args->geo->blksize, 0);
> 
> See kmem_alloc() code: this function cannot fail (it retries the
> allocation until success). So checking for NULL pointer does not make sense.

Note: this comment is not 100% correct. kmem_alloc() can fail if
KM_MAYFAIL is specified as a flag. But that is not the case here.

> 
>> +	if (!tmpbuffer)
>> +		return;
>>  	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
>>  	memset(bp->b_addr, 0, args->geo->blksize);
>>  	leaf_src = (xfs_attr_leafblock_t *)tmpbuffer;
>> @@ -2290,6 +2292,8 @@ xfs_attr3_leaf_unbalance(
>>  		struct xfs_attr3_icleaf_hdr tmphdr;
>>  
>>  		tmp_leaf = kmem_zalloc(state->args->geo->blksize, 0);
>> +		if (!tmp_leaf)
>> +			return;
>>  
>>  		/*
>>  		 * Copy the header into the temp leaf so that all the stuff
> 
> 


-- 
Damien Le Moal
Western Digital Research
