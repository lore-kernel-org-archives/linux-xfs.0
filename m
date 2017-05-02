Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36859 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbdEBHaV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 May 2017 03:30:21 -0400
Date: Tue, 2 May 2017 09:30:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: publish UUID in struct super_block
Message-ID: <20170502073019.GD11582@lst.de>
References: <1493388001-15879-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493388001-15879-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Apr 28, 2017 at 05:00:01PM +0300, Amir Goldstein wrote:
> Copy the uuid of the filesystem to struct super_block s_uuid field,
> as several other filesystems already do.  Copy regardless of the nouuid
> mount option, because other filesystems also do not guaranty uniqueness
> of the s_uuid field in super_block struct.

No guaranteeing uniqueness will create problems, don't do that.

Other file system didn't use to do the uuid table check that XFS did
either, and that's a fatal bug.  In the long run we'll need to move
this check to the VFS now that we have s_uuid.

Also while checking for a nul uuid is probably ok we need to formalize
that at least that the check is needed.  Preferably by adding a little
inline helper for it, and documenting it.
