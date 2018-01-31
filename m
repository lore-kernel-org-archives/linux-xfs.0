Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:34956 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbeAaPa0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 10:30:26 -0500
Date: Wed, 31 Jan 2018 10:30:25 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] Parent pointer future use cases
Message-ID: <20180131153025.GB15812@fieldses.org>
References: <588cad68-78eb-88de-49c3-716330b70cd5@oracle.com>
 <CAOQ4uxhYrpY=POeATvh6GOJLNEwDrsQhvAKvyZzwcUQXGwLvDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhYrpY=POeATvh6GOJLNEwDrsQhvAKvyZzwcUQXGwLvDA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>

On Wed, Jan 31, 2018 at 09:34:52AM +0200, Amir Goldstein wrote:
> If filesystem were to provide a parents iterator interface, something like:
> get_acceptable_parent(child, acceptable, context)
> then xfs could iterate inode parents and call the nfsd_acceptable() callback.
> For filesystems that support get_acceptable_parent(), there is no need to
> encode a 'connectable' non unique file handle.
> 
> I am not sure how much of a problem the 'subtree_check' and non-unique
> file handle is for nfsd (CC nfsd folks for that), but I know I can make good use
> of that in overlayfs, as well as with an optimized get_name() implementation.

I hate subtree-checking and wish people would just stop trying to export
subtrees.

That said, anything that makes it less painful is probably good.

And, yes, the fact that filehandles can change when a file is renamed
across directories can be a problem for people using subtree checking.

--b.
