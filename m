Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA417C19F28
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 15:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiHCPO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 11:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiHCPO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 11:14:57 -0400
X-Greylist: delayed 1085 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 03 Aug 2022 08:14:55 PDT
Received: from cczrelay02.in2p3.fr (cczrelay02.in2p3.fr [134.158.66.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F223A492
        for <linux-xfs@vger.kernel.org>; Wed,  3 Aug 2022 08:14:55 -0700 (PDT)
Received: from cczmbox08.in2p3.fr (cczmbox08.in2p3.fr [134.158.66.138])
        by cczrelay02.in2p3.fr (8.14.4/8.14.4) with ESMTP id 273Euh2b015741
        for <linux-xfs@vger.kernel.org>; Wed, 3 Aug 2022 16:56:43 +0200
Date:   Wed, 3 Aug 2022 16:56:43 +0200 (CEST)
From:   Emmanouil Vamvakopoulos <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
Reply-To: Emmanouil Vamvakopoulos 
          <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
To:     linux-xfs@vger.kernel.org
Message-ID: <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr>
In-Reply-To: <1586129076.70820212.1659538177737.JavaMail.zimbra@ijclab.in2p3.fr>
References: <1586129076.70820212.1659538177737.JavaMail.zimbra@ijclab.in2p3.fr>
Subject: s_bmap and  flags explanation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [90.26.79.197]
X-Mailer: Zimbra 8.7.11_GA_3865 (ZimbraWebClient - FF103 (Mac)/8.7.11_GA_3865)
Thread-Topic: s_bmap and flags explanation
Thread-Index: UqNvU8JZxZ04lq01qs/KAVsT9pnUa/yuahuv
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Hello developers 

It is possible to explain the FLAGS field in xfs_bmap output of a file 

 EXT: FILE-OFFSET           BLOCK-RANGE              AG AG-OFFSET                 TOTAL FLAGS
   0: [0..7]:               49700520968..49700520975 30 (8..15)                       8 001111
   1: [8..4175871]:         49708756480..49712932343 30 (8235520..12411383)     4175864 000111
   2: [4175872..19976191]:  49715788288..49731588607 30 (15267328..31067647)   15800320 000011
   3: [19976192..25153535]: 49731588608..49736765951 30 (31067648..36244991)    5177344 000011
   4: [25153536..41930743]: 49767625216..49784402423 30 (67104256..83881463)   16777208 000111
   5: [41930744..58707951]: 49784402424..49801179631 30 (83881464..100658671)  16777208 001111
   6: [58707952..58959935]: 49801179632..49801431615 30 (100658672..100910655)   251984 001111
   7: [58959936..75485159]: 49801431616..49817956839 30 (100910656..117435879) 16525224 001111

with 

[disk06]# du -sh ./00000869/014886f4
36G	./00000869/014886f4
[disk06]# du -sh --apparent-size  ./00000869/014886f4
29G	./00000869/014886f4

I try to understand if  this file contains unused externs 
and how those file are created like this (if we assume that the free space was not fragmented ) 

we are running CentOS Stream release 8 with 4.18.0-383.el8.x86_64 

if I defrag the file above the difference bewteen apparent size and size with du disappered !

thank you in advance
best
e.v.
