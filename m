Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4P0pPI1067669 for <xfs@oss.sgi.com>; Sun, 24 May 2009 19:51:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71A1812FC830
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 17:57:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	6ozRCPnWFEYKfzal for <xfs@oss.sgi.com>;
	Sun, 24 May 2009 17:57:17 -0700 (PDT)
Date: Mon, 25 May 2009 10:51:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1164 of file
	fs/xfs/xfs_trans.c
Message-ID: <20090525005132.GR16929@discord.disaster>
References: <4A13AA1B.7080801@attglobal.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A13AA1B.7080801@attglobal.net>
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
To: Eddie Atherton <stunnel@attglobal.net>
Cc: xfs@oss.sgi.com

On Tue, May 19, 2009 at 11:58:35PM -0700, Eddie Atherton wrote:
> I'm trying to install a clean Slackware 12.2 (2.6.27.7) under ESXi, and  
> can almost guarantee getting this error immediately after formatting the  
> root partition.  It's happened 4 out of the 5 times I've tried, so far.
>
> The sequence of commands, after digging through the install scripts,  
> that lead to this failure are just:
>
> mkfs.xfs
> mount
> mkdir

That's bizarre. Can you provide a xfs_metadump image of the fs after
the shutdown has occurred?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
