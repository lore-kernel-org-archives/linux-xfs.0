Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2EDEB64D9
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jun 2023 03:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjF1DXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jun 2023 23:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjF1DXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 23:23:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30952D58
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 20:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EEE361222
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2023 03:23:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A49BC433C8;
        Wed, 28 Jun 2023 03:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687922629;
        bh=tk/2iYCOAk/vYkHE5RjB5iFZYC2YPyd2bnJYQuEXcKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N4JQmABpotvCYKJoDw0wYIPKQVaF8rseXgQ/PVzrodF9ebMB+4+oLABrR/mnZmWCV
         XQ2onEw21iTDjiGNeT6rQRhAq5Wx8nLuqt45wS0/5PfuhVSCfoNax8rZ4Qn/GxqX2l
         YJ8e2YfaKonIVdFXIeOmZg7Ybj702Vq+uvSLkSgofHCxRzL2hj7yF2VL8w3Y5opcRt
         SnvBEkpxG8WAiS1fOodXha82niKAhU7oX5efK6u035zZTU3YMK2nNdoaEx9nmzYELH
         i1KqqLjV+uw75TNRp1C+SiUr1+AGt/egtzZBrcH1t63jTvYUJLl+K0e5fvq5j7zYg0
         W+GiVIKRZs9Aw==
Date:   Tue, 27 Jun 2023 20:23:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to b894e1b9a
Message-ID: <20230628032348.GH11467@frogsfrogsfrogs>
References: <20230626120736.4bccaypfhqbgsoqc@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626120736.4bccaypfhqbgsoqc@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 26, 2023 at 02:07:36PM +0200, Carlos Maiolino wrote:
> Hello.
> 
> The xfsprogs for-next branch, located at:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next
> 
> Has just been updated.
> 
> Patches often get missed, so if your outstanding patches are properly reviewed on
> the list and not included in this update, please let me know.

Are
https://lore.kernel.org/linux-xfs/168597945354.1226461.5438962607608083851.stgit@frogsfrogsfrogs/
and
https://lore.kernel.org/linux-xfs/168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs/

(already fully reviewed)

and maybe
https://lore.kernel.org/linux-xfs/168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs/

on the list for the next push?

--D

> The new head of the for-next branch is commit:
> 
> b894e1b9a567338f62eefb6d6ea0290d0b37060d
> 
> 4 new commits:
> 
> David Seifert (1):
>       [987373623] po: Fix invalid .de translation format string
> 
> Donald Douwsma (1):
>       [248754271] xfstests: add test for xfs_repair progress reporting
> 
> Pavel Reichl (1):
>       [b894e1b9a] mkfs: fix man's default value for sparse option
> 
> Weifeng Su (1):
>       [8813e12cc] libxcmd: add return value check for dynamic memory function
> 
> Code Diffstat:
> 
>  libxcmd/command.c      |  4 +++
>  man/man8/mkfs.xfs.8.in |  2 +-
>  po/de.po               |  2 +-
>  tests/xfs/999          | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out      | 15 ++++++++++++
>  5 files changed, 87 insertions(+), 2 deletions(-)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> -- 
> Carlos
