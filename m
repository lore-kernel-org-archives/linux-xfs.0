Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBFEF7FC4
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 16:48:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 70C11AC009
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 14:48:36 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YpIrJk0DBFTCmuEE for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 14:48:34 -0800 (PST)
Date: Fri, 8 Mar 2013 09:48:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 273: fix a typo
Message-ID: <20130307224832.GV23616@dastard>
References: <512DAC1A.2040601@gmail.com> <20130306232222.GF21081@twin.jikos.cz>
	<20130307033849.GB6369@dastard>
	<20130307110600.GJ21081@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130307110600.GJ21081@twin.jikos.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: dsterba@suse.cz, Wang Sheng-Hui <shhuiw@gmail.com>, xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 12:06:01PM +0100, David Sterba wrote:
> On Thu, Mar 07, 2013 at 02:38:49PM +1100, Dave Chinner wrote:
> > On Thu, Mar 07, 2013 at 12:22:22AM +0100, David Sterba wrote:
> > > On Wed, Feb 27, 2013 at 02:47:54PM +0800, Wang Sheng-Hui wrote:
> > > > -	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
> > > > +	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seq.full 2>&1
> 
> This is quote from the mail, but the merged patch does something else.
> 
> > >     +./273: line 95: syntax error near unexpected token `&'
> > >     +./273: line 95: `  cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>>&1'
> > >     +umount: /dev/sda9: not mounted
> 
> > that seems rather strange. The patch does this:
> > 
> > 	....sub_$_suffix >>$seq.full 2>&1
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=commitdiff;h=0c5e67e46e476b70290033efc7feb784f7ecbab1;hp=08557e219c12e573be459407033495899f46967a

Oh....

> ---
> 
> > and the error output you see is
> > 
> > 	....sub_$_suffix >$seq.full 2>>&1
> > 
> > So it doesn't look lie you are running with the change that is
> > actually in the patch...
> 
> There's a difference between the patch in mail and what has been merged, that
> can happen, but I wonder why it works on your side.

.... because I haven't updated to the latest xfstests master branch
yet - I'm running with the patch from the list applied. I didn't
realise you were running from the main repo, and that the commit was
busted...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
