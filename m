Return-Path: <SRS0=9ni0=3C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A02C33CA9
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 15:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E810207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jan 2020 15:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgAMPex (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jan 2020 10:34:53 -0500
Received: from mr013msb.fastweb.it ([85.18.95.104]:35935 "EHLO
        mr013msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgAMPex (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jan 2020 10:34:53 -0500
Received-SPF: pass (mr013msb.fastweb.it: domain assyoma.it designates
 93.63.55.57 as permitted sender) identity=mailfrom;
 receiver=mr013msb.fastweb.it; client-ip=93.63.55.57;
 envelope-from=g.danti@assyoma.it; helo=ceres.assyoma.it;
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedufedrvdejtddgjeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfetuffvhgfguedpucfqfgfvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvfhfhohfkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefiihhonhgrthgrnhcuffgrnhhtihcuoehgrdgurghnthhisegrshhshihomhgrrdhitheqnecuffhomhgrihhnpegrshhshihomhgrrdhithenucfkphepleefrdeifedrheehrdehjeenucfrrghrrghmpehhvghloheptggvrhgvshdrrghsshihohhmrgdrihhtpdhinhgvthepleefrdeifedrheehrdehjedpmhgrihhlfhhrohhmpeeoghdruggrnhhtihesrghsshihohhmrgdrihhtqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeolhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghequcfqtfevrffvpehrfhgtkedvvdenlhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from ceres.assyoma.it (93.63.55.57) by mr013msb.fastweb.it (5.8.208)
        id 5E19B49F00256AEC for linux-xfs@vger.kernel.org; Mon, 13 Jan 2020 16:34:50 +0100
Received: from gdanti-lenovo.assyoma.it (unknown [172.31.255.5])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by ceres.assyoma.it (Postfix) with ESMTPSA id 9EB7226492C;
        Mon, 13 Jan 2020 16:34:50 +0100 (CET)
Subject: Re: XFS reflink vs ThinLVM
To:     linux-xfs@vger.kernel.org
References: <fe697fb6-cef6-2e06-de77-3530700852da@assyoma.it>
 <20200113111025.liaargk3sf4wbngr@orion>
 <703a6c17-cc02-2c2c-31ce-6cd12a888743@assyoma.it>
 <20200113114356.midcgudwxpze3xfw@orion>
 <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
Cc:     "'g.danti@assyoma.it'" <g.danti@assyoma.it>
From:   Gionatan Danti <g.danti@assyoma.it>
Organization: Assyoma s.r.l.
Message-ID: <39b50e2c-cb78-3bcd-0130-defa9c573b71@assyoma.it>
Date:   Mon, 13 Jan 2020 16:34:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <627cb07f-9433-ddfd-37d7-27efedd89727@assyoma.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13/01/20 13:21, Gionatan Danti wrote:
> On 13/01/20 12:43, Carlos Maiolino wrote:
>> I should have mentioned it, my apologies.
>>
>> 'extsize' argument for mkfs.xfs will set the size of the blocks in the RT
>> section.
>>
>> Although, the 'extsize' command in xfs_io, will set the extent size 
>> hints on any
>> file of any xfs filesystem (or filesystem supporting FS_IOC_FSSETXATTR).
>>
>> Notice you can use xfs_io extsize to set the extent size hint to a 
>> directory,
>> and all files under the directory will inherit the same extent hint.
> 
> My bad, I forgot about xfs_io.
> Thanks for the detailed explanation.

Well, I did some test with a reflinked file and I must say I am 
impressed on how well XFS handles small rewrites (for example 4K).

 From my understanding, by mapping at 4K granularity but allocating at 
128K, it avoid most read/write amplification *and* keep low 
fragmentation. After "speculative_cow_prealloc_lifetime" it reclaim the 
allocated but unused space, bringing back any available free space to 
the filesystem. Is this understanding correct?

I have a question: how can I see the allocated-but-unused cow extents? 
For example, giving the following files:

[root@neutron xfs]# stat test.img copy.img
   File: test.img
   Size: 1073741824      Blocks: 2097400    IO Block: 4096   regular file
Device: 810h/2064d      Inode: 131         Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Context: unconfined_u:object_r:unlabeled_t:s0
Access: 2020-01-13 15:40:50.280711297 +0100
Modify: 2020-01-13 16:21:55.564726283 +0100
Change: 2020-01-13 16:21:55.564726283 +0100
  Birth: -

   File: copy.img
   Size: 1073741824      Blocks: 2097152    IO Block: 4096   regular file
Device: 810h/2064d      Inode: 132         Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Context: unconfined_u:object_r:unlabeled_t:s0
Access: 2020-01-13 15:40:50.280711297 +0100
Modify: 2020-01-13 15:40:57.828552412 +0100
Change: 2020-01-13 15:41:48.190492279 +0100
  Birth: -

I can clearly see that test.img has an additional 124K allocated after a 
4K rewrite. This matches my expectation: a 4K rewrite really allocates a 
128K blocks, leading to 124K of temporarily "wasted" space.

But both "filefrag -v" and "xfs_bmap -vep" show only the used space as 
seen by an userspace application (ie: 262144 blocks of 4096 bytes = 
1073741824 bytes).

How can I check the total allocated space as reported by stat?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
