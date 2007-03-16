Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 13:00:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2GK016p001050
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 13:00:05 -0700
Date: Sat, 17 Mar 2007 06:59:51 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Message-ID: <20070316195951.GB5743@melbourne.sgi.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Mar 16, 2007 at 12:05:33PM +0100, Marco Berizzi wrote:
> David Chinner wrote:
> 
> > can
> > you post a url to the commit?
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.19.y.git;a=commit;h=7fbbb01dca7704d52ace6f45a805c98a5b0362f9

Ok, so an ipsec change. And I see from the history below it
really has nothing to do with this problem. it seems the problem
has something to do with changes between 2.6.19.1 and 2.6.19.2.

There were no changes to XFS between 2.6.19.1 and 2.6.19.2,
so I'm thinking that your problems are related to something
other than XFS. Can you do a git bisect to determine what the
bad patch is?

> > Can you run xfs_repair on that filesystem and see if reports
> > (and fixes) any problems?
> 
> I don't need to run xfs_repair to fix the problem,

Except that the trigger might be on-disk corruption so we
need to rule that out first.

> I only unplug the power cable and reboot the system,
> xfs filesystem are correctly mounted.
> However tell me if I must run xfs_repair to check
> the filesystem.

Yes, you need to run xfs_repair.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
