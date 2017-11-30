Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752373AbdK3RNO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 12:13:14 -0500
Date: Thu, 30 Nov 2017 18:13:10 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/11] fs: add frozen sb state helpers
Message-ID: <20171130171310.GG28180@quack2.suse.cz>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171129232356.28296-4-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 29-11-17 15:23:48, Luis R. Rodriguez wrote:
> The question of whether or not a superblock is frozen needs to be
> augmented in the future to account for differences between a user
> initiated freeze and a kernel initiated freeze done automatically
> on behalf of the kernel.
> 
> Provide helpers so that these can be used instead so that we don't
> have to expand checks later in these same call sites as we expand
> the definition of a frozen superblock.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

So helpers are fine but...

> +/**
> + * sb_is_frozen_by_user - is superblock frozen by a user call
> + * @sb: the super to check
> + *
> + * Returns true if the super freeze was initiated by userspace, for instance,
> + * an ioctl call.
> + */
> +static inline bool sb_is_frozen_by_user(struct super_block *sb)
> +{
> +	return sb->s_writers.frozen == SB_FREEZE_COMPLETE;
> +}

... I dislike the _by_user() suffix as there may be different places that
call freeze_super() (e.g. device mapper does this during some operations).
Clearly we need to distinguish "by system suspend" and "the other" cases.
So please make this clear in the naming.

In fact, what might be a cleaner solution is to introduce a 'freeze_count'
for superblock freezing (we already do have this for block devices). Then
you don't need to differentiate these two cases - but you'd still need to
properly handle cleanup if freezing of all superblocks fails in the middle.
So I'm not 100% this works out nicely in the end. But it's certainly worth
a consideration.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
