Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A7FFC7F50
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 09:28:10 -0600 (CST)
Message-ID: <51263D08.5060307@sgi.com>
Date: Thu, 21 Feb 2013 09:28:08 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfsprogs: Fix possible unallocated memory access in
	fiemap
References: <1355319059-12111-1-git-send-email-lczerner@redhat.com>
	<20121212231245.GY16353@dastard>
	<alpine.LFD.2.00.1212131024460.17970@localhost>
	<20121213230608.GI16353@dastard> <5102F4BE.6060009@sandeen.net>
In-Reply-To: <5102F4BE.6060009@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: hch@infradead.org, xfs@oss.sgi.com

On 01/25/13 15:10, Eric Sandeen wrote:
> (Based on original patch by Lukas Czerner&  comments by Dave Chinner)
>
> Currently we could access unallocated memory in fiemap because we're
> using uninitialized variable 'fiemap' in fiemap_f(). In fact this has
> been spotted on x390s machine where xfs_io would segfault.
>
> The problem happens in the for cycle which seems to be intended to
> compute the header item spacing. However at that point the fiemap
> structure has just been allocated and does not contain any extents
> yet, so it is entirely useless and it never actually worked.
>
> This patch delays the format calculation until the first batch
> of extents has come in for analysis.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

A working calculated format is a great improvement.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
