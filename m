Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62DDC2BB55
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C37FC20936
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 12:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370500AbgDOMv4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:51:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:34220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370492AbgDOMvv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Apr 2020 08:51:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 27143AC11;
        Wed, 15 Apr 2020 12:51:49 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id DE49C1E1250; Wed, 15 Apr 2020 14:51:47 +0200 (CEST)
Date:   Wed, 15 Apr 2020 14:51:47 +0200
From:   Jan Kara <jack@suse.cz>
To:     ira.weiny@intel.com
Cc:     linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jeff Moyer <jmoyer@redhat.com>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 5/8] fs/ext4: Make DAX mount option a tri-state
Message-ID: <20200415125147.GH6126@quack2.suse.cz>
References: <20200414040030.1802884-1-ira.weiny@intel.com>
 <20200414040030.1802884-6-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414040030.1802884-6-ira.weiny@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon 13-04-20 21:00:27, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> We add 'always', 'never', and 'inode' (default).  '-o dax' continue to
> operate the same.
> 
> Specifically we introduce a 2nd DAX mount flag EXT4_MOUNT_NODAX and set
> it and EXT4_MOUNT_DAX appropriately.
> 
> We also force EXT4_MOUNT_NODAX if !CONFIG_FS_DAX.
> 
> https://lore.kernel.org/lkml/20200405061945.GA94792@iweiny-DESK2.sc.intel.com/
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

...

> @@ -2303,6 +2325,13 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
>  	if (DUMMY_ENCRYPTION_ENABLED(sbi))
>  		SEQ_OPTS_PUTS("test_dummy_encryption");
>  
> +	if (test_opt2(sb, NODAX))
> +		SEQ_OPTS_PUTS("dax=never");
> +	else if (test_opt(sb, DAX))
> +		SEQ_OPTS_PUTS("dax=always");
> +	else
> +		SEQ_OPTS_PUTS("dax=inode");
> +

We try to show only mount options that were explicitely set by the user, or
that are different from defaults - e.g., see how 'data=' mount option
printing is handled.

>  	ext4_show_quota_options(seq, sb);
>  	return 0;
>  }
> @@ -5424,6 +5453,12 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  		sbi->s_mount_opt ^= EXT4_MOUNT_DAX;
>  	}
>  
> +	if ((sbi->s_mount_opt2 ^ old_opts.s_mount_opt2) & EXT4_MOUNT2_NODAX) {
> +		ext4_msg(sb, KERN_WARNING, "warning: refusing change of "
> +			"non-dax flag with busy inodes while remounting");
> +		sbi->s_mount_opt2 ^= EXT4_MOUNT2_NODAX;
> +	}
> +
>  	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
>  		ext4_abort(sb, "Abort forced by user");

I'd just merge this with the check whether EXT4_MOUNT_DAX changed.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
