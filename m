Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0B1VxUO075090 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 19:31:59 -0600
Received: from mail.bitmover.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3A031577FA
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 17:32:52 -0800 (PST)
Received: from mail.bitmover.com (ipcop.bitmover.com [192.132.92.15]) by
	cuda.sgi.com with ESMTP id h1W3VuOGQ0U9Bvsw for
	<xfs@oss.sgi.com>; Sun, 10 Jan 2010 17:32:52 -0800 (PST)
Date: Sun, 10 Jan 2010 17:32:51 -0800
From: Larry McVoy <lm@bitmover.com>
Subject: Re: [Jfs-discussion] benchmark results
Message-ID: <20100111013251.GA8233@bitmover.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
	<AAA45328-6BEA-465C-B999-C99D45FC56FF@shobe.info>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AAA45328-6BEA-465C-B999-C99D45FC56FF@shobe.info>
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
To: Casey Allen Shobe <casey@shobe.info>
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, tytso@mit.edu, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, Larry McVoy <lm@bitmover.com>, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Sun, Jan 10, 2010 at 08:03:04PM -0500, Casey Allen Shobe wrote:
> On Dec 25, 2009, at 11:22 AM, Larry McVoy wrote:
>> Dudes, sync() doesn't flush the fs cache, you have to unmount for  
>> that.
>> Once upon a time Linux had an ioctl() to flush the fs buffers, I used
>> it in lmbench.
>
>
> You do not need to unmount - 2.6.16+ have a mechanism in /proc to flush 
> caches.  See http://linux-mm.org/Drop_Caches

Cool, but I tend to come at problems from a cross platform point of view.
Aix no hable /proc :)
-- 
---
Larry McVoy                lm at bitmover.com           http://www.bitkeeper.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
