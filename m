Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE711C67871
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Jan 2023 03:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjAJDLA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Jan 2023 22:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjAJDK6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2023 22:10:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB8CAE6F;
        Mon,  9 Jan 2023 19:10:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4A4614BA;
        Tue, 10 Jan 2023 03:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C58C433EF;
        Tue, 10 Jan 2023 03:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673320256;
        bh=5NobUZe3e86WKsQ4ysdFkOmOmqcIBSN1keo/Nf7bv98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ACfctoYBs5wi1feupJMe9VvOxeQIJMM5nrQwNmiCsToT47F8O1JSPDC53r7j98Hie
         ygskpNxEW8BTQT+iX61Eqd+KkTTpJ5sYjWcAimwT/+8yyQKIYG7srPe2mg1QuCJDXn
         qvssUtahGRb7IhvQCwFNdGgUs3nxR0Am1B7byOwQNUjMrPi1SO0eeW+rzMyRTEfnYp
         /ahZRGjcKFJJ09ckTVh4PPkcRe5gyBh3W1ZfAR2G8+FkYLgHtrDIE/Q5bOXRwt9dde
         DsKg9ToAo9oaTON9UdkOjX0B4UAgtK8OJ/xei+3gzSEIGadBLHsihDA+iYgEuhvId2
         Qox8Csj6RpLlA==
Date:   Mon, 9 Jan 2023 19:10:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] fsverity: support for non-4K pages
Message-ID: <Y7zXPoEQkmQs/Whw@sol.localdomain>
References: <20221223203638.41293-1-ebiggers@kernel.org>
 <Y7xRIZfla92yzK9N@sol.localdomain>
 <20230109193446.mpmbodoctaddovpv@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109193446.mpmbodoctaddovpv@aalbersh.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 09, 2023 at 08:34:46PM +0100, Andrey Albershteyn wrote:
> On Mon, Jan 09, 2023 at 09:38:41AM -0800, Eric Biggers wrote:
> > On Fri, Dec 23, 2022 at 12:36:27PM -0800, Eric Biggers wrote:
> > > [This patchset applies to mainline + some fsverity cleanups I sent out
> > >  recently.  You can get everything from tag "fsverity-non4k-v2" of
> > >  https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git ]
> > 
> > I've applied this patchset for 6.3, but I'd still greatly appreciate reviews and
> > acks, especially on the last 4 patches, which touch files outside fs/verity/.
> > 
> > (I applied it to
> > https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=fsverity for now,
> > but there might be a new git repo soon, as is being discussed elsewhere.)
> > 
> > - Eric
> > 
> 
> The fs/verity patches look good to me, I've checked them but forgot
> to send RVB :( Haven't tested them yet though
> 
> Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
> 

Thanks Andrey!  I added your Reviewed-by to patches 1-7 only, since you said
"the fs/verity patches".  Let me know if I can add it to patches 8-11 too.

- Eric
