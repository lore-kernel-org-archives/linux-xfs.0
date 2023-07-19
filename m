Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECADC001DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 20:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjGSUu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 16:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjGSUuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 16:50:25 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFE551FE6
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jul 2023 13:50:02 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 45052444F;
        Wed, 19 Jul 2023 15:50:00 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 45052444F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1689799800;
        bh=ZLZtUi+Yu5/AT5xDL7h4avlsHcTBQe8qy3DjvLQKKsY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ons7MMhSDv+WKYHzyIi4c3qh3/uCKYfEkRHeU/Rpkav2/le8oh4pFupWK/PZLVDtz
         EW8TVGzbYdLOXDLPaM7j4H4Rp1qsaLGfkj1HfIbSBx4bVf2qRAJRlxew69YGhh9guN
         ZkAHBYf8a4hoQxS7saOSuCQ7nyl/tKbMqlAQ569saH9noofe5Hxye+3pcjkac3tyUk
         fjxZUhYoes9WYw8HsENAYBgJZOboMCmZlIGvYEIBxr2xno8DxwitNUqQeqLBGS300Z
         zAz0p/zl8W1gMxGRoC7mAAUkmNB7bUWG6K0+LV5j7eaWhs3kqj2by0KwiHQhBqLecG
         H56f9MTBnzrFA==
Message-ID: <428ab767-98ef-9556-0942-686f41f72700@sandeen.net>
Date:   Wed, 19 Jul 2023 15:49:59 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: Question on slow fallocate
Content-Language: en-US
To:     sandeen@redhat.com, Andres Freund <andres@anarazel.de>,
        Dave Chinner <david@fromorbit.com>
Cc:     Masahiko Sawada <sawada.mshk@gmail.com>, linux-xfs@vger.kernel.org
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
 <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
 <20230711224911.yd3ns6qcrlepbptq@awork3.anarazel.de>
 <ZLeP8VwYuXGKYC/Z@dread.disaster.area>
 <20230719202917.qkgtvk43scl4rt2m@awork3.anarazel.de>
 <b630989d-1eb5-6285-6e22-9946de8e2ca5@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <b630989d-1eb5-6285-6e22-9946de8e2ca5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/19/23 3:38 PM, Eric Sandeen wrote:
> On 7/19/23 3:29 PM, Andres Freund wrote:
>> Somewhat tangential: I still would like a fallocate() option that 
>> actually
>> zeroes out new extents (via "write zeroes", if supported), rather than 
>> just
>> setting them up as unwritten extents. Nor for "data" files, but for
>> WAL/journal files.
> 
> Like this?
> 
> fallocate(2):
> 
>     Zeroing file space
>         Specifying  the  FALLOC_FL_ZERO_RANGE  flag  (available  since 
> Linux 3.15) in mode zeros space in the byte range starting at offset and 
> continuing for len bytes.
> 
> Under the covers, that uses efficient zeroing methods when available.
> 
> -Eric
> 

Hm sorry, it's been a while. Maybe I'm wrong about this; I know it does 
efficient zeroing when pointed at a block device but I guess I've 
confused myself about what happens on a filesystem like XFS that 
supports unwritten extents.

-Eric
