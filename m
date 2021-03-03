Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0011C433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7B664E59
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbhCDARY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:24 -0500
Received: from vera.ghen.be ([178.21.118.64]:38416 "EHLO vera.ghen.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234754AbhCCNWn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 08:22:43 -0500
Received: by vera.ghen.be (Postfix, from userid 1000)
        id 4DrF3q48ldz2xBF; Wed,  3 Mar 2021 14:20:23 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hendrickx.be;
        s=21e; t=1614777623;
        bh=HCQTUOaf0YHdzLeLL8W2rbeNZ/m/L1z7/P3NQIPHjgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=T/82KoZem0kBWGMZb0j5aXA5l30V40LUDXSg7l0yTxPPK+LgwXr47KETxY8ayimVm
         4d2Gi2txZw5A/yURR+WCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hendrickx.be; s=21r;
        t=1614777623; bh=HCQTUOaf0YHdzLeLL8W2rbeNZ/m/L1z7/P3NQIPHjgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=XtxNt5NcLp90cXkFAnZ2V7okLJHwLJJ9GFKYig/k5VIrUo8gljQfW8iFdGUyZsDeK
         Vj01AA0pELIQbLXL3lfLdRFU0cM+GlkYJNOZ3NfG6GoA4JFkDP0viR49e5GFChfXrq
         6YXmO+z9FaG84/pHgRLgxwJoCCOfBgx+8J5ikoSkZGr7jcDxVWHK2QRoZQ8ARb7HzU
         SiHobsCIIDMO/UpqgYuZqIgQNHI3cUtVVlKPXyjUVi85oQxeTIh4hY/H9FPZqdMkUG
         5eW561AqfpeczhqoouXm3Iikja+3LI81YJWt8JFEtgq3ADfeVGUqEBTQaE6Ys61EiZ
         6Qism4ePx6q8w==
Date:   Wed, 3 Mar 2021 14:20:23 +0100
From:   Geert Hendrickx <geert@hendrickx.be>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <YD+NF63sGji+OBtc@vera.ghen.be>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
 <20210301191803.GE7269@magnolia>
 <YD4tWbfzmuXv1mKQ@bfoster>
 <YD7C0v5rKopCJvk2@vera.ghen.be>
 <YD937HTr5Lq/YErv@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD937HTr5Lq/YErv@bfoster>
X-PGP-Key: https://geert.hendrickx.be/pgpkey.asc
X-PGP-Key-Id: C88C1D9ED3861005886BF44ACD718C1F95AD44EA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 06:50:04 -0500, Brian Foster wrote:
> Maybe a simple compromise is a verbose option for xfs_admin itself..?
> I.e., the normal use case operates as it does now, but the failure case
> would print something like:
> 
>   "Feature conversion failed. Retry with -v for detailed error output."
> 
> ... and then 'xfs_admin -v ...' would just pass through xfs_repair
> output. Eh?


Good suggestion, that should cover it.


	Geert


