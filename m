Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 814438006
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 17:05:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87C94AC001
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 15:05:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Y8IhEBnBxLvPeRtk for <xfs@oss.sgi.com>;
	Sat, 02 Mar 2013 15:05:17 -0800 (PST)
Date: Sun, 3 Mar 2013 10:05:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: logsunit rounding causes iclog corruption/crash
Message-ID: <20130302230513.GH23616@dastard>
References: <20130302201446.854313570@sgi.com>
	<20130302201452.236378200@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130302201452.236378200@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Sat, Mar 02, 2013 at 02:14:47PM -0600, Mark Tinguely wrote:
> When the iclog buffer size and log stripe unit are both defined and
> the log stripe unit is less the log buffer size then the buffer is
> rounded up to the log stripe unit size during the xlog_sync().
> 
> This rounding can exceed the iclog buffer length and in xlog_data_pack():
>  1) Cause corruption inside the iclog buffer because there will not be
>     enough space for the headers in the front of the iclog buffer for
>     the rounding.
>  2) Cause corruption in memory that follows the iclog buffer when
>     stamping the lsn in each of the rounded blocks.
>  3) If CONFIG_XFS_DEBUG is defined will cause a crash in xlog_verify_iclog().
>  4) Cause page fault crash if the memory after the buffer is not mapped.
> 
> This has been found in XFS versions at least as far back as
> Linux 2.6.32.
> 
> This patch forces the iclog buffer to be a multiple of the log stripe
> unit when they are both defined.
> 
> Example:
>   # mkfs.xfs -l su=192k -f /dev/sda2

$ sudo mkfs.xfs -l sunit=192k /dev/vdb
Specify log sunit in 512-byte blocks, no size suffix
....
$

>   # mount -o logbsize=256k /dev/sda3 /scratch
>   # io such as fsstress in /scratch will immediately crash a debug xfs
>     kernel and most like a non-debug xfs kernel.

It's definitely not an immediate crash. xfstests runs for several
minutes (including through fsstress workloads) before it finally
falls over. I'd suggest a targetted xfstest is needed for this...

> Index: b/fs/xfs/xfs_super.c
> ===================================================================
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1357,11 +1357,23 @@ xfs_finish_flags(
>  		if (mp->m_logbsize <= 0 &&
>  		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
>  			mp->m_logbsize = mp->m_sb.sb_logsunit;
> -		} else if (mp->m_logbsize > 0 &&
> -			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
> -			xfs_warn(mp,
> +		} else if (mp->m_logbsize > 0) {
> +			if (mp->m_logbsize > mp->m_sb.sb_logsunit) {
> +				int	logbsize;
> +				/* round up to the next multiple of logsunit */
> +				logbsize = roundup(mp->m_logbsize,
> +							 mp->m_sb.sb_logsunit);
> +				if (logbsize > XLOG_MAX_RECORD_BSIZE)
> +					/* buffer size too large. round down. */
> +					logbsize -= mp->m_sb.sb_logsunit;
> +				xfs_warn(mp, "log bufsize rounded from %d to %d",
> +					 mp->m_logbsize, logbsize);
> +				mp->m_logbsize = logbsize;
> +			} else if (mp->m_logbsize < mp->m_sb.sb_logsunit) {
> +				xfs_warn(mp,
>  		"logbuf size must be greater than or equal to log stripe size");
> -			return XFS_ERROR(EINVAL);
> +				return XFS_ERROR(EINVAL);
> +			}

If the user has specified an invalid log buffer size, then reject it
with:

logbsize XXX is not an integer multiple of the log stripe unit YYY

Rounding means that the user isn't getting what they want and they
may not realise it. If they make a mistake, they should be informed
and forced to fix it before going any further.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
