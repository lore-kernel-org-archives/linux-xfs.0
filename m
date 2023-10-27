Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1189EC25B48
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Oct 2023 16:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbjJ0QgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Oct 2023 12:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbjJ0QgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 12:36:09 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91E11B
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 09:36:06 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwPob-003RuD-9c; Fri, 27 Oct 2023 16:36:05 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <871qdgccs5.fsf@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <20231027154505.GL3195650@frogsfrogsfrogs> <ZTvjFZPn7KH6euyT@technoir> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698424438821519
          (code B ref 1054644); Fri, 27 Oct 2023 16:36:04 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 16:33:58 +0000
Received: from ams.source.kernel.org ([145.40.68.75]:39312)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <djwong@kernel.org>)
        id 1qwPmX-003Rdp-4C
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 16:33:58 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
        by ams.source.kernel.org (Postfix) with ESMTP id 78D45B80757;
        Fri, 27 Oct 2023 16:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68D7C433C7;
        Fri, 27 Oct 2023 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698423942;
        bh=yeTCktgiC1c3C9CFKDBVrf9xgiAItVOWTL2Pnh7GJbE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=avPuNmDscP591IOK11StL6L/OHFBLZIAD1O32a51fGGVnIyL291fgeCM54HGdQudQ
         kCnylXT2WwMlsOznrhuy/lvL0+FU4l4QwjxIi+wrzjKfuJL5MxgqPoMt9xKFe/ogHQ
         xqU/nY3pJ8QR7EkFAeN8nrYyhiUHBssOSeTCbPX/RpQSLzHG/WLeOuPLVgjao/6u/V
         hgf6lMoIODpit2NO9YaG3JRveT3J7HCBWvHHFx+n17OQeJKQwkbRtmYst87FJQMziL
         rC+iSHR+Dil9DqmeARkfP1Z/AVh7eiTHi7Zzh03dIm/wYo3lh1fG/0wP/Z5eGnnhcN
         4/iMo7yOuv4Bg==
Date:   Fri, 27 Oct 2023 09:25:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     1054644@bugs.debian.org, Philip Hands <phil@hands.com>
Message-ID: <20231027162542.GI11424@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTvjFZPn7KH6euyT@technoir>
X-Greylist: delayed 487 seconds by postgrey-1.36 at buxtehude; Fri, 27 Oct 2023 16:33:56 UTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2023 at 06:19:33PM +0200, Anthony Iliopoulos wrote:
> On Fri, Oct 27, 2023 at 08:45:05AM -0700, Darrick J. Wong wrote:
> > 
> > mkfs.xfs in xfsprogs 6.5 turned on both the large extent counts and
> > reverse mapping btree features by default.  My guess is that grub hasn't
> > caught up with those changes to the ondisk format yet.
> > 
> > Ah, yeah, upstream grub hasn't picked up large extent counts (internally
> > called nrext64) yet.
> > https://git.savannah.gnu.org/cgit/grub.git/tree/grub-core/fs/xfs.c#n83
> 
> Yeap it is due to nrext64, I've submitted a patch to grub (should have
> cc'ed linux-xfs..)
> 
> https://lore.kernel.org/grub-devel/20231026095339.31802-1-ailiop@suse.com/

FWIW the patch turning on nrext64 by default was intended for xfsprogs
6.6, but the maintainer decided to merge it early.  No complaints here,
but that was a little sooner than I had intended.

--D

> Regards,
> Anthony
