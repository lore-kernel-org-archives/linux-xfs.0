Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E417CC04A94
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 02:31:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjHHCbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjHHCbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 22:31:48 -0400
Received: from out-72.mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1901BE3
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 19:31:36 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691461894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYMFGUKWQ+g0CyW9GTfXDcuOQANHVM/3Ghb9+ZBk468=;
        b=SxDNqxqUZNnRnBlh2G9KUWvivC/VvwTPU5/lDdc1G8r6XSCULCEnHFJghGF7/AiccY4oHl
        BBxN99+RbiiBoUusHHczSoq6/RgGM1N3zCJvlmXh3/z/H3OCVkCw+RxEiqw4cAM7WaU0dm
        eCamJhqdXamgXqX+92wkV8I/0pw0E38=
MIME-Version: 1.0
Subject: Re: [PATCH v4 06/48] binder: dynamically allocate the android-binder
 shrinker
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230807110936.21819-7-zhengqi.arch@bytedance.com>
Date:   Tue, 8 Aug 2023 10:30:45 +0800
Cc:     Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
        tkhai@ya.ru, Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, djwong@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        simon.horman@corigine.com, dlemoal@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <680D8CC2-114E-452F-9824-D6F59D917E84@linux.dev>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-7-zhengqi.arch@bytedance.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Aug 7, 2023, at 19:08, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
> 
> Use new APIs to dynamically allocate the android-binder shrinker.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>


