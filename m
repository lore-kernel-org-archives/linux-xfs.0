Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42747 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752005AbeEMSVy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 May 2018 14:21:54 -0400
Date: Sun, 13 May 2018 18:21:52 +0000
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH 2/2] vfs: dedupe should return EPERM if permission is not
 granted
Message-ID: <20180513182152.GE27915@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180511192651.21324-1-mfasheh@suse.de>
 <20180511192651.21324-3-mfasheh@suse.de>
 <20180512000634.GG9510@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180512000634.GG9510@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, May 11, 2018 at 05:06:34PM -0700, Darrick J. Wong wrote:
> On Fri, May 11, 2018 at 12:26:51PM -0700, Mark Fasheh wrote:
> > Right now we return EINVAL if a process does not have permission to dedupe a
> > file. This was an oversight on my part. EPERM gives a true description of
> > the nature of our error, and EINVAL is already used for the case that the
> > filesystem does not support dedupe.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > ---
> >  fs/read_write.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 77986a2e2a3b..8edef43a182c 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -2038,7 +2038,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
> >  			info->status = -EINVAL;
> >  		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE) ||
> >  			     uid_eq(current_fsuid(), dst->i_uid))) {
> > -			info->status = -EINVAL;
> > +			info->status = -EPERM;
> 
> Hmm, are we allowed to change this aspect of the kabi after the fact?
> 
> Granted, we're only trading one error code for another, but will the
> existing users of this care?  xfs_io won't and I assume duperemove won't
> either, but what about bees? :)

Yeah if you see my initial e-mail I check bees and also rust-btrfs. I think
this is fine as we're simply expanding on an error code return. There's no
magic behavior expected with respect to these error codes either.
	--Mark
