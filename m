Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BAD0C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 05:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjCPFQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 01:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPFQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 01:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FC6A3B62
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 22:16:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F31A161CDB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 05:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561F5C433D2;
        Thu, 16 Mar 2023 05:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678943814;
        bh=YLv8y8tk6AKJZdtgi74rrl27BSyQc6Y3SKdhHfNx2to=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ToD1SMPqfxw8qR+MBVFhpMLQ0Oh26WrJrhMoM63XBOsvDEswqzPB+EkItV1H2faBu
         FKA/bzRDlKEQkVO1q6Chz0gWWJbgnryA+5ejOmwrWzY3qafJWjSG1ESY2A1VzAlPac
         EIRhmvZFinNQBs9GFEPPY9INUbV/fBCdSsDolkbH1x4PWNIHOd9weh+D92llJwn8qK
         e0QPhmZz/fIW6S9C/maeFeF+VguUiNbKIr4+gKkLUfNRwoGBIG4v72seBrWsDOpXH3
         KrVZ+kCDfDcerAZhdjyej16vw4oTUvnBTLqzpqWFth2VPFmrdMP1DkNAoPJj82yL0Q
         RRAsFlxfpbYNQ==
Date:   Wed, 15 Mar 2023 22:16:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 2/4] xfs: implement custom freeze/thaw functions
Message-ID: <20230316051653.GG11394@frogsfrogsfrogs>
References: <20230314042109.82161-1-catherine.hoang@oracle.com>
 <20230314042109.82161-3-catherine.hoang@oracle.com>
 <CAOQ4uxhKEhQ4X+rE4AYq70iEWKfqwQOZu47w_n1dbXd-wOeHTw@mail.gmail.com>
 <20230314052502.GB11376@frogsfrogsfrogs>
 <CAOQ4uxgeHcSOnZxKV4rGXa_gj4-hwicu7=VVvofrQGwcDSdt0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgeHcSOnZxKV4rGXa_gj4-hwicu7=VVvofrQGwcDSdt0w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 14, 2023 at 08:00:21AM +0200, Amir Goldstein wrote:
> On Tue, Mar 14, 2023 at 7:25 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Mar 14, 2023 at 07:11:56AM +0200, Amir Goldstein wrote:
> > > On Tue, Mar 14, 2023 at 6:25 AM Catherine Hoang
> > > <catherine.hoang@oracle.com> wrote:
> > > >
> > > > Implement internal freeze/thaw functions and prevent other threads from changing
> > > > the freeze level by adding a new SB_FREEZE_ECLUSIVE level. This is required to
> > >
> > > This looks troubling in several ways:
> > > - Layering violation
> > > - Duplication of subtle vfs code
> > >
> > > > prevent concurrent transactions while we are updating the uuid.
> > > >
> > >
> > > Wouldn't it be easier to hold s_umount while updating the uuid?
> >
> > Why?  Userspace holds an open file descriptor, the fs won't get
> > unmounted.
> 
> "Implement internal freeze/thaw functions and prevent other threads
> from changing
> the freeze level..."
> 
> holding s_umount prevents changing freeze levels.
> 
> The special thing about the frozen state is that userspace is allowed
> to leave the fs frozen without holding any open fd, but because there
> is no such requirement from SET_FSUUID I don't understand the need
> for a new freeze level.

Hm.  I think you could be right, since we can certainly run transactions
with s_umount held.  I wonder if we're going to run into problems with
the weird xlog things that fsuuid setting will want, but I guess we have
lockdep on our side, right? ;)

--D

> Thanks,
> Amir.
