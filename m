Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0S1w3Gd254327 for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 19:58:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 990CA1953FA
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2010 17:58:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	TnXAfbiOK80GGuVy for <xfs@oss.sgi.com>;
	Wed, 27 Jan 2010 17:58:41 -0800 (PST)
Date: Thu, 28 Jan 2010 12:58:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] more reserved blocks fixups
Message-ID: <20100128015817.GH15853@discord.disaster>
References: <4B60C8EE.5080700@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B60C8EE.5080700@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Jan 27, 2010 at 05:14:54PM -0600, Eric Sandeen wrote:
> This mangles the reserved blocks counts a little more.
> 
> 1) add a helper function for the default reserved count
> 2) add helper functions to save/restore counts on ro/rw
> 3) save/restore reserved blocks on freeze/thaw
> 4) disallow changing reserved count while readonly
> 
> for 2) - maybe better names (save_and_clear?)
> for 4) - maybe allow, but change the _ro field instead?
> 
> (TBH not tested yet but wondered if this seems sane)

I was wondering if the save/restore could be encapsualted entirely
within xfs_quiesce_attr(). i.e. save before the superblock write,
restore directly after. That removes the need for a variable in
the xfs_mount structure, and catches both remount,ro and freeze.

What do you think?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
