Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D262C00A5A
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Jan 2023 05:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjASFOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Jan 2023 00:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjASFOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2023 00:14:04 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A2D1BF7
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 21:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674105220; x=1705641220;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2Zup8f9kJXZ4saeKKXXVCwsH44jxdhWnca7/TJrUBzA=;
  b=dlwtgW0MMNZe0c1+T4tBQrtlNPUfKHUlK1mXfEYefbO5+afdFr5O9Yny
   /9GSXt/PbiB6BAcWePBAaPEyeBA845HYeyIQGDr7ot0dvXh+qVkSeyVzO
   rAEkeyBQWoM4r423PkjUbIfzTieQt0d3Zp9zVVQL/nxlC/lpizRA10hni
   ByDtYChDsT/lwqxoQzbUVKID6RArDQf3G6T0rc+ua/bL+Ar/6YxARdaYt
   jT8c31ObCU6vofu28HOHveJ30Tj1ePbSps+aaFuZl54D/AOW/0MfPE2FS
   CDuDZ03werbJRyi/pw675AX3Qe8D5bQownLwt8eK7vCNHEAc2I22JW7q4
   w==;
X-IronPort-AV: E=Sophos;i="5.97,228,1669046400"; 
   d="scan'208";a="219533487"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2023 13:13:39 +0800
IronPort-SDR: teu4hpVmpYpohtuIzQCbZZLg1NxwqSux4N74k9UfluQJDtRLL6y+vyO43u1b11wzC11S6k8KS2
 Y4gq6R66tgxIecIvTLpkqVKZoGU189IjDgymXZ+2aHAzAn3tfGqDYBO1Wbs4D8+KxcxyVGBmYj
 6RYf+EdNqatrAocGUxaLYpbwgdUJlYYniSBAILrnI2SWmzLxyBv0x9IXWZrVgCmYWxgh2wBcZg
 WgHfEyS/bxgQhYEKC7uz3c4hZlaHDFZAd2R5D9b21RPDLD+P/sPfdK7AwTwdawpIcS6HWKWjtC
 +aI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jan 2023 20:25:34 -0800
IronPort-SDR: FtxUM83M4xlpoWH5oBN3aU2wouLEIRDdpFvS29B/xxbjmTHiUbTQljtI468DmU3k1rMcLzmdos
 FLW5PCtwJt0/F7RXRoasPtNCqfsf4BRlepxKZgVUyXIGX3n/BKzGX/xHRYvEzSPkNaioXDndOt
 TyL+6ngG3u+5GS5VSa9Ch0MKC/3aDOGGPtRX9uLo5ktv8TPgr+uFfwZN+KDywlhZIk+TcHrxw1
 OgXKrk/UEWGIpkPi6eZwqbgcCtzVBalYiZzLMQ2tEOSFK+UD+9YBEIYaJeJks8HSUmzkEdU6wR
 L9c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jan 2023 21:13:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Ny9l70qygz1RvTr
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 21:13:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674105218; x=1676697219; bh=2Zup8f9kJXZ4saeKKXXVCwsH44jxdhWnca7
        /TJrUBzA=; b=N4bP7ytVM2gj4+T8AvS04Ci199p778d9gRicM5q2E3ZFpzH3L7f
        Ko3Ng9mVwh5340LKZhfZGJ6xfJob9Ee++Vzn8z/Ex4WFdAk9X2baG+QJF/W+Y9Fa
        xq0dMCp06D3OTyfEhH2jgBIWaTDbW51iIVS8rA52zJ5UGBXvvuQ94n51V5c0tES9
        0mUMHykZZkrfvHB4kpkOmTK5B7uuUGoGQ0dojwYLpk4TkKCCP4RL9MXtvwmHkycA
        ubyxzegj+yTTpTksOm/DQE8ZFhCPM7JORkxfEHk3kginuzGc+etXVJKMPv1dmRbL
        bDlu+pY1pM5bMMcCtqLXrQWXonB2Vtl7WIQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Rs3wYdLFbSTw for <linux-xfs@vger.kernel.org>;
        Wed, 18 Jan 2023 21:13:38 -0800 (PST)
Received: from [10.89.84.31] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.84.31])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Ny9l54xkMz1RvLy;
        Wed, 18 Jan 2023 21:13:37 -0800 (PST)
Message-ID: <29f91612-bcb7-e9a7-ec14-b89efe455b1f@opensource.wdc.com>
Date:   Thu, 19 Jan 2023 14:13:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: Lockdep splat with xfs
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>, kasan-dev@googlegroups.com,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
References: <f9ff999a-e170-b66b-7caf-293f2b147ac2@opensource.wdc.com>
 <20230119045253.GI360264@dread.disaster.area>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230119045253.GI360264@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023/01/19 13:52, Dave Chinner wrote:
> It's a false positive, and the allocation context it comes from
> in XFS is documented as needing to avoid lockdep tracking because
> this path is know to trigger false positive memory reclaim recursion
> reports:
> 
>         if (!args->value) {
>                 args->value = kvmalloc(valuelen, GFP_KERNEL | __GFP_NOLOCKDEP);
>                 if (!args->value)
>                         return -ENOMEM;
>         }
>         args->valuelen = valuelen;
> 
> 
> XFS is telling the allocator not to track this allocation with
> lockdep, and that is getting passed down through the allocator which
> has not passed it to lockdep (correct behaviour!), but then KASAN is
> trying to track the allocation and that needs to do a memory
> allocation.  __stack_depot_save() is passed the gfp mask from the
> allocation context so it has __GFP_NOLOCKDEP right there, but it
> does:
> 
>         if (unlikely(can_alloc && !smp_load_acquire(&next_slab_inited))) {
>                 /*
>                  * Zero out zone modifiers, as we don't have specific zone
>                  * requirements. Keep the flags related to allocation in atomic
>                  * contexts and I/O.
>                  */
>                 alloc_flags &= ~GFP_ZONEMASK;
>>>>>>>>         alloc_flags &= (GFP_ATOMIC | GFP_KERNEL);
>                 alloc_flags |= __GFP_NOWARN;
>                 page = alloc_pages(alloc_flags, STACK_ALLOC_ORDER);
> 
> It masks masks out anything other than GFP_ATOMIC and GFP_KERNEL
> related flags. This drops __GFP_NOLOCKDEP on the floor, hence
> lockdep tracks an allocation in a context we've explicitly said not
> to track. Hence lockdep (correctly!) explodes later when the
> false positive "lock inode in reclaim context" situation triggers.
> 
> This is a KASAN bug. It should not be dropping __GFP_NOLOCKDEP from
> the allocation context flags.

OK. Thanks for the explanation !

-- 
Damien Le Moal
Western Digital Research

