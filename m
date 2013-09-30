Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 106447F5A
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 00:24:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6A61304032
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:24:47 -0700 (PDT)
Received: from e23smtp03.au.ibm.com (e23smtp03.au.ibm.com [202.81.31.145]) by
	cuda.sgi.com with ESMTP id nw2yifWIdjl66iEJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 22:24:46 -0700 (PDT)
Received: from /spool/local
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Mon, 30 Sep 2013 15:24:44 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 47F5E2BB0040
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 15:24:39 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8U57iB39044278
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 15:07:44 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8U5OcnM007301 for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 15:24:39 +1000
Message-ID: <1380518675.2985.18.camel@ThinkPad-T5421>
Subject: Re: [PATCH] xfsprogs: cleanup size/log setting flags of mkfs
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Mon, 30 Sep 2013 13:24:35 +0800
In-Reply-To: <5248ECAA.1010506@sandeen.net>
References: <1380272973.2836.5.camel@ThinkPad-T5421>
	<5245C07A.3000700@sandeen.net> <1380437441.3811.9.camel@ThinkPad-T5421>
	<1380445971.3811.14.camel@ThinkPad-T5421>
	<20130929230638.GG26872@dastard>
	<1380510260.2985.4.camel@ThinkPad-T5421> <5248ECAA.1010506@sandeen.net>
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

On Sun, 2013-09-29 at 22:14 -0500, Eric Sandeen wrote:
> On 9/29/13 10:04 PM, Li Zhong wrote:
> > On Mon, 2013-09-30 at 09:06 +1000, Dave Chinner wrote:
> >> On Sun, Sep 29, 2013 at 05:12:51PM +0800, Li Zhong wrote:
> >>> As Eric suggested, we could set both of the size/log flags after we have
> >>> parsed the options - and from there on it simply means "manually set".
> >>>
> >>> After that, we could use just one flag, e.g. *sflag, to check whether 
> >>> the corresponding value is manually set or not.
> >>
> >> It's a start, but I'm not sure that it is an improvement or not.
> >> i.e. you're adding yet another piece of logic to the already
> >> tortured argument parsing and flag setting.
> >>
> >> This could be done in the argument parsing itself, without needing
> >> separate post-processing code. e.g. changing the parsing code like
> >> so:
> >>
> >> 	case N_LOG:
> >> 		if (!value || *value == '\0')
> >> 			reqval('n', nopts, N_LOG);
> >> -		if (nlflag)
> >> +		if (nlflag > 1)
> >> 			respec('n', nopts, N_LOG);
> >> 		if (nsflag)
> >> 			conflict('n', nopts, N_SIZE,
> >> 				 N_LOG);
> >> +		nlflag = 2;
> >> 		dirblocklog = atoi(value);
> >> 		if (dirblocklog <= 0)
> >> 			illegal(value, "n log");
> >> +		nsflag = 1;
> >> 		dirblocksize = 1 << dirblocklog;
> >> -		nlflag = 1;
> >> 		break;
> >>
> >> Would acheive exactly the same thing - i.e.
> >> a value of 1 means it was initialised, a value of 2 means it was a
> >> command line parameter...
> >>
> >> This means the code checks can be cleaned up as you have done, but
> >> we don't need a separate post-processing step for the arguments to
> >> set flags that weren't set...
> > 
> > Thank you for the suggestion, I will try this approach. 
> > I think It could also preserve the information which suboption is used
> > actually in the command line through the main() function, though it
> > seems not needed currently. 
> 
> sounds good to me too; just watch out for the conflict/respec stuff to
> be sure it all still works... I wasn't super happy with my suggestion
> after I made it, I guess. :)

:)
I just sent out the code, hope I didn't make some silly mistakes...

Please help to review, though I might only be able to check mail ~ten
days later -- we have a long holiday starting from tomorrow :)

Thanks, Zhong

> 
> -Eric
> 
> > Thanks, Zhong
> >>
> >>
> >>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> >>> ---
> >>>  mkfs/xfs_mkfs.c | 29 ++++++++++++++++++++++-------
> >>>  1 file changed, 22 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >>> index 34bf2ff..aa3f391 100644
> >>> --- a/mkfs/xfs_mkfs.c
> >>> +++ b/mkfs/xfs_mkfs.c
> >>> @@ -1667,11 +1667,26 @@ main(
> >>>  		dfile = xi.dname;
> >>>  
> >>>  	/*
> >>> +	 * Later code wants to know if the user manually set a value.
> >>> +	 * There are two ways to specify on the cmdline; as size or as a log.
> >>> +	 * if either was used, set both flags - from here on it simply means
> >>> +	 * "manually set"
> >>> +	 */
> >>> +	if (bsflag || blflag)
> >>> +		bsflag = blflag = 1;
> >>> +	if (ssflag || slflag)
> >>> +		ssflag = slflag = 1;
> >>> +	if (isflag || ilflag)
> >>> +		isflag = ilflag = 1;
> >>> +	if (nsflag || nlflag)
> >>> +		nsflag = nlflag = 1;
> >>
> >> You missed the log sector size/log flags.
> >>
> >> Cheers,
> >>
> >> Dave.
> > 
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
