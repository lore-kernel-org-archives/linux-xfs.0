Return-Path: <SRS0=qbJ3=ZP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A302C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 18:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66EF92068D
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 18:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKWS0b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Nov 2019 13:26:31 -0500
Received: from sandeen.net ([63.231.237.45]:56482 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbfKWS0b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Nov 2019 13:26:31 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 78FEE2AD0;
        Sat, 23 Nov 2019 12:24:59 -0600 (CST)
Subject: Re: Bug when mounting XFS with external SATA drives in USB enclosures
To:     Pedro Ribeiro <pedrib@gmail.com>, linux-xfs@vger.kernel.org
References: <a3ab6c1b-1a69-5926-706f-1976b20d38a8@gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <2543ac40-63ba-7a33-8ec5-2ef0797c6cc6@sandeen.net>
Date:   Sat, 23 Nov 2019 12:26:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a3ab6c1b-1a69-5926-706f-1976b20d38a8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/22/19 9:21 PM, Pedro Ribeiro wrote:
> Hi,
> 
> I have been trying to find out the cause of a bug that's affecting all
> my external hard drive backups.
> 
> I have three external drives, in different USB enclosures, with the same
> configuration and the same problem.
> 
> Drive A: 2TB HDD, USB3 Seagate self enclosed drive
> Drive B: 4TB HDD, USB3 Toshiba self enclosed drive
> Drive C: 512MB SSD, Crucial MX500 with USB-C third party enclosure
> 
> All of the drives have a dm-crypt / LUKS on top, with a XFS partition
> inside. Drive A is a few months old, Drive B is about 3 years old, drive
> C about 1.5 years old. They are seldomly used (they're backup drives) so
> they are all fine mechanically.
> 
> The problem is when I attach any of the drives, enter the LUKS password
> and then try to mount, this happens:
> [   66.039772] XFS (dm-0): Mounting V5 Filesystem
> [   66.060934] XFS (dm-0): log recovery read I/O error at daddr 0x0 len
> 8 error -5
> [   66.060939] XFS (dm-0): empty log check failed
> [   66.060940] XFS (dm-0): log mount/recovery failed: error -5
> [   66.061064] XFS (dm-0): log mount failed

I assume that it used to work, right?  When did it stop working?
<reads further, sees 5.3>

> No matter what I do, using all the recovery tools, etc, it's impossible
> to mount...
> 
> The thing is that is there is NOTHING wrong with these drives. The above
> happens when running my specific, stripped and locked down kernel config.
> 
> If I take Debian's 4.19 kernel config, put it on a 5.3.11 tree, run make
> oldconfig and just answer the defaults on all prompts, all of the drives
> above mount fine:
> [   46.184068] XFS (dm-0): Mounting V5 Filesystem
> [   46.412566] XFS (dm-0): Ending clean mount

> I hit this problem recently when I moved from kernel 4.18.20, which I
> was using for a long time, to 5.3.X. In kernel 4.18.20, I did not have
> any problems with my specific stripped down config.

Could be related to memory alignment.  Commit:

commit f8f9ee479439c1be9e33c4404912a2a112c46200
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 26 12:08:39 2019 -0700

    xfs: add kmem_alloc_io()
    
    Memory we use to submit for IO needs strict alignment to the
    underlying driver contraints. Worst case, this is 512 bytes. Given
    that all allocations for IO are always a power of 2 multiple of 512
    bytes, the kernel heap provides natural alignment for objects of
    these sizes and that suffices.

went into kernel 5.4, and doesn't look like it's in the 5.3.x stable
stream.

I haven't looked very closely at your config deltas for what might change
alignment but it'd be worth giving:

f8f9ee479439 xfs: add kmem_alloc_io()
d916275aa4dd xfs: get allocation alignment from the buftarg
0ad95687c3ad xfs: add kmem allocation trace points

a try.

-Eric

> I have asked for help in IRC at #xfs, and one of the guys there (ailiop)
> was very helpful in trying to track down the problem, but we ultimately
> failed, hence why I'm asking for help here.
> 
> I'm attaching the kernel configs and the dmesg outputs. There is nothing
> obvious in the kernel config diff that should make this happen... it's a
> very weird bug.
> 
> Regards,
> Pedro
> 
