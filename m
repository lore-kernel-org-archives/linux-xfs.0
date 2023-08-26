Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD48FC83F11
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Aug 2023 14:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjHZOnb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Aug 2023 10:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjHZOnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Aug 2023 10:43:12 -0400
Received: from smtp-outbound7.duck.com (smtp-outbound7.duck.com [20.67.222.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE81E4E
        for <linux-xfs@vger.kernel.org>; Sat, 26 Aug 2023 07:43:09 -0700 (PDT)
MIME-Version: 1.0
Subject: Re: Moving existing internal journal log to an external device
 (success?)
References: <E4E991B0-4CAA-4E7A-9AC8-531346EDAEC4.1@smtp-inbound1.duck.com>
 <ZOKQTTxcanMX86Sx@dread.disaster.area>
 <B4C72D86-4CD6-415D-802E-7A225C868E57.1@smtp-inbound1.duck.com>
 <4F83C26B-1841-440B-8A51-0F2BD1EFC825.1@smtp-inbound1.duck.com>
 <26eb469b-89dc-79c7-3d39-2a0e61a9632f@sandeen.net>
 <21DD2F1E-AAB5-48BC-8C9F-7A9A07F3F81C.1@smtp-inbound1.duck.com>
Content-Type: text/plain;
        charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7bit
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Received: by smtp-inbound1.duck.com; Sat, 26 Aug 2023 10:43:08 -0400
Message-ID: <4DD03DA0-3770-46BC-B0F8-0B2BD4363F07.1@smtp-inbound1.duck.com>
Date:   Sat, 26 Aug 2023 10:43:08 -0400
From:   fk1xdcio@duck.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duck.com; h=From:
 Date: Message-ID: Cc: To: Content-Transfer-Encoding: Content-Type:
 References: Subject: MIME-Version; q=dns/txt; s=postal-KpyQVw;
 t=1693060988; bh=ZDzGcZC3uHT8Yo8EmW1UwjnKqTla4y0UL7GqmRXwhbo=;
 b=G+UpsgWpVCyrOgODSnLm5AgK/G8E33agaxljojGCjnfAVxPIlZZHyn5QFfkMxxmXNCGoyFySm
 7xQ5ypvC8ICypLb7Yyh3NpsYobl3TY2Rq9gObq411zG8PzYjEPbm/1wDXg2zGPI81VBYyi/iHn9
 j+tpIhUKf9X/fE//1n4TA/I=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-08-24 16:22, Eric Sandeen wrote:
> On 8/21/23 8:07 AM, fk1xdcio@duck.com wrote:
>> Yes, I understand. I was thinking more of an offline utility for doing
>> this but I see why that can't be done in growfs.
>> 
>> So I guess it doesn't really work. This is why I ask the experts. I'll
>> keep experimenting because due to the requirements of needing to
>> physically move disks around, being able to move the log back and 
>> forth
>> from internal to external would be extremely helpful.
>> 
>> Thanks!
> 
> Just out of curiosity, what is your use case? Why do you need/want to
> move logs around?

Every so often I rotate certain drives from production servers to 
semi-offline servers for testing and verification. The production 
servers have SSD for cache and the fast external journal but the testing 
servers do not. The testing servers need to be able to test and verify 
the filesystem and do periodic synchronization/mirroring but obliviously 
can't use the original filesystem without the journal. Also some of 
these drives are moved offsite so being able to put the journal back to 
its internal position would simplify things.

Of course it would be possible to have extra drives in the testing 
environment that the logs could be moved to but the testing servers are 
very physically limited as to what can be hooked up to them so there 
really isn't enough room or ports for those extra drives. Plus the whole 
offsite thing.

It's more of a "want to help make life easier" than a hard requirement.
