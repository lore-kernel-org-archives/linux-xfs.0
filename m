Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A52AA7F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 20:57:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18C56AC008
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 18:57:17 -0700 (PDT)
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [122.248.162.5]) by
	cuda.sgi.com with ESMTP id iupjIOaRcKf6o14r (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 18:57:15 -0700 (PDT)
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Tue, 27 Aug 2013 07:20:37 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 945291258043
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 07:27:00 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7R1v7JY47579354
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 07:27:07 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r7R1v9Oi010467 for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 07:27:09 +0530
Message-ID: <1377568627.2502.13.camel@ThinkPad-T5421>
Subject: Re: [PATCH] xfsprogs: fix Out-of-bounds access in repair/dinode.c
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Tue, 27 Aug 2013 09:57:07 +0800
In-Reply-To: <20130826165123.GW7153@sgi.com>
References: <1376287861.2822.13.camel@ThinkPad-T5421>
	<5214EFFF.4060105@sgi.com> <20130823163828.GS5262@sgi.com>
	<1377483327.2834.7.camel@ThinkPad-T5421>
	<20130826165123.GW7153@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Rich Johnston <rjohnston@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On Mon, 2013-08-26 at 11:51 -0500, Ben Myers wrote:
> Hey Zhong,
> 
> On Mon, Aug 26, 2013 at 10:15:27AM +0800, Li Zhong wrote:
> > On Fri, 2013-08-23 at 11:38 -0500, Ben Myers wrote:
> > > Hey Rich and Li Zhong,
> > > 
> > > On Wed, Aug 21, 2013 at 11:51:11AM -0500, Rich Johnston wrote:
> > > > Looks good, thanks for the patch Li Zhong. it has been committed.
> > > > 
> > > > --Rich
> > > > 
> > > > Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> > > > 
> > > > commit e7c05095f5baa9cd2e35a6de03d7dd9f51dd3910
> > > > Author: Li Zhong <zhong@linux.vnet.ibm.com>
> > > > Date:   Mon Aug 12 06:11:01 2013 +0000
> > > > 
> > > >     xfsprogs: fix Out-of-bounds access in repair/dinode.c
> > > > 
> > > > On 08/12/2013 01:11 AM, Li Zhong wrote:
> > > > >Following is reported by coverity in bug 1061528:
> > > > >
> > > > >187                        __dirty_no_modify_ret(dirty);
> > > > >
> > > > >CID 1061528 (#1 of 1): Out-of-bounds access (OVERRUN)53. overrun-buffer-arg: Overrunning array "dinoc->di_pad" of 6 bytes by passing it to a function which accesses it at byte offset 15 using argument "16UL".
> > > > >188                        memset(dinoc->di_pad, 0, 16);
> > > > >
> > > > >It seems that di_pad here should be di_pad2, as sekharan pointed out.
> > > > >
> > > > >Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > > > >---
> > > > >  repair/dinode.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >
> > > > >diff --git a/repair/dinode.c b/repair/dinode.c
> > > > >index e607f0b..94bf2f8 100644
> > > > >--- a/repair/dinode.c
> > > > >+++ b/repair/dinode.c
> > > > >@@ -183,9 +183,9 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
> > > > >  	}
> > > > >
> > > > >  	for (i = 0; i < 16; i++) {
> > > > >-		if (dinoc->di_pad[i] != 0) {
> > > > >+		if (dinoc->di_pad2[i] != 0) {
> > > > >  			__dirty_no_modify_ret(dirty);
> > > > >-			memset(dinoc->di_pad, 0, 16);
> > > > >+			memset(dinoc->di_pad2, 0, 16);
> > > > >  			break;
> > > > >  		}
> > > > >  	}
> > > 
> > > We also discussed this issue a bit in this thread:
> > > http://oss.sgi.com/archives/xfs/2013-08/msg00228.html
> > > 
> > > Looks like the loop itself is incorrect and should be removed, and Eric has
> > > suggested that the conditional be changed to a memcmp in case the size of the
> > > pad changes in the future.  Would either of you care to spin up another patch
> > > to clean it up?
> > 
> > Hi Ben, 
> > 
> > If I understand correctly, we need to change 16 to be a sizeof the
> > di_pad2 array(like the fix attached below)? 
> > 
> > It seems to me that the loop is needed to check all of the 16 entries in
> > the array? 
> 
> You are correct.  We need the loop...
> 
> > Thanks, Zhong
> > 
> > ---
> > diff --git a/repair/dinode.c b/repair/dinode.c
> > index b2b9a95..7469fc8 100644
> > --- a/repair/dinode.c
> > +++ b/repair/dinode.c
> > @@ -182,10 +182,10 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
> >  		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
> >  	}
> >  
> > -	for (i = 0; i < 16; i++) {
> > +	for (i = 0; i < sizeof(dinoc->di_pad2)/sizeof(dinoc->di_pad2[0]); i++) {
> 
> Just sizeof(dinoc->di_pad2) would be enough here, right?  No need for the
> division I think.

I think the division could be used to calculate the number of elements
in the array(16). But yes, in this case, as the element in the array is
1 byte in size, so it's the same whether we add the division or not. 

> 
> >  		if (dinoc->di_pad2[i] != 0) {
> >  			__dirty_no_modify_ret(dirty);
> > -			memset(dinoc->di_pad2, 0, 16);
> > +			memset(dinoc->di_pad2, 0, sizeof(dinoc->di_pad2));
> 						  ^^^^^^^^^^^^^^^^^^^^^^
> 
> That guy will return 16, so we'll memset off the end of di_pad2.
> sizeof(dinoc->di_pad2[0]) would work.

I think we need to memset the whole array, if we find some non-zero
value there. 

Thanks, Zhong

> 
> Thanks!
> -Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
