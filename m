Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51434 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753927AbdDDURR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 16:17:17 -0400
Subject: Re: [xfsprogs] Do we need so many data types for user input?
References: <CACj3i738tUsYyRvQmr3NfPQ=P2FNruh2xsr1TAuLMJ69AV0a0w@mail.gmail.com>
 <20170404194825.GX28800@wotan.suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5784453e-dc91-1e26-451d-3afea138adbf@sandeen.net>
Date: Tue, 4 Apr 2017 15:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <20170404194825.GX28800@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/4/17 2:48 PM, Luis R. Rodriguez wrote:
> On Tue, Apr 04, 2017 at 10:54:09AM +0200, Jan Tulak wrote:
>> Simply stated, signed values seem to be useless here. And at the end
>> of the day, we are converting all numbers into unsigned in one part of
>> the parsing anyway, so I don't see how such a change could change any
>> behaviour.
>>
>> So what do you think, can I remove the other types in user-input part
>> of the code and save all numbers as uint64?
> 
> This seems reasonable to me, I could not find any valid use for negative values,
> yet we have int all over. No bueno.
> 
> That seems like a small pedantic correction we can make, but to be clear I think it
> something we can fix not by changing struct subopt_param but rather just the
> data types for the specific values, for instance:
> 
>         int                     inodelog;                                       
>         int                     isize;                                          
>         int                     ilflag;
> 
> My point about struct subopt_param is that the usage of long long is there from
> a practical point of view of the tradition to give us the ability to later
> convert any value to any data type in between. So while I agree that negative
> values are not used right now, and we should use a correct unsigned data type,
> I think keeping long long on struct subopt_param makes sense.
> 
> From what I can tell we only need generally for all input values 0 - UINT_MAX,
> and  if we were to use for instance uint64_t we would still generally cap to
> UINT_MAX on mkfs.xfs for now and if we want later we bump to ULLONG_MAX without
> much changes.
> 
> Perhaps the two exceptions worth reviewing in light of whether or not to generally
> max out to UINT_MAX or ULONG_MAX right now seem to be possibly be:
> 
>         __uint64_t              agcount;                                        
>         __uint64_t              agsize; 
> 
> agcount has a boundary limit though: XFS_MAX_AGNUMBER :
> 
> mkfs/xfs_mkfs.c:                  .maxval = XFS_MAX_AGNUMBER,
> include/xfs_multidisk.h:#define XFS_MAX_AGNUMBER        ((xfs_agnumber_t)(NULLAGNUMBER - 1))
> libxfs/xfs_types.h:#define      NULLAGNUMBER    ((xfs_agnumber_t)-1)
> typedef __uint32_t      xfs_agnumber_t; /* allocation group number */           
> 
> Sicne this is u32 UINT_MAX should suffice.

yep.

> 
> And then agsize is capped artificially later via validate_ag_geometry():
> 
>         if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
> 		...
> 	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
> 		...
> 	if (agsize > dblocks) {
> 		...
> 	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
> 		...
> 
> Its not clear if this is capped at UINT_MAX or if we need ULLONG_MAX here.

.maxval = XFS_AG_MAX_BYTES,

#define XFS_AG_MAX_BYTES        ((XFS_AG_BYTES(31)))    /* 1 TB */
#define XFS_AG_BYTES(bblog)     ((long long)BBSIZE << (bblog))

so the maximum is (long long)(512) << 31

so, no - agsize won't fit in a 32 bit var, if that's the question...

-Eric
