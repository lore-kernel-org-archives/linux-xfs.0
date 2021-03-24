Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C03CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 10:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9FDC61993
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 10:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhCXKrD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 06:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhCXKqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 06:46:54 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46770C061763;
        Wed, 24 Mar 2021 03:46:53 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q11so7706153pld.11;
        Wed, 24 Mar 2021 03:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=cRPbWLqsrCVnDSAZCiqDcrV/O58L/L3nAvuvsKRM09k=;
        b=MNZxKObuZplvjdA4uShIhvxfLASZR3VyMgGYAeeC6D93eC0IEAjr6ibYTDbuaHhPz2
         Onoo4GpvXgq1G6nUOAazqlBTD8M8MQQUwcTgZplbaDmaJ85ULF7YjTMdhS0VCnPLS3qf
         C9vlr+JDL1lTzhIDOvgxMiGukFh51w4j++aYuYU6YcYFVMsAFI6SbwvNBl40iCZVfptH
         5aiaH091jPrOyWT9F83ZWkoh5rcLQ/AGpS1cs0lQ1Wx+3kO9w/d+6DPIGHvqmj1r0ZMZ
         GUL/eZ2WLrh3raeY1pNE+3Ac7EI6VfdiucC77UxMICYl1Tj+CU0Jc8M6tWEBX7eACzsL
         XpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=cRPbWLqsrCVnDSAZCiqDcrV/O58L/L3nAvuvsKRM09k=;
        b=q1KtGx75cNdIZZ7BYuKwf3CDfWWY3R1eBiUzUub6sCOPjqzzfBvzQcu1ub5eA7/gD6
         F2jbLezU0xwLoQpE53N8PpRtYdvdVR5lEzXVCE/COToojSj9BLA1QwHDw4I/0D+hX22X
         Kjjb5Vs1AINVGaGoUgi1KlXQzPMdNYB/YrK6MRzCfv2uDHtf8wfRJIh37Ntuo1VmGMVb
         KWO2J0lg4c5txttG+1NiR1bPrr7QLxbP2IXHhZ/VYuM07vY1uzMWPRvWjmV3315EpmwV
         nw/GE8bf5UMC3kFb6VTN+jqnMP3IFQCH9BsuXoOQByi1kQS9PnP8R1d7KUkG0GhBEHQg
         LpNQ==
X-Gm-Message-State: AOAM533AQxONv47mtwEEftB/ovEOEjmhWihflmN4MkCdJEIiJ13jUJ2/
        4y5/OI7CplggKUvkifXSjGgIw6gJvRk=
X-Google-Smtp-Source: ABdhPJxBHn680TUyI69FPCUZ4lFr0WESaNG9dSt8EaNZw1xQq7ArueVfYBE1i6MCzA0z33JO0XWpxw==
X-Received: by 2002:a17:90a:df91:: with SMTP id p17mr2837067pjv.23.1616582812388;
        Wed, 24 Mar 2021 03:46:52 -0700 (PDT)
Received: from garuda ([171.61.69.55])
        by smtp.gmail.com with ESMTPSA id f2sm2118752pju.46.2021.03.24.03.46.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Mar 2021 03:46:51 -0700 (PDT)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-6-chandanrlinux@gmail.com> <20210322175652.GG1670408@magnolia> <87r1k56f7k.fsf@garuda> <20210323205730.GN22100@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 05/13] xfs: Check for extent overflow when growing realtime bitmap/summary inodes
In-reply-to: <20210323205730.GN22100@magnolia>
Date:   Wed, 24 Mar 2021 16:16:48 +0530
Message-ID: <871rc43k2v.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 24 Mar 2021 at 02:27, Darrick J. Wong wrote:
> On Tue, Mar 23, 2021 at 09:21:27PM +0530, Chandan Babu R wrote:
>> On 22 Mar 2021 at 23:26, Darrick J. Wong wrote:
>> > On Tue, Mar 09, 2021 at 10:31:16AM +0530, Chandan Babu R wrote:
>> >> Verify that XFS does not cause realtime bitmap/summary inode fork's
>> >> extent count to overflow when growing the realtime volume associated
>> >> with a filesystem.
>> >>
>> >> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> >> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> >
>> > Soo... I discovered that this test doesn't pass with multiblock
>> > directories:
>>
>> Thanks for the bug report and the description of the corresponding solution. I
>> am fixing the tests and will soon post corresponding patches to the mailing
>> list.
>
> Also, I found a problem with xfs/534 when it does the direct write tests
> to a pmem volume with DAX enabled:
>
> --- /tmp/fstests/tests/xfs/534.out      2021-03-21 11:44:09.384407426 -0700
> +++ /var/tmp/fstests/xfs/534.out.bad    2021-03-23 13:32:15.898301839 -0700
> @@ -5,7 +5,4 @@
>  Fallocate 15 blocks
>  Buffered write to every other block of fallocated space
>  Verify $testfile's extent count
> -* Direct write to unwritten extent
> -Fallocate 15 blocks
> -Direct write to every other block of fallocated space
> -Verify $testfile's extent count
> +Extent count overflow check failed: nextents = 11

The inode extent overflow reported above was actually due to the buffered
write operation. But it does occur with direct write operation as well.

I was able to recreate the bug with an emulated pmem device on my qemu guest.

>
> looking at the xfs_bmap output for $testfile shows:
>
> /opt/testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>    0: [0..7]:          208..215          0 (208..215)           8 010000
>    1: [8..15]:         216..223          0 (216..223)           8 000000
>    2: [16..23]:        224..231          0 (224..231)           8 010000
>    3: [24..31]:        232..239          0 (232..239)           8 000000
>    4: [32..39]:        240..247          0 (240..247)           8 010000
>    5: [40..47]:        248..255          0 (248..255)           8 000000
>    6: [48..55]:        256..263          0 (256..263)           8 010000
>    7: [56..63]:        264..271          0 (264..271)           8 000000
>    8: [64..71]:        272..279          0 (272..279)           8 010000
>    9: [72..79]:        280..287          0 (280..287)           8 000000
>   10: [80..119]:       288..327          0 (288..327)          40 010000
>
> Which is ... odd since the same direct write gets cut off after writing
> to block 7 (like you'd expect since it's the same function) when DAX
> isn't enabled...
>
> ...OH, I see the problem.  For a non-DAX direct write,
> xfs_iomap_write_direct will allocate an unwritten block into a hole, but
> if the block was already mapped (written or unwritten) it won't do
> anything at all.  For that case, XFS_IEXT_ADD_NOSPLIT_CNT is sufficient,
> because in the worst case we add one extent to the data fork.
>
> For DAX writes, however, the behavior is different:
>
> 	if (IS_DAX(VFS_I(ip))) {
> 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
> 		if (imap->br_state == XFS_EXT_UNWRITTEN) {
> 			force = true;
> 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
> 		}
> 	}
>
> This tells xfs_bmapi_write that we want to /convert/ an unwritten extent
> to written, and we want to zero the blocks.  If we're dax-writing into
> the middle of an unwritten range, this will cause a split.  The correct
> parameter there would be XFS_IEXT_WRITE_UNWRITTEN_CNT.  Would you mind
> sending a kernel patch to fix that?

Sure, I will work on fixing both the buffered and direct IO extent overflow
issues.

Thanks for reporting the bug.

--
chandan
