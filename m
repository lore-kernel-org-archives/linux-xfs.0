Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAA5C48BE5
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 23:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68813613EE
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 23:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFKXbo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 19:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhFKXbo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 19:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D7DC61374;
        Fri, 11 Jun 2021 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623454185;
        bh=c9BP7/n+LWeMe+irdXPo70qoLQDrEWuY47FnQTjbh6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nYl+oawZhPnE/6lNPf+lB6S4KQ6Kz1klK2NVCpRHxhdkBaMHMJXN/F3MdPG/Uok4n
         9ej9LuSQSCNqintwrNvO5SHtbGi38wbIJj6bhG6WvE5tPcy/Ql5+NsHNlrcqGFEfDe
         kL6W7WGBZUYIhlPfW1vQYKJMCUgwUh+UjwhjyPIWnPq47z0R42KxrlayZxowYTEmkG
         vAzC/SRwSCAt5nRx4Qxs0bo2HInmWMMubKmgSytpWJOrVKp5tfN+/tcxaGezrutedS
         g2a/I7wCw9YpuPdRAslGoyOUt/MQ9PXwyAS6gcXVyiR++MhV9ZeXozFiiJfX0RC24D
         Twym72eUWbubw==
Date:   Fri, 11 Jun 2021 16:29:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 11/13] fstests: remove group files
Message-ID: <20210611232945.GE2945738@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317282225.653489.1537192803992898300.stgit@locust>
 <YMPwyeb8wgqzEbeH@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMPwyeb8wgqzEbeH@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 11, 2021 at 04:24:57PM -0700, Eric Biggers wrote:
> On Tue, Jun 08, 2021 at 10:20:22AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we autogenerate group files, get rid of them in the source
> > tree.
> > 
> 
> This breaks 'make install', since tests/*/Makefile still try to install "group"
> instead of "group.list".  Changing them to use "group.list" instead fixed it.

Are you sending a patch, or are you making me fix it?

--D

> 
> - Eric
