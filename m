Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9S3WSfY112748 for <xfs@oss.sgi.com>; Tue, 27 Oct 2009 22:32:31 -0500
Date: Tue, 27 Oct 2009 23:34:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] use lpath_to_handle when restoring symlinks
Message-ID: <20091028033405.GA15502@infradead.org>
References: <4AE08DD0.50304@sgi.com> <20091025070544.GA21462@infradead.org>
	<4AE71364.7090102@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AE71364.7090102@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Oct 27, 2009 at 10:36:04AM -0500, Bill Kendall wrote:
> On 10/25/2009 02:05 AM, Christoph Hellwig wrote:
>> On Thu, Oct 22, 2009 at 11:52:32AM -0500, Bill Kendall wrote:
>>> Update xfsrestore to use the new lpath_to_handle function
>>> when dealing with symlinks.
>>
>> Requiring a simultanously released version of xfsprogs is a very bad
>> idea.  The right fix is to add an autoconf check for the new function
>> and use it when available, falling back to the inferior old version
>> if it is not available.
>
> Good thought. However, there's also a run-time dependency since
> xfsrestore uses libhandle.so rather than the .a. I can rework something
> using dlsym - sound okay?

That's why the minor version of a shared library needs to get bumped
when adding a new symbol, see one of my replies to Alex.  Of course
symbol versioning would be even better, I'll see if I can port it from
acl/attr which use the same build system as xfsprogs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
