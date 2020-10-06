Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED340C41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 14:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9639C20789
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 14:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJFOrw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 10:47:52 -0400
Received: from sandeen.net ([63.231.237.45]:39552 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgJFOrw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 10:47:52 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0842048C688;
        Tue,  6 Oct 2020 09:46:54 -0500 (CDT)
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201006100149.32740-1-ailiop@suse.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_repair: remove obsolete code for handling mountpoint
 inodes
Message-ID: <243d4aaa-8386-b42d-2db8-64c7f4af43eb@sandeen.net>
Date:   Tue, 6 Oct 2020 09:47:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201006100149.32740-1-ailiop@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/6/20 5:01 AM, Anthony Iliopoulos wrote:
> The S_IFMNT file type was never supported in Linux, remove the related
> code that was supposed to deal with it, along with the translation file
> entries.

> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Seems fine.

Fun fact, this was /almost/ all removed way back in 2003 ;)

-#define        IFMNT           0160000         /* mount point */

...

-       case IFMNT:
-               type = XR_INO_MOUNTPOINT;
-               break;

I don't think there's any point to a Fixes: tag here though ;)

Thanks,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>



