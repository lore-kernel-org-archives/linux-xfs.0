Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42212 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdAKHug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 02:50:36 -0500
Date: Tue, 10 Jan 2017 23:50:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7 5/6] xfs: sanity check inode mode when creating new
 dentry
Message-ID: <20170111075027.GR14038@birch.djwong.org>
References: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
 <1484062757-12433-6-git-send-email-amir73il@gmail.com>
 <20170110231550.GO14038@birch.djwong.org>
 <CAOQ4uxjcasRkSK0f5OpY5Qtc0iB6uxP5e=XWytSyQM5ni6m2Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjcasRkSK0f5OpY5Qtc0iB6uxP5e=XWytSyQM5ni6m2Ow@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 07:08:57AM +0200, Amir Goldstein wrote:
> On Wed, Jan 11, 2017 at 1:15 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > On Tue, Jan 10, 2017 at 05:39:16PM +0200, Amir Goldstein wrote:
> >> The helper xfs_dentry_to_name() is used by 2 different
> >> classes of callers: Callers that pass zero mode and don't care
> >> about the returned name.type field and Callers that pass
> >> non zero mode and do care about the name.type field.
> >>
> >> Change xfs_dentry_to_name() to not take the mode argument and
> >> change the call sites of the first class to not pass the mode
> >> argument.
> >>
> >> Create a new helper xfs_dentry_mode_to_name() which does pass
> >> the mode argument and returns -EFSCORRUPTED if mode is invalid.
> >> Callers that translate non zero mode to on-disk file type now
> >> check the return value and will export the error to user instead
> >> of staging an invalid file type to be written to directory entry.
> >>
> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> ...
> >>
> >>       mode = S_IFLNK |
> >>               (irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
> >> -     xfs_dentry_to_name(&name, dentry, mode);
> >> +     error = xfs_dentry_mode_to_name(&name, dentry, mode);
> >> +     ASSERT(error == 0);
> >
> > Why not the usual 'if (error) goto out;' here?
> >
> 
> Because mode here is not coming from disk, nor from user input,
> so an error from converting S_IFLNK would be a programming bug.
> We could also ignore the return value in this case, let me know if you
> prefer that.

Nah, it's just eyebrow-raising since it's a deviation from the usual
paradigm.

> BTW, process question. Do you need me to re-send patched with
> your Reviewed-by, or will you add those when applying?

In general I plan to pull the most recent patch mail and add whatever
tags come in as replies, so if you resend a patch please add the tags
yourself.

--D

> 
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
