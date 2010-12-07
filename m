Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7M8QUg231574 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 16:08:26 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CDB214260FE
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 14:10:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	iW0yk5sNTwfz01iR for <xfs@oss.sgi.com>;
	Tue, 07 Dec 2010 14:10:13 -0800 (PST)
Date: Wed, 8 Dec 2010 09:10:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: possible xfs corruption
Message-ID: <20101207221009.GA29333@dastard>
References: <30395558.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <30395558.post@talk.nabble.com>
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
To: blacknred <leo1783@hotmail.co.uk>
Cc: xfs@oss.sgi.com

On Tue, Dec 07, 2010 at 03:49:49AM -0800, blacknred wrote:
> 
> Hi...
> 
> I'm stuck with a storage issue on reboot. Initially doubted the storage, but
> dmesg throws these errors. Now wondering whether this is a fs issue? Any
> thoughts as to whats going on here?
> 
> 
> XFS: failed to locate log tail
> XFS: log mount/recovery failed: error 117
> XFS: log mount failed
> XFS mounting filesystem cciss/c0d0
> Filesystem "cciss/c0d0": XFS internal error xlog_clear_stale_blocks(2) at
> line 1237 of file

Which indicates that the head and/or the tail of the log are not
valid. Can you provide the output of:

# xfs_logprint -d /dev/cciss/c0d0

So we can see what the head/tail values are in the log?

> /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_log_recover.c. 

CentOS kernel? How old?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
