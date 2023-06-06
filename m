Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154CAC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 00:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjFFAiw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 20:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjFFAiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 20:38:51 -0400
X-Greylist: delayed 402 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 17:38:48 PDT
Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C461310E
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 17:38:48 -0700 (PDT)
Date:   Mon, 5 Jun 2023 17:31:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686011522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xFxQoxys/4W09oOn79IrUnlR3rRwAPSSelAzub4DB3w=;
        b=GYrJ2HdSX3TJoTTxPDFkm2BYLmg+7hl/gvwOi01e4oASj1BbnqDK7qwyHcvL6fJ/DORzXc
        eFEH9oIjheaYl2N4nSF6/5HcGLZd1A0fCZQFeeh3w+9qe2j/ZdHFiq8CiAqMdCrXPTFYV6
        wr5AogFPjClIdSqmxJBsaSWiXGHZKRo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     akpm@linux-foundation.org, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, djwong@kernel.org, hughd@google.com,
        paulmck@kernel.org, muchun.song@linux.dev, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengqi.arch@bytedance.com,
        david@fromorbit.com
Subject: Re: [PATCH v2 1/3] mm: vmscan: move shrinker_debugfs_remove() before
 synchronize_srcu()
Message-ID: <ZH5+fHJj8UypQfIt@P9FQF9L96D>
References: <168599103578.70911.9402374667983518835.stgit@pro.pro>
 <168599178203.70911.18350742045278218790.stgit@pro.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168599178203.70911.18350742045278218790.stgit@pro.pro>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 10:03:02PM +0300, Kirill Tkhai wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The debugfs_remove_recursive() will wait for debugfs_file_put()
> to return, so there is no need to put it after synchronize_srcu()
> to wait for the rcu read-side critical section to exit.
> 
> Just move it before synchronize_srcu(), which is also convenient
> to put the heavy synchronize_srcu() in the delayed work later.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
