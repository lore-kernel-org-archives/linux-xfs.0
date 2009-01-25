Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PETOl6132314 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 08:29:24 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89797B5FE5
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:28:41 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id gMA7zSgrIFjR6Vz6 for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:28:41 -0800 (PST)
Message-ID: <497C7718.5090607@sandeen.net>
Date: Sun, 25 Jan 2009 08:28:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: add xfs_estimate manpage
References: <20090123004519.GA29225@infradead.org>
In-Reply-To: <20090123004519.GA29225@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> xfs_Estimate has been moved to xfsprogs a while ago, so the manpage
> should follow it.

Hmm we need a patch to remove from dump too right :)

ACK for the move part, but some update to the man page to give a hint as
to why this tool is useful seems reasonable... why would I want to use
this thing?

Also as an aside, why does the log size matter for space ultimately used?

So:

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

for the simple move but maybe we can update it a bit.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsprogs-dev/man/man8/xfs_estimate.8
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ xfsprogs-dev/man/man8/xfs_estimate.8	2009-01-23 01:43:08.253480935 +0100
> @@ -0,0 +1,104 @@
> +.TH xfs_estimate 8
> +.SH NAME
> +xfs_estimate \- estimate the space that an XFS filesystem will take
> +.SH SYNOPSIS
> +.nf
> +\f3xfs_estimate\f1 [ \f3\-h?\f1 ] [ \f3\-b\f1 blocksize ] [ \f3\-i\f1 logsize ]
> +		   [ \f3\-e\f1 logsize ] [ \f3\-v\f1 ] directory ...
> +.fi
> +.SH DESCRIPTION
> +For each \f2directory\f1 argument,
> +.I xfs_estimate
> +estimates the space that directory would take if it were copied to an XFS
> +filesystem.
> +.I xfs_estimate
> +does not cross mount points.
> +The following definitions
> +are used:
> +.PD 0
> +.IP
> +KB = *1024
> +.IP
> +MB = *1024*1024
> +.IP
> +GB = *1024*1024*1024
> +.PD
> +.PP
> +The
> +.I xfs_estimate
> +options are:
> +.TP
> +\f3\-b\f1 \f2blocksize\f1
> +Use
> +.I blocksize
> +instead of the default blocksize of 4096 bytes.
> +The modifier
> +.B k
> +can be used
> +after the number to indicate multiplication by 1024.
> +For example,
> +.sp .8v
> +.RS
> +	\f4xfs_estimate \-b 64k /\f1
> +.RE
> +.IP
> +requests an estimate of the space required by the directory / on an
> +XFS filesystem using a blocksize of 64K (65536) bytes.
> +.TP
> +.B \-v
> +Display more information, formatted.
> +.TP
> +.B \-h
> +Display usage message.
> +.TP
> +.B \-?
> +Display usage message.
> +.TP
> +\f3\-i, \-e\f1 \f2logsize\f1
> +Use
> +.I logsize
> +instead of the default log size of 1000 blocks.
> +.B \-i
> +refers to an internal log, while
> +.B \-e
> +refers to an external log.
> +The modifiers
> +.B k
> +or
> +.B m
> +can be used
> +after the number to indicate multiplication by 1024 or 1048576, respectively.
> +.IP
> +For example,
> +.sp .8v
> +.RS
> +	\f4xfs_estimate \-i 1m /\f1
> +.RE
> +.IP
> +requests an estimate of the space required by the directory / on an
> +XFS filesystem using an internal log of 1 megabyte.
> +.SH EXAMPLES
> +.nf
> +.sp 8v
> +% \f4xfs_estimate \-e 10m /var/tmp\f1\f7
> +/var/tmp will take about 4.2 megabytes
> +        with the external log using 2560 blocks or about 10.0 megabytes
> +.fi
> +.nf
> +.sp .8v
> +% \f4xfs_estimate \-v \-e 10m /var/tmp\f1\f7
> +directory                     bsize   blocks    megabytes    logsize
> +/var/tmp                       4096      792        4.0MB   10485760
> +.fi
> +.nf
> +.sp .8v
> +% \f4xfs_estimate \-v /var/tmp\f1\f7
> +directory                     bsize   blocks    megabytes    logsize
> +/var/tmp                       4096     3352       14.0MB   10485760
> +.fi
> +.nf
> +.sp .8v
> +% \f4xfs_estimate /var/tmp\f1\f7
> +/var/tmp will take about 14.0 megabytes
> +.fi
> +.Ee
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
