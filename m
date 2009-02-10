Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1A9xnbP043241 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 03:59:50 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5E2118F8F26
	for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 01:59:12 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	AYz15sCHH5CyGNzI for <xfs@oss.sgi.com>;
	Tue, 10 Feb 2009 01:59:12 -0800 (PST)
Date: Tue, 10 Feb 2009 20:53:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel: Access to block zero: fs: <sdg> inode: 231137029....
Message-ID: <20090210095337.GM8830@disturbed>
References: <20090209143315.GB2535@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090209143315.GB2535@p15145560.pureserver.info>
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
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: xfs@oss.sgi.com

On Mon, Feb 09, 2009 at 03:33:15PM +0100, Ralf Gross wrote:
> Hello,
> 
> this is the second time I got hit by this problem in the last 2 months.
> 
> The server did respond to ping and all processes were still running, but the
> load went up to >30. Neither a shutdown nor a sync command could be executed,
> in the end I had to reset the server because nobody could access the samba
> shares anymore. 
> 
> System: Debian Etch linux-image-2.6.18-6-amd64 (since today 2.6.24 from
> etch-n-half). sdg is a fibre attached (QLA2422) RAID array.
> 
> Any idea what the reason for this could be? xfs_check of /dev/sdg didn't find anything.

Btree corruption in memory (not yet written to disk). I'd suggest
that you should upgrade to at least 2.6.27 which is when we fixed
the last of the known btree corruption problems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
