Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3576EC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCF62064B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v1Bp//ng"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGOSix (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOSiw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:38:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDE0C061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Isv05wpnRE7Hdh0he/M2ZW8+o5e5p+LUTEZa+k2uPJU=; b=v1Bp//ngbWATfgCOuAPGhd6Amp
        uNFV7gnQ0X0kKMC4s6aLno51dnf/VOvVH4ts4uudE01WJg9GArRN15DD0crWsl52p8WK+2dTdGENl
        wT/n7/oqPYvTBPuXkRzFw1wugrXguV5epMe13b3CBIPq1buoeaXADWSCSW2hummc8xeLVkH4Fp4TH
        yvR+W1d1mhCCQz45SeybCfFmDygPpN7iPDTZVJnbZWomREdvWb3qRvuSKEi1KIrn0p+L/9YZ1ezw0
        90IaUbk1+3H/AmzRCU/4Pm9r5r9rCPI2Du7IfaDzBSf84/cekG9tI1HTIgqyatyAwgH+IAQsf2yEC
        n4T4gKuQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvmIr-00061x-Cw; Wed, 15 Jul 2020 18:38:49 +0000
Date:   Wed, 15 Jul 2020 19:38:49 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_db: stop misusing an onstack inode
Message-ID: <20200715183849.GA22039@infradead.org>
References: <159476319690.3156851.8364082533532014066.stgit@magnolia>
 <159476320311.3156851.15212854498898688157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159476320311.3156851.15212854498898688157.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 02:46:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The onstack inode in xfs_check's process_inode is a potential landmine
> since it's not a /real/ incore inode.  The upcoming 5.8 merge will make
> this messier wrt inode forks, so just remove the onstack inode and
> reference the ondisk fields directly.  This also reduces the amount of
> thinking that I have to do w.r.t. future libxfs porting efforts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Comparing this to my version here:

http://git.infradead.org/users/hch/xfsprogs.git/commitdiff/791d7d324290dbb83be7bf35fe15f9898f5df1c1

>  	mode_t			mode;
> +	uint16_t		diflags;
> +	uint64_t		diflags2 = 0;
> +	xfs_nlink_t		nlink;
> +	xfs_dqid_t		uid;
> +	xfs_dqid_t		gid;
> +	xfs_dqid_t		prid;

Not sure we really need the local variables, as they are mostly just
used once except for error messages..

> +	if (dip->di_version == 1) {
> +		nlink = be16_to_cpu(dip->di_onlink);
> +		prid = 0;
> +	} else {
> +		nlink = be32_to_cpu(dip->di_nlink);
> +		prid = (xfs_dqid_t)be16_to_cpu(dip->di_projid_hi) << 16 |
> +				   be16_to_cpu(dip->di_projid_lo);
> +	}

I mad the assumption that we don't support v1 inodes anymore, but
it appears we actually do.  So we might need to keep these two.

>  	if (isfree) {
> -		if (xino.i_d.di_nblocks != 0) {
> +		if (be64_to_cpu(dip->di_nblocks) != 0) {

No need to byte swap for a comparism with 0.

> -	if ((unsigned int)xino.i_d.di_aformat > XFS_DINODE_FMT_BTREE)  {
> +	if ((unsigned int)dip->di_aformat > XFS_DINODE_FMT_BTREE)  {

No need for the (pre-existing) cast here.

> +			fmtnames[(int)dip->di_aformat],

Same here.
