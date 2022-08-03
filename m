Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660A7C19F28
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 15:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbiHCPz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 11:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbiHCPzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 11:55:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD70AE5E
        for <linux-xfs@vger.kernel.org>; Wed,  3 Aug 2022 08:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD6DFB822E5
        for <linux-xfs@vger.kernel.org>; Wed,  3 Aug 2022 15:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81DCC433C1;
        Wed,  3 Aug 2022 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659542052;
        bh=QzB5VBqzUilc/0yNk4tTa1OI8KyyMZ99PKJ+AkVacF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mivYvcM5jHBR2smBAG6kPsF97OX4wNWljbVNm+RZ30QNGJ7xx8TY3Beh5oF3d5fyR
         cSFmqiU6jzar9EEsJGZv3HJUpvlFiymFomUD4H7GBP9GxpJD5OrAY26fhwXBzkGl3y
         G0DdCsYcZJ9rs4Bw79k3dLJLzmLA8OgVHupC3N27CX6YTWyIGO0sNIYrhYtAmgcBUn
         CQ1s+zXNN4KJ0ex4+4BOt5ZS+1AJrnGDYBpDhcgMTuaidIknZ1m5P7IECn5N+i+Ghf
         UdUHFpq1QfKIreoAD90RwZEIsfR7oimOzPZ92Icp1ReW/pZKAbN98Qq/hyfUQUQ93Y
         trROLTNCv8l9A==
Date:   Wed, 3 Aug 2022 17:54:08 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Emmanouil Vamvakopoulos <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: s_bmap and  flags explanation
Message-ID: <20220803155408.46dmuebhxxkgaofq@orion>
References: <1586129076.70820212.1659538177737.JavaMail.zimbra@ijclab.in2p3.fr>
 <Ugekc6GTR7V4VH8hhwODwp2Rmz8L6i8-bvTq517zo_VIhZGBKjcef5BZWfERJiQNDTOxhKNSPYvyz9lw4hiPoA==@protonmail.internalid>
 <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 03, 2022 at 04:56:43PM +0200, Emmanouil Vamvakopoulos wrote:
> 
> 
> Hello developers
> 
> It is possible to explain the FLAGS field in xfs_bmap output of a file

Flags bits for each extent:

FLG_SHARED      0100000 /* shared extent */
FLG_PRE         0010000 /* Unwritten extent */
FLG_BSU         0001000 /* Not on begin of stripe unit  */
FLG_ESU         0000100 /* Not on end   of stripe unit  */
FLG_BSW         0000010 /* Not on begin of stripe width */
FLG_ESW         0000001 /* Not on end   of stripe width */

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
> 

Disclaimer: I am not sure exactly how du accounts for --aparent-size.

Said that, xfs_bmap shows you the current block mapping of the file you
mentioned using 512 blocks. According to the mapping above, this file is mapped
into 75485160 512-byte blocks, so:

(75485160*512)/(1024**3) = 35.99

> [disk06]# du -sh ./00000869/014886f4
> 36G	./00000869/014886f4

Matching the size here.


> [disk06]# du -sh --apparent-size  ./00000869/014886f4
> 29G	./00000869/014886f4

According to du's man page:

       --apparent-size
              print  apparent  sizes  rather  than device usage; although the
	      apparent size is usually smaller, it may be larger due to holes
	      in ('sparse') files, internal fragmentation, indirect blocks, and
	      the like

Giving the stripe misalignment flags set on all the extents I'd say this is the
main reason for why --apparent-size differs so much, if the writes being done to
the file are not stripe aligned, each stripe unity might be wasting some space.
> 
> I try to understand if  this file contains unused externs
> and how those file are created like this (if we assume that the free space was not fragmented )

Maybe your FS is on top of a striped volume and the FS itself is not
configured with the correct unity/width?
This is a guess btw, I may very well be wrong and it be related to something
else :)

> if I defrag the file above the difference bewteen apparent size and size with du disappered !


-- 
Carlos Maiolino
