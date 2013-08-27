Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 888DE7F3F
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 21:02:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EF6F8F804C
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 19:02:04 -0700 (PDT)
Received: from e28smtp03.in.ibm.com (e28smtp03.in.ibm.com [122.248.162.3]) by
	cuda.sgi.com with ESMTP id QrEzj4bO9Z86hf64 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Aug 2013 19:02:02 -0700 (PDT)
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Tue, 27 Aug 2013 07:24:10 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id EF1761258051
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 07:31:48 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7R21trC37290016
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 07:31:55 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r7R21w2H004542 for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 07:31:58 +0530
Message-ID: <1377568915.2502.17.camel@ThinkPad-T5421>
Subject: Re: [PATCH] xfsprogs: fix Out-of-bounds access in repair/dinode.c
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Tue, 27 Aug 2013 10:01:55 +0800
In-Reply-To: <20130826174030.GX5262@sgi.com>
References: <1376287861.2822.13.camel@ThinkPad-T5421>
	<5214EFFF.4060105@sgi.com> <20130823163828.GS5262@sgi.com>
	<521B8E51.6090405@sandeen.net> <20130826174030.GX5262@sgi.com>
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
Cc: Rich Johnston <rjohnston@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On Mon, 2013-08-26 at 12:40 -0500, Ben Myers wrote:
> Hey,
> 
> On Mon, Aug 26, 2013 at 12:20:17PM -0500, Eric Sandeen wrote:
> > On 8/23/13 11:38 AM, Ben Myers wrote:
> > > Hey Rich and Li Zhong,
> > > 
> > > On Wed, Aug 21, 2013 at 11:51:11AM -0500, Rich Johnston wrote:
> > >> Looks good, thanks for the patch Li Zhong. it has been committed.
> > >>
> > >> --Rich
> > >>
> > >> Reviewed-by: Rich Johnston <rjohnston@sgi.com>
> > >>
> > >> commit e7c05095f5baa9cd2e35a6de03d7dd9f51dd3910
> > >> Author: Li Zhong <zhong@linux.vnet.ibm.com>
> > >> Date:   Mon Aug 12 06:11:01 2013 +0000
> > >>
> > >>     xfsprogs: fix Out-of-bounds access in repair/dinode.c
> > >>
> > >> On 08/12/2013 01:11 AM, Li Zhong wrote:
> > >>> Following is reported by coverity in bug 1061528:
> > >>>
> > >>> 187                        __dirty_no_modify_ret(dirty);
> > >>>
> > >>> CID 1061528 (#1 of 1): Out-of-bounds access (OVERRUN)53. overrun-buffer-arg: Overrunning array "dinoc->di_pad" of 6 bytes by passing it to a function which accesses it at byte offset 15 using argument "16UL".
> > >>> 188                        memset(dinoc->di_pad, 0, 16);
> > >>>
> > >>> It seems that di_pad here should be di_pad2, as sekharan pointed out.
> > >>>
> > >>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > >>> ---
> > >>>  repair/dinode.c | 4 ++--
> > >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> > >>>
> > >>> diff --git a/repair/dinode.c b/repair/dinode.c
> > >>> index e607f0b..94bf2f8 100644
> > >>> --- a/repair/dinode.c
> > >>> +++ b/repair/dinode.c
> > >>> @@ -183,9 +183,9 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
> > >>>  	}
> > >>>
> > >>>  	for (i = 0; i < 16; i++) {
> > >>> -		if (dinoc->di_pad[i] != 0) {
> > >>> +		if (dinoc->di_pad2[i] != 0) {
> > >>>  			__dirty_no_modify_ret(dirty);
> > >>> -			memset(dinoc->di_pad, 0, 16);
> > >>> +			memset(dinoc->di_pad2, 0, 16);
> > >>>  			break;
> > >>>  		}
> > >>>  	}
> > > 
> > > We also discussed this issue a bit in this thread:
> > > http://oss.sgi.com/archives/xfs/2013-08/msg00228.html
> > > 
> > > Looks like the loop itself is incorrect and should be removed, and Eric has
> > > suggested that the conditional be changed to a memcmp in case the size of the
> > > pad changes in the future.  Would either of you care to spin up another patch
> > > to clean it up?
> > 
> > I think I was confused; it seems fine as it is in git, not sure what I was
> > thinking.
> > 
> > memcmp can't use a bare "0" as an arg, so it's not ideal to use either.
> > 
> > Not a huge fan of the hard-coded 16, but I think the code is correct now; we
> > can probably move on to real problems.  ;)
> 
> 185         for (i = 0; i < 16; i++) {
> 186                 if (dinoc->di_pad2[i] != 0) {
> 187                         __dirty_no_modify_ret(dirty);
> 188                         memset(dinoc->di_pad2, 0, 16);
> 189                         break;
> 190                 }
> 191         }
> 
> D'oh!  I was mistaken too!
> 	
> I was thinking that line 188 read 'memset(&dinoc->di_pad2[i], 0, 16);' and that
> we were going off the end of the array as i increased...  Teach me to look a
> little closer.

I see, hehe

> 
> I agree that the current code is fine.
> 
> Apologies to Rich and Zhong.

No problem, and after the discussion, maybe we could improve the code by
removing the hard-coded 16 :)

Thanks, Zhong

> 
> -Ben
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
