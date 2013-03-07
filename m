Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 392877FA2
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 21:39:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7548AC001
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 19:39:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gmCkOC4K7WtUOrbi for <xfs@oss.sgi.com>;
	Wed, 06 Mar 2013 19:39:04 -0800 (PST)
Date: Thu, 7 Mar 2013 14:38:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 273: fix a typo
Message-ID: <20130307033849.GB6369@dastard>
References: <512DAC1A.2040601@gmail.com> <20130306232222.GF21081@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130306232222.GF21081@twin.jikos.cz>
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

On Thu, Mar 07, 2013 at 12:22:22AM +0100, David Sterba wrote:
> On Wed, Feb 27, 2013 at 02:47:54PM +0800, Wang Sheng-Hui wrote:
> > Make the porter log cp failure into $seq.full by appending, not overwriting,
> > which can help debug.
> > 
> > Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> > ---
> >  273 |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/273 b/273
> > index 67f3d6b..639e280 100755
> > --- a/273
> > +++ b/273
> > @@ -92,7 +92,7 @@ _porter()
> >  		exit
> >  	fi
> > 
> > -	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
> > +	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seq.full 2>&1
> 
> This gives me
> 
> 273 154s ...    [20:05:00] [20:05:01] - output mismatch (see 273.out.bad)
>     --- 273.out 2011-11-11 15:13:46.000000000 +0100
>     +++ 273.out.bad     2013-03-06 20:05:01.000000000 +0100
>     @@ -1,4 +1,4 @@
>      QA output created by 273
>     -------------------------------
>     -start the workload
>     -------------------------------
>     +./273: line 95: syntax error near unexpected token `&'
>     +./273: line 95: `  cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>>&1'
>     +umount: /dev/sda9: not mounted

that seems rather strange. The patch does this:

	....sub_$_suffix >>$seq.full 2>&1

and the error output you see is

	....sub_$_suffix >$seq.full 2>>&1

So it doesn't look lie you are running with the change that is
actually in the patch...
>      ...
>      (Run 'diff -u 273.out 273.out.bad' to see the entire diff)
> ---
> 
> The script calls /bin/bash, my version says
> GNU bash, version 4.1.10(1)-release

Wroks fine here, with:

GNU bash, version 4.2.37(1)-release

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
