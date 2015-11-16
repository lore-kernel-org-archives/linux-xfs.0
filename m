Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3ED1D7CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 08:41:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1836C30404E
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 06:41:41 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id pFDQmMhhGDmFZ4t9 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 06:41:34 -0800 (PST)
Date: Mon, 16 Nov 2015 15:41:30 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 00/11] DAX fsynx/msync support
Message-ID: <20151116144130.GD3443@quack.suse.cz>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, "H. Peter Anvin" <hpa@zytor.com>, Jeff Layton <jlayton@poochiereds.net>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Alexander Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri 13-11-15 17:06:39, Ross Zwisler wrote:
> This patch series adds support for fsync/msync to DAX.
> 
> Patches 1 through 7 add various utilities that the DAX code will eventually
> need, and the DAX code itself is added by patch 8.  Patches 9-11 update the
> three filesystems that currently support DAX, ext2, ext4 and XFS, to use
> the new DAX fsync/msync code.
> 
> These patches build on the recent DAX locking changes from Dave Chinner,
> Jan Kara and myself.  Dave's changes for XFS and my changes for ext2 have
> been merged in the v4.4 window, but Jan's are still unmerged.  You can grab
> them here:
> 
> http://www.spinics.net/lists/linux-ext4/msg49951.html

I had a quick look and the patches look sane to me. I'll try to give them
more detailed look later this week. When thinking about the general design
I was wondering: When we have this infrastructure to track data potentially
lingering in CPU caches, would not it be a performance win to use standard
cached stores in dax_io() and mark corresponding pages as dirty in page
cache the same way as this patch set does it for mmaped writes? I have no
idea how costly are non-temporal stores compared to cached ones and how
would this compare to the cost of dirty tracking so this may be just
completely bogus...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
