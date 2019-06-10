Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49573 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730055AbfFJBni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jun 2019 21:43:38 -0400
Date: Sun, 9 Jun 2019 21:43:29 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 1/8] mm/fs: don't allow writes to immutable files
Message-ID: <20190610014329.GA3266@mit.edu>
References: <155552786671.20411.6442426840435740050.stgit@magnolia>
 <155552787330.20411.11893581890744963309.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155552787330.20411.11893581890744963309.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org

On Wed, Apr 17, 2019 at 12:04:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The chattr manpage has this to say about immutable files:
> 
> "A file with the 'i' attribute cannot be modified: it cannot be deleted
> or renamed, no link can be created to this file, most of the file's
> metadata can not be modified, and the file can not be opened in write
> mode."
> 
> Once the flag is set, it is enforced for quite a few file operations,
> such as fallocate, fpunch, fzero, rm, touch, open, etc.  However, we
> don't check for immutability when doing a write(), a PROT_WRITE mmap(),
> a truncate(), or a write to a previously established mmap.
> 
> If a program has an open write fd to a file that the administrator
> subsequently marks immutable, the program still can change the file
> contents.  Weird!
> 
> The ability to write to an immutable file does not follow the manpage
> promise that immutable files cannot be modified.  Worse yet it's
> inconsistent with the behavior of other syscalls which don't allow
> modifications of immutable files.
> 
> Therefore, add the necessary checks to make the write, mmap, and
> truncate behavior consistent with what the manpage says and consistent
> with other syscalls on filesystems which support IMMUTABLE.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, looks good.  I'm going to take this patch through the ext4
tree since it doesn't have any dependencies on the rest of the patch
series.

	    	     	       	     - Ted
