Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60047 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752500AbeENPBB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 11:01:01 -0400
Date: Mon, 14 May 2018 16:58:20 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not
 granted
Message-ID: <20180514145820.GL6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-3-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511192651.21324-3-mfasheh@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 12:26:51PM -0700, Mark Fasheh wrote:
> Right now we return EINVAL if a process does not have permission to dedupe a
> file. This was an oversight on my part. EPERM gives a true description of
> the nature of our error, and EINVAL is already used for the case that the
> filesystem does not support dedupe.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>

Acked-by: David Sterba <dsterba@suse.com>

We've been using EINVAL when the request is invalid in the ioctls, eg.
combination of arguments that does not make sense, while EPERM is for
cases when the request is ok but there's still some permission missing,

>  		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
>  			     uid_eq(current_fsuid(), dst->i_uid))) {
> -			info->status = -EINVAL;
> +			info->status = -EPERM;

exactly like this.
