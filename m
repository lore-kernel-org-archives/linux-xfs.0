Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2V5eHN4241825 for <xfs@oss.sgi.com>; Wed, 31 Mar 2010 00:40:18 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 282D7F775D7
	for <xfs@oss.sgi.com>; Tue, 30 Mar 2010 22:41:59 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	IdxCUAkVNruhZCF7 for <xfs@oss.sgi.com>;
	Tue, 30 Mar 2010 22:41:59 -0700 (PDT)
Date: Wed, 31 Mar 2010 16:41:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfstests: random fallocate calls in fsx
Message-ID: <20100331054156.GV3335@dastard>
References: <4A0B420E.3070908@sandeen.net>
 <4BB2D65D.5000402@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BB2D65D.5000402@sandeen.net>
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

On Tue, Mar 30, 2010 at 11:58:05PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Seems to work for me.  Any comments/suggestions?
> > 
> > I can probably make it fall back to the xfs ioctl if fallocate
> > isn't supported, if strongly desired.
> 
> Anybody feel like reviewing this?  Seems like having fallocate in the mix
> would be good.

Looks like all of the autoconf magic went in with the fiemap-tester
changes, so a rebase is definitely needed... :/

Otherwise the changes seem sane - I can't find anything obviously
wrong reading over them. I say clean it up, check it doesn't
obviously break and check it in...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
