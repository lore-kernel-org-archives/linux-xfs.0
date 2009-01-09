Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09JfGpn017391 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 13:41:17 -0600
Date: Fri, 9 Jan 2009 14:41:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump support for 64K page size
Message-ID: <20090109194115.GA1855@infradead.org>
References: <4964C5EF.3060308@sgi.com> <4965629C.2000703@sgi.com>
	<20090108222800.GG9448@disturbed> <4967A73E.9020907@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4967A73E.9020907@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs@oss.sgi.com

On Fri, Jan 09, 2009 at 01:36:30PM -0600, Bill Kendall wrote:
> Once that is done, I suggest we put Dave's original patches in the
> -dev trees. That way it'll have proper attribution as well as commit
> messages with some detail.

The commits were merged back to the -dev trees alredy, and at least
for xfsprogs we already have a commit ontop.  I'd say let's use how
this was handled as a bad example and get over it.

What we should do however is putting dump images of every page
size we can hold of (4k/8k/16k/64k) and maybe both endianesses
into the xfstests repository so we can exercise them as part of
the normal QA procedure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
