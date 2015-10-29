Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D873E7F47
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 17:50:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA19F8F8033
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 15:50:04 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id 0UmV8VoR3jwsgGWx for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 15:50:00 -0700 (PDT)
Date: Thu, 29 Oct 2015 16:49:53 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC 00/11] DAX fsynx/msync support
Message-ID: <20151029224953.GA17933@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>
Cc: x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Thu, Oct 29, 2015 at 02:12:04PM -0600, Ross Zwisler wrote:
> This patch series adds support for fsync/msync to DAX.
> 
> Patches 1 through 8 add various utilities that the DAX code will eventually
> need, and the DAX code itself is added by patch 9.  Patches 10 and 11 are
> filesystem changes that are needed after the DAX code is added, but these
> patches may change slightly as the filesystem fault handling for DAX is
> being modified ([1] and [2]).
> 
> I've marked this series as RFC because I'm still testing, but I wanted to
> get this out there so people would see the direction I was going and
> hopefully comment on any big red flags sooner rather than later.
> 
> I realize that we are getting pretty dang close to the v4.4 merge window,
> but I think that if we can get this reviewed and working it's a much better
> solution than the "big hammer" approach that blindly flushes entire PMEM
> namespaces [3].
> 
> [1] http://oss.sgi.com/archives/xfs/2015-10/msg00523.html
> [2] http://marc.info/?l=linux-ext4&m=144550211312472&w=2
> [3] https://lists.01.org/pipermail/linux-nvdimm/2015-October/002614.html

Hmm...I think I may need to isolate the fsync/msync flushing against races
with truncate since we are calling into the filesystem directly with
get_block().  Dave (Chinner), does this sound right?

Also, one thing I forgot to mention is that these patches are built upon the
first version of Dave Chinner's XFS patches and my ext2 patches that deal with
the truncate races with DAX.  A snapshot of my development tree with these
patches applied can be found here:

https://github.com/01org/prd/tree/fsync_rfc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
