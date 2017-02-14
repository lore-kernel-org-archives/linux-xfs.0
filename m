Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43108 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750716AbdBNG1h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 01:27:37 -0500
Message-ID: <1487053651.3125.72.camel@HansenPartnership.com>
Subject: Re: xfs: fix inode uid/gid initialization
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 13 Feb 2017 22:27:31 -0800
In-Reply-To: <20170214060809.GA21114@infradead.org>
References: <1487008001.3125.41.camel@HansenPartnership.com>
         <20170213194337.GA9852@infradead.org> <20170213213416.GA15349@dastard>
         <20170214060809.GA21114@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

On Mon, 2017-02-13 at 22:08 -0800, Christoph Hellwig wrote:
> On Tue, Feb 14, 2017 at 08:34:16AM +1100, Dave Chinner wrote:
> > >  
> > > -	if (pip && XFS_INHERIT_GID(pip)) {
> > > -		ip->i_d.di_gid = pip->i_d.di_gid;
> > > -		if ((VFS_I(pip)->i_mode & S_ISGID) &&
> > > S_ISDIR(mode))
> > > -			inode->i_mode |= S_ISGID;
> > > -	}
> > > -
> > 
> > Doesn't this hunk break the "nogrpid" mount option?
> 
> It does.

OK, so I'll fix up the s_user_mount problems and I'll let you sort out
the internals of removing the di_uid/gid if you wish to.  I checked the
quota code and I think there are only a couple of places you're using
the kernel view of the ids where you should be using the filesystem
view.  They're all identified by current_fsuid/fsgid(), so I think
(with the helper in patch 1) that this is the fix.

James

