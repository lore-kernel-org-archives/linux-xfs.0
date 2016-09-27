Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36120 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932674AbcI0PrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 11:47:00 -0400
Date: Tue, 27 Sep 2016 08:46:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS assertion during testing
Message-ID: <20160927154653.GQ9314@birch.djwong.org>
References: <20160927120309.GF1139@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160927120309.GF1139@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 27, 2016 at 02:03:09PM +0200, Jan Kara wrote:
> Hi,
> 
> I've hit the following assertion:
> 
> XFS: Assertion failed: dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count),
> file: fs/xfs/xfs_dir2_readdir.c, line: 87
> 
> during my testing. Now take this with a grain of salt since this is with my
> DAX patches applied on top of for-next branch of Dave's tree from
> yesterday. But I didn't touch XFS directory code even remotely which is why
> I'm reporting this.
> 
> The error happened while running xfstest xfs/083 on 20G ramdisk with dax
> enabled.

xfs/083 == "corrupt random stuff and see if anything notices" test,
which is why you get asserts in the directory code while testing DAX. :)

That assert probably ought to be:

if (dp->i_d.di_size < xfs_dir2_sf_hdr_size(sfp->i8count))
	return -EFSCORRUPTED;

--D

> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
