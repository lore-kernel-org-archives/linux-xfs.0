Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D97C7113B
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 20:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbjHXU3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 16:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243556AbjHXU3B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 16:29:01 -0400
X-Greylist: delayed 351 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Aug 2023 13:28:23 PDT
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 586671BD9
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 13:28:23 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 82BDE5CC13E;
        Thu, 24 Aug 2023 15:22:31 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 82BDE5CC13E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1692908551;
        bh=2mkWhLNte/8OQRQvy3qLV/nH+jASWAxSRn37L8h6Fho=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OR1648U8H+dQAB5q1T7xgCi0xDgMuNgPXx90VZ8CJa4ET6lW/63//bnWQyXuBru/+
         hJQmEEMrd6EkQLRJGWsfKSLuTZTBDklKAo1USKQKgbrJj8NHbQ80VdjjYUIYEw+2mS
         X4kF6IpesPnYZEL30c8y29xdA0e8W+kUuhm44eOCm/jUHLYWHqdpF2EOtl9Yjh4v2b
         2Fiq/nydmqMaG+c4YQjggBGP9xnLa4lQm/V+5P/PymTzzHqgb3GkQSv6QO5fNqRb6c
         9AvenQwOibpe/VtU5Qdr+EhFQBT8evhSoqTcnLEKIQTBAQoiVDQTf0jeuaIheohafu
         WPU3pISkwApCw==
Message-ID: <26eb469b-89dc-79c7-3d39-2a0e61a9632f@sandeen.net>
Date:   Thu, 24 Aug 2023 15:22:30 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: Moving existing internal journal log to an external device
 (success?)
Content-Language: en-US
To:     fk1xdcio@duck.com, Dave Chinner <david@fromorbit.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <E4E991B0-4CAA-4E7A-9AC8-531346EDAEC4.1@smtp-inbound1.duck.com>
 <ZOKQTTxcanMX86Sx@dread.disaster.area>
 <B4C72D86-4CD6-415D-802E-7A225C868E57.1@smtp-inbound1.duck.com>
 <4F83C26B-1841-440B-8A51-0F2BD1EFC825.1@smtp-inbound1.duck.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <4F83C26B-1841-440B-8A51-0F2BD1EFC825.1@smtp-inbound1.duck.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/21/23 8:07 AM, fk1xdcio@duck.com wrote:
>>> *IF* this works, why can't xfs_growfs do it?
>>
>> "Doctor, I can perform an amputation with a tornique and a chainsaw,
>> why can't you do that?"
>> ,,,
>> -Dave.
> 
> 
> Yes, I understand. I was thinking more of an offline utility for doing
> this but I see why that can't be done in growfs.
> 
> So I guess it doesn't really work. This is why I ask the experts. I'll
> keep experimenting because due to the requirements of needing to
> physically move disks around, being able to move the log back and forth
> from internal to external would be extremely helpful.
> 
> Thanks!

Just out of curiosity, what is your use case? Why do you need/want to
move logs around?

-Eric
