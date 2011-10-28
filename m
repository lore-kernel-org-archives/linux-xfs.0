Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9S9bKbx144389 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 04:37:20 -0500
Date: Fri, 28 Oct 2011 05:37:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: fix metadata restore on split files
Message-ID: <20111028093716.GA23069@infradead.org>
References: <1319671483-27787-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319671483-27787-1-git-send-email-wkendall@sgi.com>
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

On Wed, Oct 26, 2011 at 06:24:43PM -0500, Bill Kendall wrote:
> xfsrestore does not apply certain metadata until all of the file's
> data has been restored. This allows, for example, files with the
> immutable flag set to be restored properly.
> 
> While testing multi-stream restores, I noticed that files split
> across multiple streams did not have their metadata restored.
> Looking into this further, it also applies to the single-stream
> case where files are split across media files, such as when a
> backup spans multiple tapes.
> 
> The fix is to check to see if a file is completely restored
> whenever we hit the end of a media file. The current code
> is broken because it relies on all media files being applied
> during the same restore session.
> 
> This also moves the S_ISREG() check into restore_complete_reg()
> rather than relying on callers to make the check.

Uhh, that's a nasty bug for people storing large files over multiple
tapes.  Any chance we could get an xfstests test case for this?

Can we somehow simulate multiple tapes using small files?

The code change looks okay to me, but I have to admit I don't really
understand the code very well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
