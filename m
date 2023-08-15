Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C24CC04A94
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Aug 2023 08:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbjHOIhR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Aug 2023 04:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235684AbjHOIhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2023 04:37:12 -0400
Received: from out-3.mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B176E72
        for <linux-xfs@vger.kernel.org>; Tue, 15 Aug 2023 01:37:08 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692088626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uBmn5bY96EnmwKJFlv+WltFrhGvpjIbZEKIiYirKvRY=;
        b=vz0KHcPQmyiJWfmlN0KqRtShPV8OO94S7Ve+8NAyKaJzlfD3l3Gwdcs50vzwkyJwFeNk42
        wWmdUe83i5yu+zc+P73iwMyGZC6f36VMufdeZyZpMS2xcjecgpOeJWBucmjek3/RmzHbqM
        Esg+z/IvqlGN9dYsqiRnMi0+1ICkj/k=
MIME-Version: 1.0
Subject: Re: [PATCH v4 01/48] mm: move some shrinker-related function
 declarations to mm/internal.h
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230807110936.21819-2-zhengqi.arch@bytedance.com>
Date:   Tue, 15 Aug 2023 16:36:31 +0800
Cc:     Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
        tkhai@ya.ru, Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, djwong@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        yujie.liu@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        simon.horman@corigine.com, dlemoal@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, x86@kernel.org,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <FC3AE898-443D-4ACB-BCB4-0F8F2F48CDD0@linux.dev>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
 <20230807110936.21819-2-zhengqi.arch@bytedance.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Aug 7, 2023, at 19:08, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>=20
> The following functions are only used inside the mm subsystem, so it's
> better to move their declarations to the mm/internal.h file.
>=20
> 1. shrinker_debugfs_add()
> 2. shrinker_debugfs_detach()
> 3. shrinker_debugfs_remove()
>=20
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

One nit bellow.

[...]

> +
> +/*
> + * shrinker related functions
> + */

This is a multi-comment format. "/* shrinker related functions. */" is
the right one-line format of comment.

> +
> +#ifdef CONFIG_SHRINKER_DEBUG
> +extern int shrinker_debugfs_add(struct shrinker *shrinker);
> +extern struct dentry *shrinker_debugfs_detach(struct shrinker =
*shrinker,
> +      int *debugfs_id);
> +extern void shrinker_debugfs_remove(struct dentry *debugfs_entry,
> +    int debugfs_id);
> +#else /* CONFIG_SHRINKER_DEBUG */
> +static inline int shrinker_debugfs_add(struct shrinker *shrinker)
> +{
> +	return 0;
> +}
> +static inline struct dentry *shrinker_debugfs_detach(struct shrinker =
*shrinker,
> +     int *debugfs_id)
> +{
> +	*debugfs_id =3D -1;
> +	return NULL;
> +}
> +static inline void shrinker_debugfs_remove(struct dentry =
*debugfs_entry,
> +	int debugfs_id)
> +{
> +}
> +#endif /* CONFIG_SHRINKER_DEBUG */
> +
> #endif /* __MM_INTERNAL_H */
> --=20
> 2.30.2
>=20

