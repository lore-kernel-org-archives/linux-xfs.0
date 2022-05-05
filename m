Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F020C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 19:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350244AbiEETbv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 15:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239924AbiEETbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 15:31:50 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F13C54BF8
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 12:28:09 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 25015328A0C;
        Thu,  5 May 2022 14:27:34 -0500 (CDT)
Message-ID: <1200d52d-c445-9bdb-cf53-24c9b83f0c2f@sandeen.net>
Date:   Thu, 5 May 2022 14:28:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
 <165176664529.246897.6962083531265042879.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs_scrub: move to mallinfo2 when available
In-Reply-To: <165176664529.246897.6962083531265042879.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/5/22 11:04 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting with glibc 2.35, the mallinfo library call has finally been
> upgraded to return 64-bit memory usage quantities.  Migrate to the new
> call, since it also warns about mallinfo being deprecated.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Seems fine. Turning into a fair bit of code for an informational message,
do you really need it? ;)

Anyway, looks like it fixes the warning, thanks!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


