Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932841AbcI0MDL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 08:03:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0B3ABABDE
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2016 12:03:10 +0000 (UTC)
Date: Tue, 27 Sep 2016 14:03:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: XFS assertion during testing
Message-ID: <20160927120309.GF1139@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I've hit the following assertion:

XFS: Assertion failed: dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count),
file: fs/xfs/xfs_dir2_readdir.c, line: 87

during my testing. Now take this with a grain of salt since this is with my
DAX patches applied on top of for-next branch of Dave's tree from
yesterday. But I didn't touch XFS directory code even remotely which is why
I'm reporting this.

The error happened while running xfstest xfs/083 on 20G ramdisk with dax
enabled.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
