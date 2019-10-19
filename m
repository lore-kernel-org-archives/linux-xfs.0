Return-Path: <SRS0=7yvF=YM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF3DCA9EAB
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 23:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F83121744
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Oct 2019 23:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfJSXpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Oct 2019 19:45:14 -0400
Received: from sandeen.net ([63.231.237.45]:54922 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfJSXpN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Oct 2019 19:45:13 -0400
Received: from Liberator-6.local (cheqtel-68.234.65-ISG-240.airstreamcomm.net [68.234.65.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 52419D5C;
        Sat, 19 Oct 2019 18:44:29 -0500 (CDT)
Subject: Re: Fragmentation metadata checks incomplete in
 process_bmbt_reclist()
To:     =?UTF-8?Q?Marc_Sch=c3=b6nefeld?= <marc.schoenefeld@gmx.org>,
        linux-xfs@vger.kernel.org
References: <trinity-b2a494bf-39e0-40f4-ab08-641fbb2757c3-1571271883137@3c-app-gmx-bs59>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <7facba23-500a-214f-33b4-78e4de5edcaa@sandeen.net>
Date:   Sat, 19 Oct 2019 18:45:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <trinity-b2a494bf-39e0-40f4-ab08-641fbb2757c3-1571271883137@3c-app-gmx-bs59>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/16/19 7:24 PM, "Marc Schönefeld" wrote:
> Hi all, 
>  
> there seems to be a problem with correctly rejecting invalid metadata when using the frag command. This was tested with xfsprogs-dev, the 5.2.1 tarball, and 4.190 as in CentOS8).  
>  
> xfsprogs-dev/db/xfs_db -c frag ../xfsprogs_xfs_db_c_frag_convert_extent_invalid_read.xfsfile
>  
> Metadata CRC error detected at 0x42c836, xfs_agf block 0x1/0x200
> xfs_db: cannot init perag data (74). Continuing anyway.
> Metadata CRC error detected at 0x457316, xfs_agi block 0x2/0x200
> Metadata CRC error detected at 0x45e2ed, xfs_inobt block 0x18/0x1000
> Metadata corruption detected at 0x429885, xfs_inode block 0x1b00/0x8000
>  
> Program received signal SIGSEGV, Segmentation fault.
> convert_extent (rp=rp@entry=0x1537000, op=op@entry=0x7ffd95f7e020, sp=sp@entry=0x7ffd95f7e028, cp=cp@entry=0x7ffd95f7e018, 
>     fp=fp@entry=0x7ffd95f7e014) at ../include/xfs_arch.h:249
>  249 return (uint64_t)get_unaligned_be32(p) << 32 |
>  250                            get_unaligned_be32(p + 4);
>  251 }

As Dave mentioned elsewhere, xfs_db is a developer tool and it does its best
to carry on in the face of trouble...

The "frag" command is largely useless (as its output states) and the normal course
of action if it detects corruption (even if it coredumps as a result) would be to
run xfs_repair to fix it, and try again.

If you want to send a patch to handle this more gracefully, I'd review it, but I'm
not likely to spend any time digging into it because this is not a problem any
user is likely to face.  If their filesystem is corrupted, inability to run "frag"
is the least of their problems.

-Eric

> (gdb) bt
> #0  convert_extent (rp=rp@entry=0x1537000, op=op@entry=0x7ffd95f7e020, sp=sp@entry=0x7ffd95f7e028, 
>     cp=cp@entry=0x7ffd95f7e018, fp=fp@entry=0x7ffd95f7e014) at ../include/xfs_arch.h:249
> #1  0x0000000000416211 in process_bmbt_reclist (rp=0x1537000, numrecs=<optimized out>, extmapp=extmapp@entry=0x7ffd95f7e068)
>     at frag.c:229
> #2  0x0000000000416685 in process_btinode (whichfork=<optimized out>, extmapp=<optimized out>, dip=<optimized out>)
>     at ../include/xfs_arch.h:145
> #3  process_fork (dip=dip@entry=0x150e800, whichfork=whichfork@entry=0) at frag.c:287
> #4  0x0000000000416a81 in process_inode (agf=0x1506a00, dip=0x150e800, agino=6913) at frag.c:337
> #5  scanfunc_ino (block=0x1508200, level=level@entry=0, agf=agf@entry=0x1506a00) at frag.c:513
> #6  0x0000000000416cc5 in scan_sbtree (agf=agf@entry=0x1506a00, root=3, nlevels=1, btype=TYP_INOBT, 
>     func=0x416750 <scanfunc_ino>) at frag.c:416
> #7  0x0000000000416f2d in scan_ag (agno=0) at ../include/xfs_arch.h:158
> #8  frag_f (argc=<optimized out>, argv=<optimized out>) at frag.c:155
> #9  0x00000000004029e0 in main (argc=<optimized out>, argv=<optimized out>) at init.c:195
> (gdb) disass $pc,$pc+10
> Dump of assembler code from 0x405210 to 0x40521a:
> => 0x0000000000405210 <convert_extent+0>: mov    rax,QWORD PTR [rdi]
>    0x0000000000405213 <convert_extent+3>: mov    rdi,QWORD PTR [rdi+0x8]
>    0x0000000000405217 <convert_extent+7>: bswap  rax
> End of assembler dump.
> (gdb) info registers rdi
> rdi            0x1537000           22245376
> (gdb) x/4 $rdi
> 0x1537000: Cannot access memory at address 0x1537000
>  
> If required I can provide an image that triggers the issue via pm. 
>  
> Regards
> Marc Schoenefeld
> 
