Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59474 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfF1GA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 02:00:29 -0400
Date: Fri, 28 Jun 2019 07:00:27 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC] dget_parent() misuse in xfs_filestream_get_parent()
Message-ID: <20190628060026.GR17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

	dget_parent() never returns NULL.  So this

        parent = dget_parent(dentry);
        if (!parent)
                goto out_dput;

        dir = igrab(d_inode(parent));
        dput(parent);

out_dput:

is obviously fishy.  What is that code trying to do?  Is that
"dentry might be a root of disconnected tree, in which case
we want xfs_filestream_get_parent() to return NULL"?  If so,
that should be

        parent = dget_parent(dentry);
        if (parent != dentry)
		dir = igrab(d_inode(parent));
        dput(parent);

If we want dentry itself, that dir = igrab(...) should be
unconditional.  I'm not familiar enough with that code,
and I'd rather not go into YAMassiveSideRTFS, so...
