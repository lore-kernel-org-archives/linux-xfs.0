Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51726C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 03:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31C1E60234
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 03:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhG1DPn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 23:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhG1DPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 23:15:42 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29559C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 20:15:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so7932125pjb.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 20:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=StadgBd5kX72nJV8TLPoAqQQRjZfnuKaP/hW7GHsweM=;
        b=gaN5yvYU1C5PKEyCmuBxokk6zL5x66DIIVYyf6mebHIOOONQYu5bGe+x14Odgl1dAK
         zOTzW5AERBXpz9Z8a5JuD0UicxbMkVc8xE9VSxXECVDkZDX1gHUnrqegzgS85xap7lye
         cOY/rTXESnV9X1N+MehnfVBmHFQhofMmsANdPgsHuOo2ItDJLzIy60foWcbJZ1cNItII
         xYP/SIDJ7l2cewYeNX/HSfpumZcPDuJR4KOBdPnz6pfrhtQ+e9Nrb8zt3osqUGXdbXVS
         fYU1t+Fae2kCaTUv0uvL6DBlc7vFZkSA4+ItZ6gyIBiQQcl9JkC723CyGmhknetOlB09
         IoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=StadgBd5kX72nJV8TLPoAqQQRjZfnuKaP/hW7GHsweM=;
        b=rLDcBXmQJstjsM8r5P4GsELLZIMl9whfV0q31wfm//kEKvSRiA84Qryj/C8q8yJ4c3
         1w4unwzylLPl2wxLF51G4kwaFbqngaiQ1s3E4YRAT9JQBfcO39xmpcCej2oqUVPqVAkF
         mDka6h4q57JVSj4rrUdq9uO+nFVQsGfxpFUlC1lS4grZOK93Q5xGelz9uFB8D0A4W1t0
         4GapTfEC9rmJPmuxJP56tb6me9IcJyk7IoTaBdSfULbSl2BXkE3K3I+afTGldtkYHI0k
         sjxqDmBV8p+xKi3sX0/kOoom0lnfIITEeZNugIRX4hzokcj3xvvko0L3MIa+PxXt6khd
         joxQ==
X-Gm-Message-State: AOAM532NF5hMR3Q8uxxFBD4ibbBBWEykls+3o5bHLy2rJVih9roI1aWL
        bjuetlX1lzemb9hSoOmhLHMqZbVD6Ax14w==
X-Google-Smtp-Source: ABdhPJzB7eB6AX8s0xGt2el8ag6sr+YYEb5SCR6TXjRxkyKrS7ftXeyMicbGoJNy31avI+Zwkj/Exg==
X-Received: by 2002:a17:902:e80f:b029:12b:5cb8:dbf5 with SMTP id u15-20020a170902e80fb029012b5cb8dbf5mr21673631plg.30.1627442140476;
        Tue, 27 Jul 2021 20:15:40 -0700 (PDT)
Received: from garuda ([122.171.208.125])
        by smtp.gmail.com with ESMTPSA id o1sm335592pfp.84.2021.07.27.20.15.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 20:15:40 -0700 (PDT)
