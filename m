Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9RFYTtx062525 for <xfs@oss.sgi.com>; Tue, 27 Oct 2009 10:34:30 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2B24AC00E
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2009 08:36:04 -0700 (PDT)
Message-ID: <4AE71364.7090102@sgi.com>
Date: Tue, 27 Oct 2009 10:36:04 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] use lpath_to_handle when restoring symlinks
References: <4AE08DD0.50304@sgi.com> <20091025070544.GA21462@infradead.org>
In-Reply-To: <20091025070544.GA21462@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 10/25/2009 02:05 AM, Christoph Hellwig wrote:
> On Thu, Oct 22, 2009 at 11:52:32AM -0500, Bill Kendall wrote:
>> Update xfsrestore to use the new lpath_to_handle function
>> when dealing with symlinks.
> 
> Requiring a simultanously released version of xfsprogs is a very bad
> idea.  The right fix is to add an autoconf check for the new function
> and use it when available, falling back to the inferior old version
> if it is not available.

Good thought. However, there's also a run-time dependency since
xfsrestore uses libhandle.so rather than the .a. I can rework something
using dlsym - sound okay?

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
