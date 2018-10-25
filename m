Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48802 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbeJYXlh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Oct 2018 19:41:37 -0400
Subject: Re: [PATCH 1/2] xfs_metadump: Extend zapping to multi fsb dir blocks
From: Eric Sandeen <sandeen@sandeen.net>
References: <20181011194424.20306-1-stefanrin@gmail.com>
 <20181011194424.20306-2-stefanrin@gmail.com>
 <c07f1405-0ff0-71e1-56bb-d327d1acd564@sandeen.net>
Message-ID: <01db98e9-286c-102d-7694-5cfbe91138c6@sandeen.net>
Date: Thu, 25 Oct 2018 10:08:25 -0500
MIME-Version: 1.0
In-Reply-To: <c07f1405-0ff0-71e1-56bb-d327d1acd564@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org



On 10/23/18 10:10 AM, Eric Sandeen wrote:
> On 10/11/18 2:44 PM, Stefan Ring wrote:
>> The processing for data zeroing was never added to process_multi_fsb_objects.
>> It is now the same thing that process_single_fsb_objects does.
> 
> First, thanks for doing this, seems about right.
> 
> But I could use more changelog words here.  ;)
> 
> AFAICT, the intent was for process_multi_fsb_objects to call
> process_dir_data_block() in order to handle the zeroing for multi-fsb
> objects, so at least some of the cases /were/ handled, right?
> 
> Your patch seems to be splitting that 3 ways, so we go to 
> process_dir_free_block or process_dir_leaf_block or process_dir_data_block,
> the first two are new cases that are now handled?  (I do see that this is
> the same as the process_single_fsb_objects code.)
> 
> Given the old case:
> 
>                         if ((!obfuscate && !zero_stale_data) ||
>                              o >= mp->m_dir_geo->leafblk) {
>                                 ret = write_buf(iocur_top);
> 
> it looks like we were just directly writing the leaf blocks and
> never obfuscating them, is that correct?  I guess I need to go make
> some test filesystems... do you know from your testing if this is true?

Whoops, I forgot what directory leaf blocks were, sorry - there is nothing
to obfuscate in them.  (but there may be data to zero in them...)

-Eric
