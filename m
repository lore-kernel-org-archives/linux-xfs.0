Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90107EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jun 2023 16:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjF0QME (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 12:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjF0QME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 12:12:04 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D13D12697
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 09:12:02 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 3A9F45CC129;
        Tue, 27 Jun 2023 11:12:02 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 3A9F45CC129
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1687882322;
        bh=F2Y5k95yxul+nOpqne00J5fL9V0Fdw0WfMBuLncPAE8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sFkmUiHXISxERXeTYnGFRFFbr5oufyVccjBtnnwbYltwouwMhfstZrBJJf82j4UYZ
         7YKoJdVNpUV6WYKi2QmOX2jqgqSWEAzEDNBJImUFJJlKK7/nv9QV+kp7b1cTPXWl35
         PBypEZ+h5hlABwxqMjJ7W/EifdgwAjKR7cl36LgOLuqsUEAkRN3eJ/azDUEAximinc
         D4lBJ70D1UnLECGk2sqjYtqqN9TepgpzT83AHMwx7nhNDN79zmVoPtEWaDou/ERNDz
         5y9pXO6btNFUwcVN6gEfxk3VA04PiOUrkznyIhy4K8bTCYZymoAjckLNTIu/P4QVcO
         8ziIDXalaEzEw==
Message-ID: <82b74cbc-8a1d-6b6f-fa2f-5f120d958dad@sandeen.net>
Date:   Tue, 27 Jun 2023 11:12:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: Question on slow fallocate
Content-Language: en-US
To:     Masahiko Sawada <sawada.mshk@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
 <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
 <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAD21AoBHd35HhFpbh9YBHPsLN+F_TZX5b47iy+-s44jPT+fyZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/27/23 10:50 AM, Masahiko Sawada wrote:
> On Tue, Jun 27, 2023 at 12:32 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> On 6/25/23 10:17 PM, Masahiko Sawada wrote:
>>> FYI, to share the background of what PostgreSQL does, when
>>> bulk-insertions into one table are running concurrently, one process
>>> extends the underlying files depending on how many concurrent
>>> processes are waiting to extend. The more processes wait, the more 8kB
>>> blocks are appended. As the current implementation, if the process
>>> needs to extend the table by more than 8 blocks (i.e. 64kB) it uses
>>> posix_fallocate(), otherwise it uses pwrites() (see the code[1] for
>>> details). We don't use fallocate() for small extensions as it's slow
>>> on some filesystems. Therefore, if a bulk-insertion process tries to
>>> extend the table by say 5~10 blocks many times, it could use
>>> poxis_fallocate() and pwrite() alternatively, which led to the slow
>>> performance as I reported.
>>
>> To what end? What problem is PostgreSQL trying to solve with this
>> scheme? I might be missing something but it seems like you've described
>> the "what" in detail, but no "why."
> 
> It's for better scalability. SInce the process who wants to extend the
> table needs to hold an exclusive lock on the table, we need to
> minimize the work while holding the lock.

Ok, but what is the reason for zeroing out the blocks prior to them 
being written with real data? I'm wondering what the core requirement 
here is for the zeroing, either via fallocate (which btw posix_fallocate 
does not guarantee) or pwrites of zeros.

Thanks,
-Eric
