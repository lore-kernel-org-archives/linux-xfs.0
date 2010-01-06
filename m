Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06JONE1105866 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 13:24:24 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE84214717A
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 11:25:14 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id 3hDd20r4ovz2lTG0 for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2010 11:25:14 -0800 (PST)
Date: Wed, 6 Jan 2010 11:24:10 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH] remove bashisms from xfstests
In-Reply-To: <20100106164844.GB4209@infradead.org>
Message-ID: <alpine.DEB.2.01.1001061114340.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001030125040.3483@bogon.housecafe.de>
	<20100106164844.GB4209@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, 6 Jan 2010 at 11:48, Christoph Hellwig wrote:
> > 2) convert "let..." into something (hopefully) more portable
> 
> Dave converted these away from expr due to performance reasons.  I'd
> like too see a prove that performance hasn't regressed due to this
> change.

That's why I hesitated to just change all scripts to /bin/bash, but didn't 
dare to say so, because of the inevitable "but today's computers are fast 
enough" reactions :-)

> > 3) replace 'a == b' with 'a = b' in bourne shell scripts
> 
> This looks fine.  If you want feel free to submit these as a separate
> first patch so that we have the large pile sorted out.

OK, will do.

> I fear this might cause some overhead in the shell.  What about the
> following instead:
> 
> for i in `seq 0 39`; do
>     ln -s $o symlink_$i
>     o=symlink_$i
> done

I didn't go for seq(1), as I feared this wouldn't be available on every 
machine. Given that the xfstests scripts have a lot of "what if we're 
running on IRIX" conditions, I just wasn't sure if seq(1) would be 
available there. But yes, I'd much rather like to do this with seq(1) as 
well, if this is OK to everybody.

> > --- xfstests.orig/032	2010-01-03 00:42:16.601617592 -0800
> > +++ xfstests/032	2010-01-03 00:43:56.321617592 -0800
> > @@ -66,6 +66,7 @@ do
> >  	[ $fs = ext3 ] && preargs="-F"
> >  	[ $fs = ext4 ] && preargs="-F"
> >  	[ $fs = ext4dev ] && preargs="-F"
> > +	[ $fs = nilfs2 ] && preargs="-q"
> 
> This hunk is unrelated.  Please submit it with a trivial one-liner
> description and a signed-off-by line and I'll put it in.

OK, will do.

> > -echo -e -n "\n\r*** XFS QA 044 - done\n\r\n\r" >/dev/console
> > +printf "\n\r*** XFS QA 044 - done\n\r\n\r" >/dev/console
> 
> This looks okay, but should be mentioned in the patch description.

Will do. It's needed, because sh(1)'s echo builtin doesn't know about -e. 

> >  done
> > -popd >/dev/null
> 
> Same here.

Will do. Standard sh(1) doesn't know popd/pushd either.

Thanks Christoph!


Christian.
-- 
BOFH excuse #398:

Data for intranet got routed through the extranet and landed on the internet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
