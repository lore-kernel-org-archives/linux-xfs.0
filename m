Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51765 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727482AbfCWQNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Mar 2019 12:13:47 -0400
Date: Sat, 23 Mar 2019 12:13:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: prohibit fstrim in norecovery mode
Message-ID: <20190323161334.GE5675@mit.edu>
References: <20190323003532.GB1180@magnolia>
 <20190323003813.GR1183@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190323003813.GR1183@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Fri, Mar 22, 2019 at 05:38:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The ext4 fstrim implementation uses the block bitmaps to find free space
> that can be discarded.  If we haven't replayed the journal, the bitmaps
> will be stale and we absolutely *cannot* use stale metadata to zap the
> underlying storage.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
