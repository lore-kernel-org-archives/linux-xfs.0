Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43729 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935681AbcI0QxE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 12:53:04 -0400
Date: Tue, 27 Sep 2016 18:52:53 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: XFS assertion during testing
Message-ID: <20160927165253.GA19586@quack2.suse.cz>
References: <20160927120309.GF1139@quack2.suse.cz>
 <20160927154653.GQ9314@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160927154653.GQ9314@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org

On Tue 27-09-16 08:46:53, Darrick J. Wong wrote:
> On Tue, Sep 27, 2016 at 02:03:09PM +0200, Jan Kara wrote:
> > Hi,
> > 
> > I've hit the following assertion:
> > 
> > XFS: Assertion failed: dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count),
> > file: fs/xfs/xfs_dir2_readdir.c, line: 87
> > 
> > during my testing. Now take this with a grain of salt since this is with my
> > DAX patches applied on top of for-next branch of Dave's tree from
> > yesterday. But I didn't touch XFS directory code even remotely which is why
> > I'm reporting this.
> > 
> > The error happened while running xfstest xfs/083 on 20G ramdisk with dax
> > enabled.
> 
> xfs/083 == "corrupt random stuff and see if anything notices" test,
> which is why you get asserts in the directory code while testing DAX. :)

Yeah, I just figured out it should not BUG, as it basically took down the
machine (due to bugging when holding locks...) and that's impractical even
for debugging runs.

> That assert probably ought to be:
> 
> if (dp->i_d.di_size < xfs_dir2_sf_hdr_size(sfp->i8count))
> 	return -EFSCORRUPTED;

Yeah, that would have been nice ;)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
