Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 44BEC7F52
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 01:41:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28AF5304043
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 23:41:32 -0700 (PDT)
Received: from e28smtp06.in.ibm.com (e28smtp06.in.ibm.com [122.248.162.6]) by
	cuda.sgi.com with ESMTP id A9ZQ9FMy526Hhb9u (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 23:41:29 -0700 (PDT)
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Thu, 26 Sep 2013 12:11:24 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 040A6394004E
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 12:11:05 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8Q6fIxv46727170
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 12:11:18 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8Q6fK2r025930 for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 12:11:20 +0530
Message-ID: <1380177677.2983.7.camel@ThinkPad-T5421>
Subject: Re: [PATCH v2] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 14:41:17 +0800
In-Reply-To: <5242F31B.4060902@sandeen.net>
References: <1379829679.4089.2.camel@ThinkPad-T5421>
	<5241E125.7010902@sgi.com> <1380094327.2526.5.camel@ThinkPad-T5421>
	<5242F31B.4060902@sandeen.net>
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
Cc: xfsprogs <xfs@oss.sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>

On Wed, 2013-09-25 at 09:28 -0500, Eric Sandeen wrote:
> On 9/25/13 2:32 AM, Li Zhong wrote:
> > This patch tries to fix CID 997012, 997013 and 997014 reported by Coverity scan,
> > as suggested by sekharan.
> > 
> > v2: as Mark pointed out, out in the for loop before also needs list to
> > be freed. Also remove out lable as it is not referenced any more.
> 
> Fix itself looks good, thanks!  Love to see the scan numbers change
> for the better.  ;)

Thank you for all the education below. :)

> Nitpicks, though: Patch changelogs usually goes below the "---" so
> the history of trial and error isn't in the commit log.  Not that big
> a deal, it's just convention as mentioned in the kernel SubmittingPatches
> doc:

I think I'll practice it with a 3rd verion.

> 
> > The "---" marker line serves the essential purpose of marking for patch
> > handling tools where the changelog message ends.
> > 
> > One good use for the additional comments after the "---" marker is for
> > a diffstat, to show what files have changed, and the number of
> > inserted and deleted lines per file.  A diffstat is especially useful
> > on bigger patches.  Other comments relevant only to the moment or the
> > maintainer, not suitable for the permanent changelog, should also go
> > here.  A good example of such comments might be "patch changelogs"
> > which describe what has changed between the v1 and v2 version of the
> > patch.
> 
> 
> And since we're on the topic of commit messages lately, this one could
> be improved too I think.
> 
> "CID 997012" won't mean anything to a reader in the future.  It'd be
> better to describe what you're fixing on its own terms.  Something like:
> 
> ===
> If verify_set_primary_sb() completes the secondary sb scanning loop with
> too few valid secondaries found (num_ok < num_sbs / 2), it will immediately
> return without freeing any of the previously allocated memory (variables 
> sb, checked, and any items on the geo list).  This was reported by
> the Coverity scanner as CID 997012, 997013 and 997014.
> 
> Fix this by using the out_free_list: goto target for this error case.
> 
> Earlier, if get_sb() fails in the secondary scan loop, it goes to
> the out: target which does not free any items on the geo list.   Fix
> this by using the out_free_list: target as well, and remove the now-unused
> out: target.
> ===
> 
> On the one hand, the fix isn't that complicated so it probably speaks for
> itself.  But it was complicated enough to warrant discussion & V2 on the list,
> so probably worth including that detail in the final changelog.

OK, I'll use the above as the changelog.

> 
> 
> Also, in looking at this, I wonder if there's another minor buglet.
> 
> in phase1.c, we turn the return value from verify_set_primary_sb() into
> an error string via err_string(rval).  This handles the various
> error returns such as XR_INSUFF_SEC_SB, XR_EOF, etc.  But in the 2nd
> case above (get_sb failure), it simply returns "1" which will be interpreted
> as XR_BAD_MAGIC ("bad magic number").
> 
> get_sb() actually returns several XR_* values, so we should probably capture
> it and use that return value?  That'd be a different patch though.
> 
> I guess the comment for verify_set_primary_sb() would be changed
> then too, now it says:
> 
>  * returns 1 if bad, 0 if ok
> 
> but today we actually return 0, 1, or XR_INSUFF_SEC_SB.
> 
> Not that big a deal, but it seems like the error returns, their handling,
> and associated comments aren't quite consistent.

I'll try to make another patch for the above issue.
Thanks, Zhong

> 
> Thanks,
> -Eric
> 
> 
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > ---
> >  repair/sb.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/repair/sb.c b/repair/sb.c
> > index aa550e3..d34d7a2 100644
> > --- a/repair/sb.c
> > +++ b/repair/sb.c
> > @@ -733,7 +733,7 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
> >  
> >  			if (get_sb(sb, off, size, agno) == XR_EOF)  {
> >  				retval = 1;
> > -				goto out;
> > +				goto out_free_list;
> >  			}
> >  
> >  			if (verify_sb(sb, 0) == XR_OK)  {
> > @@ -756,8 +756,10 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
> >  	/*
> >  	 * see if we have enough superblocks to bother with
> >  	 */
> > -	if (num_ok < num_sbs / 2)
> > -		return(XR_INSUFF_SEC_SB);
> > +	if (num_ok < num_sbs / 2) {
> > +		retval = XR_INSUFF_SEC_SB;
> > +		goto out_free_list;
> > +	}
> >  
> >  	current = get_best_geo(list);
> >  
> > @@ -841,7 +843,6 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
> >  
> >  out_free_list:
> >  	free_geo(list);
> > -out:
> >  	free(sb);
> >  	free(checked);
> >  	return(retval);
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
