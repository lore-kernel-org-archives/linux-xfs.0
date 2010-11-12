Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACNOaIC171620 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:24:36 -0600
Subject: Re: [PATCH v2 4/9] xfsrestore: mmap dirent names for faster lookups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163643.799606284@sgi.com>
References: <20101105163500.747192954@sgi.com>
	<20101105163643.799606284@sgi.com>
Date: Fri, 12 Nov 2010 17:25:22 -0600
Message-ID: <1289604322.2315.909.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
> plain text document attachment (namreg_map)
> Pathname resolution in xfsrestore is about 4x faster if the file
> containing dirent names ("namreg") is memory mapped.  If xfsrestore is
> unable to map the file (e.g., due to virtual memory constraints)
> fallback to the existing seek-and-read approach.
> 
> The file is mapped after all directory entries have been written to
> the "namreg" file. If the caller tries to add additional entries after
> the file has been mapped, it will be unmapped and restore will resort
> back to seek-and-read lookups.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

I guess I might have created a simple namreg_flush_final()
routine to encapsulate the namreg_flush() and namreg_map()
calls, rather than adding a flag.  Then namreg_flush() could
have been made to have static scope.  No big deal though.

Also, you fall back to the non-mmapped method in case a
flush or add happens after you've mapped the file.  That
is in some sense comforting, but it would be nice to be
assured it simply won't happen.  If you come to a point
someday where you are sure of this it would be nice to
see that code switched to assertions instead.

You could define the new namreg_*map*() functions earlier
in the file and skip the forward declarations.

These aren't all that important though, I think it's a
good change.  Let me know if you think you will
re-work it but I think it's OK as-is.

Reviewed-by: Alex Elder <aelder@sgi.com>

 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
