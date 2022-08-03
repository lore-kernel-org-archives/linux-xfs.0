Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530F9C19F2B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 21:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbiHCV7T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 17:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbiHCV7O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 17:59:14 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 177C25C362
        for <linux-xfs@vger.kernel.org>; Wed,  3 Aug 2022 14:59:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-20-138.pa.nsw.optusnet.com.au [49.195.20.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0408310C8BBE;
        Thu,  4 Aug 2022 07:59:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oJMOT-008pd8-CL; Thu, 04 Aug 2022 07:59:09 +1000
Date:   Thu, 4 Aug 2022 07:59:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Emmanouil Vamvakopoulos <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: s_bmap and  flags explanation
Message-ID: <20220803215909.GC3600936@dread.disaster.area>
References: <1586129076.70820212.1659538177737.JavaMail.zimbra@ijclab.in2p3.fr>
 <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62eaefb0
        a=cxZHBGNDieHvTKNp/pucQQ==:117 a=cxZHBGNDieHvTKNp/pucQQ==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=3GCWSBI63u-s0kUigocA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 03, 2022 at 04:56:43PM +0200, Emmanouil Vamvakopoulos wrote:
> 
> 
> Hello developers 
> 
> It is possible to explain the FLAGS field in xfs_bmap output of a file 
> 
>  EXT: FILE-OFFSET           BLOCK-RANGE              AG AG-OFFSET                 TOTAL FLAGS
>    0: [0..7]:               49700520968..49700520975 30 (8..15)                       8 001111
>    1: [8..4175871]:         49708756480..49712932343 30 (8235520..12411383)     4175864 000111
>    2: [4175872..19976191]:  49715788288..49731588607 30 (15267328..31067647)   15800320 000011
>    3: [19976192..25153535]: 49731588608..49736765951 30 (31067648..36244991)    5177344 000011
>    4: [25153536..41930743]: 49767625216..49784402423 30 (67104256..83881463)   16777208 000111
>    5: [41930744..58707951]: 49784402424..49801179631 30 (83881464..100658671)  16777208 001111
>    6: [58707952..58959935]: 49801179632..49801431615 30 (100658672..100910655)   251984 001111
>    7: [58959936..75485159]: 49801431616..49817956839 30 (100910656..117435879) 16525224 001111

$ man xfs_bmap
.....
       -v     Shows verbose information. When this flag is specified,
	      additional AG specific information is appended to each
	      line in the following form:

                   agno (startagoffset..endagoffset) nblocks flags

              A second -v option will print out the flags legend.
.....

So:

$ xfs_bmap -vvp foo
foo:
 EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET        TOTAL FLAGS
   0: [0..7]:          440138672..440138679  4 (687024..687031)     8 000000
 FLAG Values:
    0100000 Shared extent
    0010000 Unwritten preallocated extent
    0001000 Doesn't begin on stripe unit
    0000100 Doesn't end   on stripe unit
    0000010 Doesn't begin on stripe width
    0000001 Doesn't end   on stripe width

And there's what the flags mean.

> with 
> 
> [disk06]# du -sh ./00000869/014886f4
> 36G	./00000869/014886f4
> [disk06]# du -sh --apparent-size  ./00000869/014886f4
> 29G	./00000869/014886f4
> 
> I try to understand if  this file contains unused externs 
> and how those file are created like this (if we assume that the free space was not fragmented ) 
> 
> we are running CentOS Stream release 8 with 4.18.0-383.el8.x86_64 
> 
> if I defrag the file above the difference bewteen apparent size and size with du disappered !

It will be a result of speculative preallocation beyond EOF as the
file is grown to ensure it doesn't get fragmented badly. Files in
the size range of tens of GB or larger will have preallocation
extend out to 8GB beyond EOF. It will get removed when the inode is
reclaimed from memory (i.e. no longer in active use).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
