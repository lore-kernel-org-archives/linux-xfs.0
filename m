Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Oct 2007 00:19:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9B7J9Jg026898
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 00:19:12 -0700
Message-ID: <470DCF81.10704@sgi.com>
Date: Thu, 11 Oct 2007 17:23:45 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: review: use correct buffer flags when reading superblock
References: <470C8F5B.90705@sgi.com> <20071010112821.GI23367404@sgi.com> <470D8D91.903@sgi.com> <20071011033038.GW995458@sgi.com>
In-Reply-To: <20071011033038.GW995458@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------090404040807010702010805"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------090404040807010702010805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Chinner wrote:
> On Thu, Oct 11, 2007 at 12:42:25PM +1000, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> On Wed, Oct 10, 2007 at 06:37:47PM +1000, Lachlan McIlroy wrote:
>>>> When reading the superblock during log recovery we are not setting
>>>> the correct buffer flags.  Specifically we are not turning off flags
>>>> we do not need such as XBF_ASYNC that is causing the synchronous
>>>> xfs_iowait() to hang.  We should also turn off XBF_WRITE and remove
>>>> the buffer from the delay write queue just to be safe.
>>> We really don't need the removal of the write flags - the XFS_bflush()
>>> call above the xfs_getsb() call guarantees that they won't be set....
>> It's not obvious though.  It wasn't obvious that ASYNC was still set
>> and look where that got us.
> 
> Sure, but it is incorrect to have them set at that point - incorrect
> enough that it might cause corruption. That is, if they are set
> then the changes made during log replay have not been written to
> disk and we've got bigger problems than a hanging I/O to worry
> about....
> 
> So rather than clearing them, we should be asserting that the
> write flags are not set at all.
> 

New patch attached.

--------------090404040807010702010805
Content-Type: text/x-patch;
 name="xfs_getsb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_getsb.diff"

--- fs/xfs/xfs_log_recover.c_1.329	2007-10-10 15:59:18.000000000 +1000
+++ fs/xfs/xfs_log_recover.c	2007-10-11 15:03:00.000000000 +1000
@@ -3824,7 +3824,10 @@ xlog_do_recover(
 	 */
 	bp = xfs_getsb(log->l_mp, 0);
 	XFS_BUF_UNDONE(bp);
+	ASSERT(!(XFS_BUF_ISWRITE(bp)));
+	ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 	XFS_BUF_READ(bp);
+	XFS_BUF_UNASYNC(bp);
 	xfsbdstrat(log->l_mp, bp);
 	if ((error = xfs_iowait(bp))) {
 		xfs_ioerror_alert("xlog_do_recover",

--------------090404040807010702010805--
