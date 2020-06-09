Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A744C433E1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 14:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 518B320737
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 14:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6dgbRC3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgFIOfg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 10:35:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47242 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726395AbgFIOff (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 10:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591713333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pp1NL9tzFSbdoaxqvZUeTVq9eLoiZsmRsJo4KG3lqBg=;
        b=E6dgbRC31CJyT+gpoR6jp+DodIASOz3LmX/+3zhRCYiIcfOZ5i3mZtrWDeow+j8n8O2Bs6
        lo26md6SmBD6GEYvkZFqH29DGQ1F4qa8jZzcQefvZ4JNU8cibA2Nq1B0hbxOU1a89tNCsO
        ZiptYQagOCslwb5zxwshbxWVXbTiCE0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-kCgV6oCJO0emBx1ksClgCg-1; Tue, 09 Jun 2020 10:35:32 -0400
X-MC-Unique: kCgV6oCJO0emBx1ksClgCg-1
Received: by mail-pf1-f197.google.com with SMTP id p18so16124215pfq.14
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 07:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pp1NL9tzFSbdoaxqvZUeTVq9eLoiZsmRsJo4KG3lqBg=;
        b=rpmoWEcVSDjVRWf5miCyxd8m5AAWjMRH9K7Yxq9Ecf+ZANBo+T1xBt7OqxUaLmfnOS
         8HuvlAMA3zbqAIo/drPzUWBIltsJfUJGrtGCgWtfh5Pl1YpNObKU2FtBTP2/LnqrTR7P
         gTQG19763hzxDJWOG8wjy0bIahK0QoJPyRcJbOb1eRk1gLQs78DbVWfkn+qBnljjfUyj
         cVCXe0wz4pSMInzmcVy9S9aFHrGKjYP8sB3wKF1fFe4XYTYCfOVVVPdeYnGOFrSVqtX3
         Az0eqb8mhFOcSLqRjhZiV8WW2GUxX1ZEi+dGIndIdFoORBZmZcVT50CU9d6caRJ/ys5L
         ZxjQ==
X-Gm-Message-State: AOAM5301ANTlxrcpKr/D64pbyGn0wjwRX9x7ivW6y8sBORNrgKhAeSh4
        nwMvkPSNrekKqFpq6X5k6TkFSsegfuxf6Fg/NUTC3xjqsALbizapCQ6jnoT0WgpPvW3rXbo0Ebj
        BnjrOaP2bhk+lYa1CPisz
X-Received: by 2002:a17:902:a60e:: with SMTP id u14mr3555232plq.176.1591713330824;
        Tue, 09 Jun 2020 07:35:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx94iPI4wUoBgPlYYh4qFPSMwH+Q0bNtGOeZ7OkQW+3w6ltcm9/s7G73vZQKOgKR4/8PkA5eg==
X-Received: by 2002:a17:902:a60e:: with SMTP id u14mr3555208plq.176.1591713330570;
        Tue, 09 Jun 2020 07:35:30 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d189sm10271353pfc.51.2020.06.09.07.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:35:29 -0700 (PDT)
Date:   Tue, 9 Jun 2020 22:35:20 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] xfs_repair: fix rebuilding btree node block less
 than minrecs
Message-ID: <20200609143520.GA22145@xiangao.remote.csb>
References: <20200609114053.31924-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609114053.31924-1-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 09, 2020 at 07:40:53PM +0800, Gao Xiang wrote:
> In production, we found that sometimes xfs_repair phase 5
> rebuilds freespace node block with pointers less than minrecs
> and if we trigger xfs_repair again it would report such
> the following message:
> 
> bad btree nrecs (39, min=40, max=80) in btbno block 0/7882
> 
> The background is that xfs_repair starts to rebuild AGFL
> after the freespace btree is settled in phase 5 so we may
> need to leave necessary room in advance for each btree
> leaves in order to avoid freespace btree split and then
> result in AGFL rebuild fails. The old mathematics uses
> ceil(num_extents / maxrecs) to decide the number of node
> blocks. That would be fine without leaving extra space
> since minrecs = maxrecs / 2 but if some slack was decreased
> from maxrecs, the result would be larger than what is
> expected and cause num_recs_pb less than minrecs, i.e:
> 
> num_extents = 79, adj_maxrecs = 80 - 2 (slack) = 78
> 
> so we'd get
> 
> num_blocks = ceil(79 / 78) = 2,
> num_recs_pb = 79 / 2 = 39, which is less than
> minrecs = 80 / 2 = 40
> 
> OTOH, btree bulk loading code behaves in a different way.
> As in xfs_btree_bload_level_geometry it wrote
> 
> num_blocks = floor(num_extents / maxrecs)
> 
> which will never go below minrecs. And when it goes
> above maxrecs, just increment num_blocks and recalculate
> so we can get the reasonable results.
> 
> In the long term, btree bulk loader will replace the current
> repair code as well as to resolve AGFL dependency issue.
> But we may still want to look for a backportable solution
> for stable versions. Hence, use the same logic to avoid the
> freespace btree minrecs underflow for now.
> 
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Eric Sandeen <sandeen@sandeen.net>
> Fixes: 9851fd79bfb1 ("repair: AGFL rebuild fails if btree split required")
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> not heavy tested yet..
> 
>  repair/phase5.c | 101 +++++++++++++++++++++---------------------------
>  1 file changed, 45 insertions(+), 56 deletions(-)
> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index abae8a08..997804a5 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -348,11 +348,29 @@ finish_cursor(bt_status_t *curs)
>   * failure at runtime. Hence leave a couple of records slack space in
>   * each block to allow immediate modification of the tree without
>   * requiring splits to be done.
> - *
> - * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
>   */
> -#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
> -	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
> +static void
> +compute_level_geometry(xfs_mount_t *mp, bt_stat_level_t *lptr,
> +		       uint64_t nr_this_level, bool leaf)
> +{
> +	unsigned int		maxrecs = mp->m_alloc_mxr[!leaf];
> +	int			slack = leaf ? 2 : 0;
> +	unsigned int		desired_npb;
> +
> +	desired_npb = max(mp->m_alloc_mnr[!leaf], maxrecs - slack);
> +	lptr->num_recs_tot = nr_this_level;
> +	lptr->num_blocks = max(1ULL, nr_this_level / desired_npb);
> +
> +	lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> +	lptr->modulo = nr_this_level % lptr->num_blocks;
> +	if (lptr->num_recs_pb > maxrecs || (lptr->num_recs_pb == maxrecs &&
> +			lptr->modulo)) {
> +		lptr->num_blocks++;
> +
> +		lptr->num_recs_pb = nr_this_level / lptr->num_blocks;
> +		lptr->modulo = nr_this_level % lptr->num_blocks;
> +	}
> +}

side note: alternatively, maybe we could also adjust (by decreasing)
           num_blocks and recalculate for the original approach.
           Although for both ways we could not make 2 extra leaves
           room for the above 79 of 80 case...

