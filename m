Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752477AbdDDTs1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 15:48:27 -0400
Date: Tue, 4 Apr 2017 21:48:25 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [xfsprogs] Do we need so many data types for user input?
Message-ID: <20170404194825.GX28800@wotan.suse.de>
References: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 04, 2017 at 10:54:09AM +0200, Jan Tulak wrote:
> Simply stated, signed values seem to be useless here. And at the end
> of the day, we are converting all numbers into unsigned in one part of
> the parsing anyway, so I don't see how such a change could change any
> behaviour.
> 
> So what do you think, can I remove the other types in user-input part
> of the code and save all numbers as uint64?

This seems reasonable to me, I could not find any valid use for negative values,
yet we have int all over. No bueno.

That seems like a small pedantic correction we can make, but to be clear I think it
something we can fix not by changing struct subopt_param but rather just the
data types for the specific values, for instance:

        int                     inodelog;                                       
        int                     isize;                                          
        int                     ilflag;

My point about struct subopt_param is that the usage of long long is there from
a practical point of view of the tradition to give us the ability to later
convert any value to any data type in between. So while I agree that negative
values are not used right now, and we should use a correct unsigned data type,
I think keeping long long on struct subopt_param makes sense.

>From what I can tell we only need generally for all input values 0 - UINT_MAX,
and  if we were to use for instance uint64_t we would still generally cap to
UINT_MAX on mkfs.xfs for now and if we want later we bump to ULLONG_MAX without
much changes.

Perhaps the two exceptions worth reviewing in light of whether or not to generally
max out to UINT_MAX or ULONG_MAX right now seem to be possibly be:

        __uint64_t              agcount;                                        
        __uint64_t              agsize; 

agcount has a boundary limit though: XFS_MAX_AGNUMBER :

mkfs/xfs_mkfs.c:                  .maxval = XFS_MAX_AGNUMBER,
include/xfs_multidisk.h:#define XFS_MAX_AGNUMBER        ((xfs_agnumber_t)(NULLAGNUMBER - 1))
libxfs/xfs_types.h:#define      NULLAGNUMBER    ((xfs_agnumber_t)-1)
typedef __uint32_t      xfs_agnumber_t; /* allocation group number */           

Sicne this is u32 UINT_MAX should suffice.

And then agsize is capped artificially later via validate_ag_geometry():

        if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
		...
	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
		...
	if (agsize > dblocks) {
		...
	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
		...

Its not clear if this is capped at UINT_MAX or if we need ULLONG_MAX here.

If it is capped at UINT_MAX then at least from the parsed input values from
user on mkfs.xfs then it would seem all would have a max cap at UINT_MAX and
all would also have a general min at 0.

As for actually making the code changes though:

Although changing data types for all these input values is quite a bit of code
churn I think picking something unsigned would be good practice for us (I noted
why uint64_t would be good above). If we use these local variables however to
call out to *other* code in other files, the code churn will probably be too
much for now and perhaps we can leave this for later as an after step.
Something like coccinelle can help us change all that crap later.

If changing the types however would only have local impact I think its a worthy
change to consider now.

FWIW since I had made the mkfs.xfs.conf RFCs I determined what the local variables
of impact would be, they are (I added struct mkfs_xfs_opts to stuff them all on one
data structure):

struct mkfs_xfs_opts {                                                          
        int                     blocklog;                                       
        int                     blflag;                                         
        int                     bsflag;                                         
                                                                                
        struct fsxattr          fsx;                                            
        libxfs_init_t           xi;                                             
        __uint64_t              agcount;                                        
        __uint64_t              agsize;                                         
        int                     daflag;                                         
        int                     ssflag;                                         
        int                     dasize;                                         
        char                    *dsize;                                         
        int                     dsunit;                                         
        int                     dswidth;                                        
        int                     dsu;                                            
        int                     dsw;                                            
        int                     nodsflag;                                       
        int                     sectorlog;                                      
        int                     slflag;                                         
                                                                                
        struct sb_feat_args     sb_feat;                                        
        int                     inodelog;                                       
        int                     isize;                                          
        int                     ilflag;                                         
        int                     imaxpct;                                        
        int                     imflag;                                         
        int                     ipflag;                                         
        int                     isflag;                                         
        int                     inopblock;   

        xfs_agnumber_t          logagno;                                        
        int                     laflag;                                         
        int                     liflag;                                         
        int                     lsuflag;                                        
        int                     lsu;                                            
        int                     loginternal;                                    
        char                    *logfile;                                       
        char                    *logsize;                                       
        int                     lsectorlog;                                     
        int                     lsectorsize;                                    
        int                     lsunit;                                         
        int                     lsunitflag;                                     
        int                     ldflag;                                         
        int                     lvflag;                                         
        int                     lslflag;                                        
        int                     lssflag;                                        
        uuid_t                  uuid;                                           
                                                                                
        int                     dirblocklog;                                    
        int                     dirblocksize;                                   
        int                     nlflag;                                         
        int                     nvflag; /* unused */                            
        int                     nsflag;                                         
                                                                                
        char                    *rtextsize;                                     
        char                    *rtsize;                                        
        int                     norsflag;                                       
}; 

Of course if we had other variables on main() which were set based on the above
ones then those would also be impacted.

  Luis
