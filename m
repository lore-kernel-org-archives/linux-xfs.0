Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F130EB64DA
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 15:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjFZPcK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 11:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjFZPcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 11:32:08 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EC5A10F4
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 08:32:05 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4E26F5CCFF2;
        Mon, 26 Jun 2023 10:32:04 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 4E26F5CCFF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1687793524;
        bh=1KghhYlNQjsvXLGCu4RTUOv9HcoehHUiCFl46JWRexc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NWFwDCHLFZ5mdAqqqkZ0WLyPpcTWSskFlINI6/z5bTn77DcMU874iSkFnMFS+qRd2
         MVU0vKYNVWKA9PPr9xCXxsLUqEgeW2oggrEebo5d4qKPNYZwOL9FJNLS9JOtt1pS/w
         23OuxzGoNK/Fy2ybSdhBmuw/0o9OLPqFMS4UjOLDg1QDTTBhCwLJKBRcvJ3TS0zWZS
         o3XoH1rtI7MAVqkvC9RN6x0Xl1RdtGcnSAqjmMPzQYuXuoghZI5g59k7o0SgyvjRA0
         I8nsHy8H3Wh+U/TZdTsETMkP/mvXDMO/mJRmHD+kuVJaGLEb0ljP1ukuIUVTVqJx7N
         mgOUANaysG24A==
Message-ID: <3f604849-877b-f519-8cae-4694c82ac7e4@sandeen.net>
Date:   Mon, 26 Jun 2023 10:32:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: Question on slow fallocate
Content-Language: en-US
To:     Masahiko Sawada <sawada.mshk@gmail.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
 <ZJTrrwirZqykiVxn@dread.disaster.area>
 <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAD21AoC9=8Q2o3-+ueuP05+8298z--5vgBWtvSxMHHF2jdyr_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/25/23 10:17 PM, Masahiko Sawada wrote:
> FYI, to share the background of what PostgreSQL does, when
> bulk-insertions into one table are running concurrently, one process
> extends the underlying files depending on how many concurrent
> processes are waiting to extend. The more processes wait, the more 8kB
> blocks are appended. As the current implementation, if the process
> needs to extend the table by more than 8 blocks (i.e. 64kB) it uses
> posix_fallocate(), otherwise it uses pwrites() (see the code[1] for
> details). We don't use fallocate() for small extensions as it's slow
> on some filesystems. Therefore, if a bulk-insertion process tries to
> extend the table by say 5~10 blocks many times, it could use
> poxis_fallocate() and pwrite() alternatively, which led to the slow
> performance as I reported.

To what end? What problem is PostgreSQL trying to solve with this 
scheme? I might be missing something but it seems like you've described 
the "what" in detail, but no "why."

-Eric
