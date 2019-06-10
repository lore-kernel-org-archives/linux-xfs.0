Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37493 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387499AbfFJD6j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jun 2019 23:58:39 -0400
Date: Sun, 9 Jun 2019 23:58:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 3/6] generic: copy_file_range swapfile test
Message-ID: <20190610035829.GA18429@mit.edu>
References: <20190602124114.26810-1-amir73il@gmail.com>
 <20190602124114.26810-4-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190602124114.26810-4-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Jun 02, 2019 at 03:41:11PM +0300, Amir Goldstein wrote:
> This test case was split out of Dave Chinner's copy_file_range bounds
> check test to reduce the requirements for running the bounds check.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

I've just updated to the latest fstests, where this has landed as
generic/554.  This test is failing on ext4, and should fail on all
file systems which do not support copy_file_range (ext4, nfsv3, etc.),
since xfs_io will fall back to emulating this via reading and writing
the file, and this causes a test failure because:

> +echo swap files return ETXTBUSY
> +_format_swapfile $testdir/swapfile 16m
> +swapon $testdir/swapfile
> +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/file" $testdir/swapfile
> +$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/swapfile" $testdir/copy
> +swapoff $testdir/swapfile

Currently, the VFS doesn't prevent us from reading a swap file.
Perhaps it shouldn't, for security (theatre) reasons, but root can
read the raw block device anyway, so it's really kind of pointless.

I'm not sure what's the best way fix this, but I'm going to exclude
this test in my test appliance builds for now.

     	     	     	       	      	  - Ted