References: <20210726114541.24898-1-chandanrlinux@gmail.com> <20210726114541.24898-3-chandanrlinux@gmail.com> <20210727215611.GK559212@magnolia> <20210727220318.GN559212@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 02/12] xfs: Rename MAXEXTNUM, MAXAEXTNUM to XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
In-reply-to: <20210727220318.GN559212@magnolia>
Date:   Wed, 28 Jul 2021 08:45:36 +0530
Message-ID: <87eebjw2lj.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 28 Jul 2021 at 03:33, Darrick J. Wong wrote:
> On Tue, Jul 27, 2021 at 02:56:11PM -0700, Darrick J. Wong wrote:
>> On Mon, Jul 26, 2021 at 05:15:31PM +0530, Chandan Babu R wrote:
>> > In preparation for introducing larger extent count limits, this commit renames
>> > existing extent count limits based on their signedness and width.
>> > 
>> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> > ---
>> >  fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
>> >  fs/xfs/libxfs/xfs_format.h     | 8 ++++----
>> >  fs/xfs/libxfs/xfs_inode_buf.c  | 4 ++--
>> >  fs/xfs/libxfs/xfs_inode_fork.c | 3 ++-
>> >  fs/xfs/scrub/inode_repair.c    | 2 +-
>> >  5 files changed, 11 insertions(+), 10 deletions(-)
>> > 
>> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> > index f3c9a0ebb0a5..8f262405a5b5 100644
>> > --- a/fs/xfs/libxfs/xfs_bmap.c
>> > +++ b/fs/xfs/libxfs/xfs_bmap.c
>> > @@ -76,10 +76,10 @@ xfs_bmap_compute_maxlevels(
>> >  	 * available.
>> >  	 */
>> >  	if (whichfork == XFS_DATA_FORK) {
>> > -		maxleafents = MAXEXTNUM;
>> > +		maxleafents = XFS_IFORK_EXTCNT_MAXS32;
>> 
>> I'm not in love with these names, since they tell me roughly about the
>> size of the constant (which I could glean from the definition) but less
>> about when I would expect to find them.  How about:
>> 
>> #define XFS_MAX_DFORK_NEXTENTS    ((xfs_extnum_t) 0x7FFFFFFF)
>> #define XFS_MAX_AFORK_NEXTENTS    ((xfs_aextnum_t)0x00007FFF)
>
> Or, given that 'DFORK' already means 'ondisk fork', how about:
>
> XFS_MAX_DATA_NEXTENTS
> XFS_MAX_ATTR_NEXTENTS

Yes, I agree. These names are better. I will incorporate your suggestions
before posting V3.

>
> ?
>
> --D
>
>> 
>> and when we get to the iext64 feature (or whatever we end up calling it)
>> then we can define new ones:
>> 
>> #define XFS_MAX_DFORK_NEXTENTS64  ((xfs_extnum_t) 0xFFFFFFFFFFFF)
>> #define XFS_MAX_AFORK_NEXTENTS64  ((xfs_aextnum_t)0x0000FFFFFFFF)
>> 
>> or something like that.
>> 
>> >  		sz = xfs_bmdr_space_calc(MINDBTPTRS);
>> >  	} else {
>> > -		maxleafents = MAXAEXTNUM;
>> > +		maxleafents = XFS_IFORK_EXTCNT_MAXS16;
>> >  		sz = xfs_bmdr_space_calc(MINABTPTRS);
>> >  	}
>> >  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
>> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
>> > index 37cca918d2ba..920e3f9c418f 100644
>> > --- a/fs/xfs/libxfs/xfs_format.h
>> > +++ b/fs/xfs/libxfs/xfs_format.h
>> > @@ -1110,11 +1110,11 @@ enum xfs_dinode_fmt {
>> >  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>> >  
>> >  /*
>> > - * Max values for extlen, extnum, aextnum.
>> > + * Max values for extlen and disk inode's extent counters.
>> >   */
>> > -#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */
>> 
>> As for MAXEXTLEN... would you mind tacking a new patch on the end to fix
>> its definition as well?  It /really/ ought to be based on the disk
>> format definitions and not open-coded.
>> 
>> #define XFS_MAX_EXTLEN		((xfs_extlen_t)(1 << BMBT_BLOCKCOUNT_BITLEN) - 1)
>> 
>> --D
>> 
>> > -#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
>> > -#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */
>> > +#define	MAXEXTLEN		((uint32_t)0x1fffff) /* 21 bits */
>> > +#define XFS_IFORK_EXTCNT_MAXS32 ((int32_t)0x7fffffff)  /* Signed 32-bits */
>> > +#define XFS_IFORK_EXTCNT_MAXS16 ((int16_t)0x7fff)      /* Signed 16-bits */
>> >  
>> >  /*
>> >   * Inode minimum and maximum sizes.
>> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
>> > index 5625df1ddd95..66d13e8fa420 100644
>> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
>> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
>> > @@ -365,9 +365,9 @@ xfs_dinode_verify_fork(
>> >  		break;
>> >  	case XFS_DINODE_FMT_BTREE:
>> >  		if (whichfork == XFS_ATTR_FORK) {
>> > -			if (di_nextents > MAXAEXTNUM)
>> > +			if (di_nextents > XFS_IFORK_EXTCNT_MAXS16)
>> >  				return __this_address;
>> > -		} else if (di_nextents > MAXEXTNUM) {
>> > +		} else if (di_nextents > XFS_IFORK_EXTCNT_MAXS32) {
>> >  			return __this_address;
>> >  		}
>> >  		break;
>> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> > index 801a6f7dbd0c..6f4b14d3d381 100644
>> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> > @@ -736,7 +736,8 @@ xfs_iext_count_may_overflow(
>> >  	if (whichfork == XFS_COW_FORK)
>> >  		return 0;
>> >  
>> > -	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
>> > +	max_exts = (whichfork == XFS_ATTR_FORK) ?
>> > +		XFS_IFORK_EXTCNT_MAXS16 : XFS_IFORK_EXTCNT_MAXS32;
>> >  
>> >  	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
>> >  		max_exts = 10;
>> > diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
>> > index a80cd633fe59..c44f8d06939b 100644
>> > --- a/fs/xfs/scrub/inode_repair.c
>> > +++ b/fs/xfs/scrub/inode_repair.c
>> > @@ -1198,7 +1198,7 @@ xrep_inode_blockcounts(
>> >  			return error;
>> >  		if (count >= sc->mp->m_sb.sb_dblocks)
>> >  			return -EFSCORRUPTED;
>> > -		if (nextents >= MAXAEXTNUM)
>> > +		if (nextents >= XFS_IFORK_EXTCNT_MAXS16)
>> >  			return -EFSCORRUPTED;
>> >  		ifp->if_nextents = nextents;
>> >  	} else {
>> > -- 
>> > 2.30.2
>> > 


-- 
chandan
