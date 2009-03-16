Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9u0vx082992 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:56:20 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BE441C45B20
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:55:38 -0700 (PDT)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2]) by cuda.sgi.com with
	ESMTP id CIgRZxLgcSPKF1XO for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2009 02:55:38 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Mon, 16 Mar 2009 10:53:32 +0100
References: <200902240010.25434.vapier@gentoo.org>
	<20090316070550.GA628@infradead.org>
	<200903160331.53142.vapier@gentoo.org>
In-Reply-To: <200903160331.53142.vapier@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903161053.32745.agruen@suse.de>
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
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Monday, 16 March 2009 8:31:48 Mike Frysinger wrote:
> usually what i do is something like:
> args=
> libtoolize -n --install 2>/dev/null && args="-i"
> libtoolize -c -f $args

Sigh, the usual GNU utility problem. I've added a compatibility fix to attr 
and acl now. Thanks!

Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
