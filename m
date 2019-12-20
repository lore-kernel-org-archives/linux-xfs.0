Return-Path: <SRS0=kies=2K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4FCC2D0D2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 07:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DF88227BF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 07:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfLTHDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:03:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:41230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbfLTHDS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Dec 2019 02:03:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4D3B0AD85;
        Fri, 20 Dec 2019 07:03:16 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] zonefs: Add documentation
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Johannes Thumshirn <jth@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20191220065528.317947-1-damien.lemoal@wdc.com>
 <20191220065528.317947-3-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d79a0fd3-a7c9-e4d6-48f6-b0eca2712498@suse.de>
Date:   Fri, 20 Dec 2019 08:03:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191220065528.317947-3-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/20/19 7:55 AM, Damien Le Moal wrote:
> Add the new file Documentation/filesystems/zonefs.txt to document zonefs
> principles and user-space tool usage.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   Documentation/filesystems/zonefs.txt | 215 +++++++++++++++++++++++++++
>   MAINTAINERS                          |   1 +
>   2 files changed, 216 insertions(+)
>   create mode 100644 Documentation/filesystems/zonefs.txt
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
