Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEE9C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 16:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 882FB64F44
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Mar 2021 16:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhCQQp1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Mar 2021 12:45:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232500AbhCQQo4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 12:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615999496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SvOT8hmfQkby6h8ydbTJCreK1fJr5AsuRnmrMdRm2c4=;
        b=BVWcx9Jtvz5I+yNskVoXCcKu2v+1GiGp16qObbXZEcpe+cZ1QFGouyAW1rgTebZgxflMDD
        0o0E+yb2aoU2NYHjsEK26769oLM5wUwKBupsFnbiByeaL+PKA4Lqk3MCaW/dyHlqGM9PkB
        E9hlqdyHmX1LpD9E1Rcj6f/xcUKMPOU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-HG9fx6XcPUGjc4WtsTeKkQ-1; Wed, 17 Mar 2021 12:44:54 -0400
X-MC-Unique: HG9fx6XcPUGjc4WtsTeKkQ-1
Received: by mail-pl1-f197.google.com with SMTP id x7so20646589plg.18
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 09:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SvOT8hmfQkby6h8ydbTJCreK1fJr5AsuRnmrMdRm2c4=;
        b=kzG+KpaP26vOrNKROwgXmdmDorTtxGemji8on2aSw0lFUm7YCKBT++eOQsxJdWEP/k
         9mr05GiIbpxB7H2Uin+blwCCYdQzIdKfzJGsnYatgcvL3N6aRdp/AGo1xQOLmlHieESp
         /JRNyuhMEy+8JB9gNajmQYiRR5CtFn8nd4h7uusdTXoMNGQcxzsFMpBM58S93gJI16Cr
         +t+Ey/0cbSukkbU7rrxbiwBUUT367q9XQca1V/UaqRpH9HC0DHvGHmSrT4esbChwuMus
         9p+/G3J11qPI4RJF19K9gMUgUvdOg3xFoxnhzgRvgLbarCqEfs7In0DZwWxIBnuq0qm7
         1hEg==
X-Gm-Message-State: AOAM533GcaETLwO0swl6NAmffgzimX6w5K8Wia/dFdbhW4cP/RTYo3Ls
        3jEeQ/LQx7L9WczIU3ck1caTp1mfCE+djRU6krPzVnfZcle8FntKlXcRYO2dzZf4VGvzvJu0Gc/
        68BSLuaHHLKvVKi2ZVlQE
X-Received: by 2002:a63:2c8f:: with SMTP id s137mr3300415pgs.51.1615999493496;
        Wed, 17 Mar 2021 09:44:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkC9PmpQzSAKPR879/hzn0lghkRM8Syp7CfQq9V+rk05YhLFlJzTUDDUx+LgICx+47vqgqCA==
X-Received: by 2002:a63:2c8f:: with SMTP id s137mr3300375pgs.51.1615999492802;
        Wed, 17 Mar 2021 09:44:52 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 68sm20334639pfd.75.2021.03.17.09.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:44:52 -0700 (PDT)
Date:   Thu, 18 Mar 2021 00:44:42 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: initialise attr fork on inode create
Message-ID: <20210317164442.GA1207630@xiangao.remote.csb>
References: <20210317045706.651306-1-david@fromorbit.com>
 <20210317045706.651306-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210317045706.651306-2-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 17, 2021 at 03:56:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we allocate a new inode, we often need to add an attribute to
