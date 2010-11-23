Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANDkf0I216021 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 07:46:41 -0600
Date: Tue, 23 Nov 2010 08:48:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 4/9] xfsrestore: mmap dirent names for faster lookups
Message-ID: <20101123134818.GA31206@infradead.org>
References: <20101119183837.GA9505@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101119183837.GA9505@sgi.com>
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
Cc: xfs@oss.sgi.com

On Fri, Nov 19, 2010 at 12:38:37PM -0600, Bill Kendall wrote:
> Pathname resolution in xfsrestore is about 4x faster if the file
> containing dirent names ("namreg") is memory mapped.  If xfsrestore is
> unable to map the file (e.g., due to virtual memory constraints)
> fallback to the existing seek-and-read approach.
> 
> The file is mapped after all directory entries have been written to
> the "namreg" file. If the caller tries to add additional entries after
> the file has been mapped, it will be unmapped and restore will resort
> back to seek-and-read lookups.

This looks much simpler indeed.  Is it intentional that the namreg file
is never unmapped any more?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
