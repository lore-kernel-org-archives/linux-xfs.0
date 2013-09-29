Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 51A817F4E
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 01:45:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4A31AC002
	for <xfs@oss.sgi.com>; Sat, 28 Sep 2013 23:45:14 -0700 (PDT)
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143]) by
	cuda.sgi.com with ESMTP id Bg3CSOPDATYaO7Ri (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Sep 2013 23:45:13 -0700 (PDT)
Received: from /spool/local
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Sun, 29 Sep 2013 16:45:09 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id B90A52CE8051
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:45:04 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8T6ira710944810
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:44:53 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8T6j43T008275 for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 16:45:04 +1000
Message-ID: <1380437101.3811.5.camel@ThinkPad-T5421>
Subject: Re: [PATCH] xfsprogs: make log/size consistent for mkfs's -s option
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Sun, 29 Sep 2013 14:45:01 +0800
In-Reply-To: <5245C07A.3000700@sandeen.net>
References: <1380272973.2836.5.camel@ThinkPad-T5421>
	<5245C07A.3000700@sandeen.net>
Mime-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfsprogs <xfs@oss.sgi.com>

On Fri, 2013-09-27 at 12:29 -0500, Eric Sandeen wrote:
> On 9/27/13 4:09 AM, Li Zhong wrote:
> > It seems using -s log is not able to set the sectsz correctly. Because slflag
> > is set but ignored by later codes, so the advertised sector size of the device
> > is used instead.
> 
> (below is just musing about this in general, skip down to the patch for one
> flaw, I think).
> 
> One wonders why it was originally written to accept both, in the first place :(
> 
> And looking at git history, checking only ssflag later was my mistake.  :(
> 
> by the time we're done with getopt, we've got both sectorsize and sectorlog
> set anyway, and we know if it was specified on the commandline.  Maybe we should
> just set them both right after getopt, like:
> 
>         /*
>          * Later code wants to know if the user manually set a value.
>          * There are two ways to specify on the cmdline; as size or as a log.
>          * if either was used, set both flags - from here on it simply means 
>          * "manually set"
>          */
> 
>         if (ssflag || slflag)
>                 ssflag = slflag = 1;
>         <etc for other flags>

I think it is better, after this is done, later code could use one
*sflag to check whether the value is manually set. I will give it a try.

> 
> Anyway, other than one problem below, I think this is ok to solve this
> particular problem.  The others, at least nsflag/nlflag, isflag/ilflag,
> and bsflag/blflag all look ok.
> 
> I just wonder if we need to re-think how this is handled in general,
> so for all of the various (size=|log=) type options, we don't have to
> keep remembering to check both flags.
> 
> (mkfs.xfs is so crufty :(  )
> 
> > $ mkfs.xfs -f -s size=4096 /dev/sdd
> > meta-data=/dev/sdd               isize=256    agcount=2, agsize=4096 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> > 	 ......
> > 
> > $ mkfs.xfs -f -s log=12 /dev/sdd
> > meta-data=/dev/sdd               isize=256    agcount=2, agsize=4096 blks
> >          =                       sectsz=2048  attr=2, projid32bit=1
> > 	 ......
> > 
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > ---
> >  mkfs/xfs_mkfs.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index eafbed3..9243044 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -1693,7 +1693,7 @@ main(
> >  		 * ft.sectoralign will never be set.
> >  		 */
> >  		sectorsize = blocksize;
> > -	} else if (!ssflag) {
> > +	} else if (!ssflag && !slflag) {
> >  		/*
> >  		 * Unless specified manually on the command line use the
> >  		 * advertised sector size of the device.  We use the physical
> > @@ -1721,7 +1721,7 @@ _("switching to logical sector size %d\n"),
> >  		}
> >  	}
> >  
> > -	if (ft.sectoralign || !ssflag) {
> > +	if (ft.sectoralign || !ssflag || !slflag) {
> 
> Shouldn't this be:
> 
> if (ft.sectoralign || (!ssflag && !slflag)) {
> 
> ?  Because today only one or the other can be set;  !ssflag || !slflag will always be true I think.

Sorry, it's my mistake... I'll update it and give a v2. 

Thanks, Zhong

> 
> Thanks,  
> -Eric
> 
> >  		sectorlog = libxfs_highbit32(sectorsize);
> >  		if (loginternal) {
> >  			lsectorsize = sectorsize;
> > @@ -1731,7 +1731,7 @@ _("switching to logical sector size %d\n"),
> >  
> >  	if (sectorsize < XFS_MIN_SECTORSIZE ||
> >  	    sectorsize > XFS_MAX_SECTORSIZE || sectorsize > blocksize) {
> > -		if (ssflag)
> > +		if (ssflag || slflag)
> >  			fprintf(stderr, _("illegal sector size %d\n"), sectorsize);
> >  		else
> >  			fprintf(stderr,
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
