Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:51016 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753234AbdF2Saz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:55 -0400
Date: Thu, 29 Jun 2017 14:30:53 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] fs: ext4: inode->i_generation not assigned 0.
Message-ID: <20170629183053.GA4178@fieldses.org>
References: <c9f7090b2a58364998ad4a49cfdac379b905c7e9.1498687302.git.kkc6196@fb.com>
 <20A40B3C-E179-432B-B56F-BDAAF0CD2E1F@dilger.ca>
 <7CD38230-D961-428F-B2E9-2C0E28CAF442@fb.com>
 <20170629045940.GB5865@birch.djwong.org>
 <20170629143551.GB1651@fieldses.org>
 <20170629172528.GA5869@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170629172528.GA5869@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: William Koh <kkc6196@fb.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jun 29, 2017 at 10:25:28AM -0700, Darrick J. Wong wrote:
> Was there ever a version of NFS (or more generally callers of the
> exportfs code) that couldn't deal with i_generation in the file handle,
> and therefore we invented this generation hack to work around the loss
> of the generation information?
> 
> There's a comment in xfs_fs_encode_fh about not supporting 64bit inodes
> with subtree_check (which seems to require one ino/gen pair for the file
> and a second pair for the file's parent) on NFSv2 because v2 doesn't
> provide enough space for all the file handle information, but that's the
> furthest I got with lazy-mining the git history. :)

There's a comment in fs/ext4/super.c:ext4_nfs_get_inode

	* Currently we don't know the generation for parent directory, so
	* a generation of 0 means "accept any"

But I don't see that used.

It was used once upon a time; I see it actually used in old 2.5 code in
nfsd_get_dentry.  Hm.

--b.
