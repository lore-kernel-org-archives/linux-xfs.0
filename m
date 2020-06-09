Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7987DC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 14:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A908207ED
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 14:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T8M9hhHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgFIOYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 10:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbgFIOYW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 10:24:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C124C05BD1E
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2020 07:24:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w20so10367095pga.6
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 07:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmzBj9E07QPYfuOV4Amv+x7lqDWT/P2njkvTllMHfRA=;
        b=T8M9hhHWVD65PjjzxPWaeFTV0g5cPa5lqWTHghJT2PLDQBOf1oKQOWrH1fr4TxX/NJ
         mPMypcJjHTCuDCk8uiAym8BMi8x2V+C5UuOpy8v4w8U2hg/idCva1ytJLDEokm0eI6dW
         YrIOITWEodQjA0MTB1QZ8glLbUSrMhdaHK6YwilPvyo3VcbTq1mO3jA9iuwNnWa3oJaK
         TW/JMTPdzl4LlS7oc4nOl4ntMfI89C7RzaEKj2STfEK6qEY3uitvPy4TBERd2FtecQih
         NiEmJ2GOP8ouRd2fFY5kDt8agUMVEFJKRZbxUSvXqEfX9wZtThFaETI4NfTIAkog/G6w
         0j/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmzBj9E07QPYfuOV4Amv+x7lqDWT/P2njkvTllMHfRA=;
        b=Z/8EXb/xawd80ZraoH1XSCQDfXNfvkN8RIaKT1XavPOrqVCI1m7nH0LcTmkm86Ls8r
         0Ddp7afG2hLKGj8Zrz5RoOyolsokCh6gR4dQtUXr+s0aPrXLUGEMCBqhiTbvmRkYypNu
         8KI4BcMSbH5gKnjO/xUfcqovk6Tro+wko3TmTaPbkvqvpiy3NguRrSztDfeAlQD2bBsD
         Pim0DCoT3IYVMPDORbg+nMwlppcIPZS133D0fwSgQZnUKMQA2IcORwCrQo8DoaQ6B0Li
         jG74QGZFZlbyswIsqUrEcTuTsUEEvZMzu/hm45yT2Lblm/iSbPWgN5atIhQhOpgxIrl1
         OyRA==
X-Gm-Message-State: AOAM530W6mE7Il/uJG7zvqyrhOhxWnaFO2Vig1/pXzhB0ktIk37gWNbn
        TsDGlgnxRdZF9nwtfmIp+Vo=
X-Google-Smtp-Source: ABdhPJzrMTI8Y7Sf+mDFr651/JXtyFx1YePdyZqtP/y7X7/ye2321nqmWMIARgrFmpxjAuAbE6r5Rw==
X-Received: by 2002:a63:ff52:: with SMTP id s18mr25293142pgk.203.1591712661331;
        Tue, 09 Jun 2020 07:24:21 -0700 (PDT)
Received: from garuda.localnet ([171.48.18.33])
        by smtp.gmail.com with ESMTPSA id z8sm8697384pgc.80.2020.06.09.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:24:20 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 5/7] xfs: Use 2^27 as the maximum number of directory extents
Date:   Tue, 09 Jun 2020 19:53:38 +0530
Message-ID: <8795894.UgMtLVWHnv@garuda>
In-Reply-To: <20200608165217.GE1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200606082745.15174-6-chandanrlinux@gmail.com> <20200608165217.GE1334206@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 8 June 2020 10:22:17 PM IST Darrick J. Wong wrote:
> On Sat, Jun 06, 2020 at 01:57:43PM +0530, Chandan Babu R wrote:
> > The maximum number of extents that can be used by a directory can be
> > calculated as shown below. (FS block size is assumed to be 512 bytes
> > since the smallest allowed block size can create a BMBT of maximum
> > possible height).
> > 
> > Maximum number of extents in data space =
> > XFS_DIR2_SPACE_SIZE / 2^9 = 32GiB / 2^9 = 2^26.
> > 
> > Maximum number (theoretically) of extents in leaf space =
> > 32GiB / 2^9 = 2^26.
> 
> Hm.  The leaf hash entries are 8 bytes long, whereas I think directory
> entries occupy at least 16 bytes.  Is there a situation where the number
> of dir leaf/dabtree blocks can actually hit the 32G section size limit?

I don't think so. The 2^26 extents above was a theoretical limit. I wanted to
prove that even with the theoretical limit, the maximum number of extents used
by a directory is much less than 2^47 extents.

> 
> > Maximum number of entries in a free space index block
> > = (512 - (sizeof struct xfs_dir3_free_hdr)) / (sizeof struct
> >                                                xfs_dir2_data_off_t)
> > = (512 - 64) / 2 = 224
> > 
> > Maximum number of extents in free space index =
> > (Maximum number of extents in data segment) / 224 =
> > 2^26 / 224 = ~2^18
> > 
> > Maximum number of extents in a directory =
> > Maximum number of extents in data space +
> > Maximum number of extents in leaf space +
> > Maximum number of extents in free space index =
> > 2^26 + 2^26 + 2^18 = ~2^27
> 
> I calculated the exact expression here, and got:
> 
> 2^26 + 2^26 + (2^26/224) = 134,517,321
> 
> This requires 28 bits of space, doesn't it?

You are right.

Log_2(134,517,321) returns 27.003. Since I had assumed a theoretical maximum
for the "leaf space extent count", I had rounded it down to 27 bits. I will
change this to 28 bits.

> 
> Granted I bet the leaf section won't come within 300,000 nextents of the
> 2^26 you've assumed for it, so I suspect that in real world scenarios,
> 27 bits is enough.  But if you're anticipating a totally full leaf
> section under extreme fragmentation, then MAXDIREXTNUM ought to be able
> to handle that.
> 
> (Assuming I did any of that math correctly. ;))
> 
> --D
> 
> > 
> > This commit defines the macro MAXDIREXTNUM to have the value 2^27 and
> > this in turn is used in calculating the maximum height of a directory
> > BMBT.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c  | 2 +-
> >  fs/xfs/libxfs/xfs_types.h | 1 +
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 8b0029b3cecf..f75b70ae7b1f 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -81,7 +81,7 @@ xfs_bmap_compute_maxlevels(
> >  	if (whichfork == XFS_DATA_FORK) {
> >  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
> >  		if (dir_bmbt)
> > -			maxleafents = MAXEXTNUM;
> > +			maxleafents = MAXDIREXTNUM;
> >  		else
> >  			maxleafents = MAXEXTNUM;
> >  	} else {
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 397d94775440..0a3041ad5bec 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -60,6 +60,7 @@ typedef void *		xfs_failaddr_t;
> >   */
> >  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> >  #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> > +#define	MAXDIREXTNUM	((xfs_extnum_t)0x7ffffff)	/* 27 bits */
> >  #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> >  
> >  /*
> 


-- 
chandan



