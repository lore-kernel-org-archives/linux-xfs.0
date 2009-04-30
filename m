Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3UIZ65u235025 for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 13:35:06 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B45571463980
	for <xfs@oss.sgi.com>; Thu, 30 Apr 2009 11:38:35 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id 5FnhnmcNJYDthR7S for <xfs@oss.sgi.com>;
	Thu, 30 Apr 2009 11:38:35 -0700 (PDT)
Date: Thu, 30 Apr 2009 14:34:50 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT vs XFS at 80% filled filesystem
Message-ID: <20090430183450.GB19276@mit.edu>
References: <49F9565E.40804@gslab.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49F9565E.40804@gslab.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Milind Dumbare <milind@gslab.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 30, 2009 at 01:12:22PM +0530, Milind Dumbare wrote:
> Hi,
>
> I have heard of XFS's performance is not good as compared to EXT3 when  
> the filesystem(disk) is 80% filled with data. Is it true? I have went  
> through lots of performance documents of both XFS and EXT3 but could not  
> find such performance benchmarking (for 80% full filesystems).

I've not heard of any such performance metrics, and I suspect it would
very much depend on how the filesystem was "aged".  A filesystem that
has been in use for a few years and is at 80% capacity will behave
very different from a brand-new filesystem which was freshly formatted
and then filled with a few large files until said filesystem was 80%
full.

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
