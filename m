Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1D8atam251572 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 02:36:56 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id CDNo3OvZFvIGDmRJ for
	<xfs@oss.sgi.com>; Mon, 13 Feb 2012 00:36:54 -0800 (PST)
Date: Mon, 13 Feb 2012 08:36:51 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Disk spin down
Message-ID: <20120213083651.GA40007@nsrc.org>
References: <4F3803B1.1090205@ashurst.eu.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3803B1.1090205@ashurst.eu.org>
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
To: Andy Bennett <andyjpb@ashurst.eu.org>
Cc: xfs@oss.sgi.com

On Sun, Feb 12, 2012 at 06:23:45PM +0000, Andy Bennett wrote:
> Can someone help me work out where writes are coming from on my system?

Is the filesystem in question mounted with 'relatime' or 'noatime'?
Otherwise, merely reading a file will cause its inode to be dirtied.

(However in modern kernels, 'relatime' might be the default, I'm not sure)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
