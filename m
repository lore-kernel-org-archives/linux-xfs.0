Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56996 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbeEJUsN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 16:48:13 -0400
Date: Thu, 10 May 2018 21:48:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] vfs: skip extra attributes check on removal for symlinks
Message-ID: <20180510204807.GV30522@ZenIV.linux.org.uk>
References: <20180426234639.12480-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180426234639.12480-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, sandeen@sandeen.net, darrick.wong@oracle.com, dhowells@redhat.com, tytso@mit.edu, fliu@suse.com, jack@suse.cz, jeffm@suse.com, nborisov@suse.com, jake.norris@suse.com, mtk.manpages@gmail.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 26, 2018 at 04:46:39PM -0700, Luis R. Rodriguez wrote:

> Since we cannot set these attributes we should special-case the
> immutable/append on delete for symlinks, this would be consistent with
> what we *do* allow on Linux for all filesystems.

Er...  So why not simply sanity-check it in places that set it on
inodes?  If anything, I would suggest
	* converting all places that set those in ->i_flags to
inode_set_flags()
	* making inode_set_flags() check and return an error on
that...
