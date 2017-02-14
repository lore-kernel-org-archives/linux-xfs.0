Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52581 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdBNGIL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 01:08:11 -0500
Date: Mon, 13 Feb 2017 22:08:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: fix inode uid/gid initialization
Message-ID: <20170214060809.GA21114@infradead.org>
References: <1487008001.3125.41.camel@HansenPartnership.com>
 <20170213194337.GA9852@infradead.org>
 <20170213213416.GA15349@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170213213416.GA15349@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

On Tue, Feb 14, 2017 at 08:34:16AM +1100, Dave Chinner wrote:
> >  
> > -	if (pip && XFS_INHERIT_GID(pip)) {
> > -		ip->i_d.di_gid = pip->i_d.di_gid;
> > -		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
> > -			inode->i_mode |= S_ISGID;
> > -	}
> > -
> 
> Doesn't this hunk break the "nogrpid" mount option?

It does.
