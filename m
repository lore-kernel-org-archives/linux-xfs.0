Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6IFaZQK107151 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 10:36:35 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B32541509E8A
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 08:36:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id j2DDrsw6tEh3m1zq for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 08:36:33 -0700 (PDT)
Date: Mon, 18 Jul 2011 17:36:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3] xfstests: Improve test 219 to work with different
	filesystems
Message-ID: <20110718153631.GA5842@quack.suse.cz>
References: <1309363480-22268-1-git-send-email-jack@suse.cz>
	<1310744354.2921.20.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310744354.2921.20.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Fri 15-07-11 10:39:14, Alex Elder wrote:
> On Wed, 2011-06-29 at 18:04 +0200, Jan Kara wrote:
> > Different filesystems account different amount of metadata in quota. Thus it is
> > impractical to check for a particular amount of space occupied by a file
> > because there is no right value. Change the test to verify whether the amount
> > of space is between the expected amount of space and the expected amount +5%.
> > The number of files is checked exactly as previously.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Looks good.  After verifying it (at least on XFS), I
> will commit this for you.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
  Thanks for testing and committing!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
