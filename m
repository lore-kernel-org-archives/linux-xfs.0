Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81FCC19F2D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 13:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiHDNaa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 09:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239498AbiHDNa3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 09:30:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527502870F
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 06:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 138BDB824B3
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 13:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0137C433D7;
        Thu,  4 Aug 2022 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659619825;
        bh=RPNupy9VCCTJZuHI+6QCjqpQmt/P0eHlZMX44It7eJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gLhukxIt4t2y/uzbnVAbcyO309hinGHqIRfAcJR3ear/s8IxteksOAQHP+fQzUFaH
         sG+fLcVNEGrt8dDIvb7Mp3S+85AZj5dusbBVVErjQhAjFoC95LV9rsj6bA1osi1LRn
         KWt20vOoE+SMqLWiVh0bv+NgOCpaCFgd+u5f4QWiDxgfmvu1eOy6n8fTBgnxWjudsi
         lNyCBTgiMiv6guLltW7ADMKn7T99tyhWLbr6ujAOfe76cgsjlVZR5GUr9gs40o5Vpl
         dsyP00YMtyvYtAM1r5jF+W7qTSdjnRPkhXG0z6ouCpcgUXh2fX7wmQarQomIPEiNT0
         v5YrUp5TVJtlA==
Date:   Thu, 4 Aug 2022 15:30:21 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Emmanouil Vamvakopoulos <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: s_bmap and  flags explanation
Message-ID: <20220804133021.ki75itxlax5orhtm@orion>
References: <1586129076.70820212.1659538177737.JavaMail.zimbra@ijclab.in2p3.fr>
 <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr>
 <20220803215909.GC3600936@dread.disaster.area>
 <AgUB8JDD9GyGo3pv3T1To10P0kvTEdvPH04vzHDuqzpt9gAknyHUcys_w0KbnkGe9EvfLJehdrXKi6soVqLvuA==@protonmail.internalid>
 <789765075.71120211.1659608731638.JavaMail.zimbra@ijclab.in2p3.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <789765075.71120211.1659608731638.JavaMail.zimbra@ijclab.in2p3.fr>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.

On Thu, Aug 04, 2022 at 12:25:31PM +0200, Emmanouil Vamvakopoulos wrote:
> hello Carlos and Dave
> 
> thank you for the replies
> 
> a) for the mismatch in alignment bewteen xfs  and underlying raid volume I have to re-check
> but from preliminary tests , when I mount the partition with a static allocsize ( e.g. allocsize=256k)
> we have large file with large number of externs ( up to 40) but the sizes from du was comparable.

allocsize mount option controls the EOF preallocation size, which, by default is
dynamic, so, you just fixed it to a small size, and it might well be the reason
why you ended up with so many extents, as the main goal of speculative
preallocation is to try to reduce fragmentation by creating bigger extents, and
as Dave mentioned, the extra space will be removed after file is closed.
I'm not the best to explain details on speculative preallocation, but I suppose
you're seeing a closer size report from du modes due the smaller preallocated
space, even though you have more extents, the extra preallocated space is still
very small.

> 
> b) for the speculative preallocation beyond EOF of my files as I understood have to run xfs_fsr to get the space back.

No, speculative preallocation is dynamically removed.


> 
> but why the inodes of those files remains dirty  at least for 300 sec  after the  closing of the file and lost the automatic removal of the preallocation ?
> 

IIRC, speculative preallocated blocks can be kept around even after the file is
closed, I believe append-only files are one example of that, where the
speculative preallocated blocks will be kept after a file is closed.
But I don't have a deep knowledge on the speculative prealloc algorithm to give
more details.

But I'm pretty sure it's tied up with the file's write patterns, maybe you can
describe more how this file is written to?


> we are runing on CentOS Stream release 8 with 4.18.0-383.el8.x86_64
> 
> but we never see something simliar on CentOS Linux release 7.9.2009 (Core) with  3.10.0-1160.45.1.el7.x86_64
> (for similar pattern of file sizes, but truly with different distributed strorage application)
> 

That's a question more for the distribution not for the upstream project =/
unlikely somebody will remember what changed between 3.10 and 4.18 and also what
the distribution backported (or not).

> 
> 
> 
> ----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "emmanouil vamvakopoulos" <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
> Cc: "linux-xfs" <linux-xfs@vger.kernel.org>
> Sent: Wednesday, 3 August, 2022 23:59:09
> Subject: Re: s_bmap and  flags explanation
> 
> On Wed, Aug 03, 2022 at 04:56:43PM +0200, Emmanouil Vamvakopoulos wrote:
> >
> >
> > Hello developers
> >
> > It is possible to explain the FLAGS field in xfs_bmap output of a file
> >
> >  EXT: FILE-OFFSET           BLOCK-RANGE              AG AG-OFFSET                 TOTAL FLAGS
> >    0: [0..7]:               49700520968..49700520975 30 (8..15)                       8 001111
> >    1: [8..4175871]:         49708756480..49712932343 30 (8235520..12411383)     4175864 000111
> >    2: [4175872..19976191]:  49715788288..49731588607 30 (15267328..31067647)   15800320 000011
> >    3: [19976192..25153535]: 49731588608..49736765951 30 (31067648..36244991)    5177344 000011
> >    4: [25153536..41930743]: 49767625216..49784402423 30 (67104256..83881463)   16777208 000111
> >    5: [41930744..58707951]: 49784402424..49801179631 30 (83881464..100658671)  16777208 001111
> >    6: [58707952..58959935]: 49801179632..49801431615 30 (100658672..100910655)   251984 001111
> >    7: [58959936..75485159]: 49801431616..49817956839 30 (100910656..117435879) 16525224 001111
> 
> $ man xfs_bmap
> .....
>        -v     Shows verbose information. When this flag is specified,
> 	      additional AG specific information is appended to each
> 	      line in the following form:
> 
>                    agno (startagoffset..endagoffset) nblocks flags
> 
>               A second -v option will print out the flags legend.
> .....
> 
> So:
> 
> $ xfs_bmap -vvp foo
> foo:
>  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET        TOTAL FLAGS
>    0: [0..7]:          440138672..440138679  4 (687024..687031)     8 000000
>  FLAG Values:
>     0100000 Shared extent
>     0010000 Unwritten preallocated extent
>     0001000 Doesn't begin on stripe unit
>     0000100 Doesn't end   on stripe unit
>     0000010 Doesn't begin on stripe width
>     0000001 Doesn't end   on stripe width
> 
> And there's what the flags mean.
> 
> > with
> >
> > [disk06]# du -sh ./00000869/014886f4
> > 36G	./00000869/014886f4
> > [disk06]# du -sh --apparent-size  ./00000869/014886f4
> > 29G	./00000869/014886f4
> >
> > I try to understand if  this file contains unused externs
> > and how those file are created like this (if we assume that the free space was not fragmented )
> >
> > we are running CentOS Stream release 8 with 4.18.0-383.el8.x86_64
> >
> > if I defrag the file above the difference bewteen apparent size and size with du disappered !
> 
> It will be a result of speculative preallocation beyond EOF as the
> file is grown to ensure it doesn't get fragmented badly. Files in
> the size range of tens of GB or larger will have preallocation
> extend out to 8GB beyond EOF. It will get removed when the inode is
> reclaimed from memory (i.e. no longer in active use).
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

-- 
Carlos Maiolino
