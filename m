Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530FCC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 18:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1276264DA1
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 18:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhBEQlb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 11:41:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhBEQj2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Feb 2021 11:39:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BD2364DA1;
        Fri,  5 Feb 2021 18:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612549098;
        bh=av8TtBM78wBa3cvQLQkwsf4OdWMwtWSV4kOV20Z73tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uVjDiTTk88bE8ctQmOoWZX5cnU3PwayEWeXXReUaYmN6PT7aZ5y/jDtjV9+RtotAp
         J2wg3eguNNXj39KWuHsG1arK9lciKN3PdU1OC8ASpacwMMkB73rBbzG8dHWcsy4+eu
         Ml2bBd2B+SfLbabnUmnzsRqKnlNOOMvh/az4UpTgzyzUFSRnSmlFojjPVZ+ZKar5Dg
         UObuIfZQK7l01M4nDFmG7HqMEr3vOImBEFIW910FEB/h7fmd7x9NNE8pdnuc6Z2WmU
         KJ6otakgkj2vwaDd71oQiG6ZRInMnANaESx5TKiUNpAdNYWjkfEWBXEnyQgAoZN+Un
         mycJOBRTXxR9Q==
Date:   Fri, 5 Feb 2021 10:18:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] debian: Drop unused dh-python from Build-Depends
Message-ID: <20210205181817.GN7193@magnolia>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
 <20210205003125.24463-2-bastiangermann@fishpost.de>
 <20210205005100.GK7193@magnolia>
 <ca46724d-dce6-ac8c-65a7-99beb6bfc27c@fishpost.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca46724d-dce6-ac8c-65a7-99beb6bfc27c@fishpost.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 05, 2021 at 07:05:12PM +0100, Bastian Germann wrote:
> Am 05.02.21 um 01:51 schrieb Darrick J. Wong:
> > On Fri, Feb 05, 2021 at 01:31:23AM +0100, Bastian Germann wrote:
> > > xfsprogs participates in dependency loops relevant to architecture
> > > bootstrap. Identifying easily droppable dependencies, it was found
> > > that xfsprogs does not use dh-python in any way.
> > 
> > scrub/xfs_scrub_all.in and tools/xfsbuflock.py are the only python
> > scripts in xfsprogs.  We ship the first one as-is in the xfsprogs
> > package and we don't ship the second one at all (it's a debugger tool).
> > 
> > AFAICT neither of them really use dh-python, right?
> 
> That is right. dh-python is generally used at build time to generate
> packages with Python modules, i.e., with files in
> /usr/lib/python3/dist-packages. That is not the case in xfsprogs.
> 
> For xfsprogs, python3 is only a runtime dependency and that is defined in
> the control file as well.

<nod> /me finally figures out exactly what dh_python does--I thought it
was required for any package shipping any python anything, but I guess
it's only for building and prepping library code and hence not needed
for our single python script in /usr/sbin, so:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> 
> > --D
> > 
> > > 
> > > Reported-by: Helmut Grohne <helmut@subdivi.de>
> > > Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