> the inode as part of the create. This can happen as a result of
> needing to add default ACLs or security labels before the inode is
> made visible to userspace.
> 
> This is highly inefficient right now. We do the create transaction
> to allocate the inode, then we do an "add attr fork" transaction to
> modify the just created empty inode to set the inode fork offset to
> allow attributes to be stored, then we go and do the attribute
> creation.
> 
> This means 3 transactions instead of 1 to allocate an inode, and
> this greatly increases the load on the CIL commit code, resulting in
> excessive contention on the CIL spin locks and performance
> degradation:
> 
>  18.99%  [kernel]                [k] __pv_queued_spin_lock_slowpath
>   3.57%  [kernel]                [k] do_raw_spin_lock
>   2.51%  [kernel]                [k] __raw_callee_save___pv_queued_spin_unlock
>   2.48%  [kernel]                [k] memcpy
>   2.34%  [kernel]                [k] xfs_log_commit_cil
> 
> The typical profile resulting from running fsmark on a selinux enabled
> filesytem is adds this overhead to the create path:
> 
>   - 15.30% xfs_init_security
>      - 15.23% security_inode_init_security
> 	- 13.05% xfs_initxattrs
> 	   - 12.94% xfs_attr_set
> 	      - 6.75% xfs_bmap_add_attrfork
> 		 - 5.51% xfs_trans_commit
> 		    - 5.48% __xfs_trans_commit
> 		       - 5.35% xfs_log_commit_cil
> 			  - 3.86% _raw_spin_lock
> 			     - do_raw_spin_lock
> 				  __pv_queued_spin_lock_slowpath
> 		 - 0.70% xfs_trans_alloc
> 		      0.52% xfs_trans_reserve
> 	      - 5.41% xfs_attr_set_args
> 		 - 5.39% xfs_attr_set_shortform.constprop.0
> 		    - 4.46% xfs_trans_commit
> 		       - 4.46% __xfs_trans_commit
> 			  - 4.33% xfs_log_commit_cil
> 			     - 2.74% _raw_spin_lock
> 				- do_raw_spin_lock
> 				     __pv_queued_spin_lock_slowpath
> 			       0.60% xfs_inode_item_format
> 		      0.90% xfs_attr_try_sf_addname
> 	- 1.99% selinux_inode_init_security
> 	   - 1.02% security_sid_to_context_force
> 	      - 1.00% security_sid_to_context_core
> 		 - 0.92% sidtab_entry_to_string
> 		    - 0.90% sidtab_sid2str_get
> 			 0.59% sidtab_sid2str_put.part.0
> 	   - 0.82% selinux_determine_inode_label
> 	      - 0.77% security_transition_sid
> 		   0.70% security_compute_sid.part.0
> 
> And fsmark creation rate performance drops by ~25%. The key point to
> note here is that half the additional overhead comes from adding the
> attribute fork to the newly created inode. That's crazy, considering
> we can do this same thing at inode create time with a couple of
> lines of code and no extra overhead.
> 
> So, if we know we are going to add an attribute immediately after
> creating the inode, let's just initialise the attribute fork inside
> the create transaction and chop that whole chunk of code out of
> the create fast path. This completely removes the performance
> drop caused by enabling SELinux, and the profile looks like:
> 
>      - 8.99% xfs_init_security
>          - 9.00% security_inode_init_security
>             - 6.43% xfs_initxattrs
>                - 6.37% xfs_attr_set
>                   - 5.45% xfs_attr_set_args
>                      - 5.42% xfs_attr_set_shortform.constprop.0
>                         - 4.51% xfs_trans_commit
>                            - 4.54% __xfs_trans_commit
>                               - 4.59% xfs_log_commit_cil
>                                  - 2.67% _raw_spin_lock
>                                     - 3.28% do_raw_spin_lock
>                                          3.08% __pv_queued_spin_lock_slowpath
>                                    0.66% xfs_inode_item_format
>                         - 0.90% xfs_attr_try_sf_addname
>                   - 0.60% xfs_trans_alloc
>             - 2.35% selinux_inode_init_security
>                - 1.25% security_sid_to_context_force
>                   - 1.21% security_sid_to_context_core
>                      - 1.19% sidtab_entry_to_string
>                         - 1.20% sidtab_sid2str_get
>                            - 0.86% sidtab_sid2str_put.part.0
>                               - 0.62% _raw_spin_lock_irqsave
>                                  - 0.77% do_raw_spin_lock
>                                       __pv_queued_spin_lock_slowpath
>                - 0.84% selinux_determine_inode_label
>                   - 0.83% security_transition_sid
>                        0.86% security_compute_sid.part.0
> 
> Which indicates the XFS overhead of creating the selinux xattr has
> been halved. This doesn't fix the CIL lock contention problem, just
> means it's not a limiting factor for this workload. Lock contention
> in the security subsystems is going to be an issue soon, though...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me, although I've also noticed i_afp->if_format == 0
case, and checked the previous discussion about this as well:

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

