Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D7CC38142
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Jan 2023 12:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjAXM4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 07:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbjAXM4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 07:56:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2347630D6;
        Tue, 24 Jan 2023 04:56:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 202CBB811C2;
        Tue, 24 Jan 2023 12:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610B1C433D2;
        Tue, 24 Jan 2023 12:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674564971;
        bh=aXc+7DU6wiR86FkbJyGCIgne5RjiAMbSraY5xIyxN/E=;
        h=Subject:From:To:Cc:Date:From;
        b=khv49ls4LJDMmPLiDX2Fa8CIs+yEjZ2WYe6zmCw70KtBL1uCrDqguVsDbeJVkR29U
         1wGG3tZibVkNwC69DAPT/k9DdlWqxosjkkYyCQQdorVjjJXODjVFwRj3GiM+zsMKhj
         6tngYqy7z6F3YIjKBVqCHFe8F4WeIsJh11jTk20GWP8pz7VAywlhjs++vZi2Ro1QIW
         Cw89WYGkqef76miU3mqDCl8UxlQBLy0STRLdF0cbXnxwRgITrVxOx6ZnkH11VzR2Tn
         +tXnkTNrnQ/4PGHGdgKUPyxm9SsIWvQx5UyAmwyxr5I7Pcl6O2BsM4QwU1Un0RYMfv
         IwxtAOseKRihQ==
Message-ID: <57c413ed362c0beab06b5d83b7fc4b930c7662c4.camel@kernel.org>
Subject: replacement i_version counter for xfs
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date:   Tue, 24 Jan 2023 07:56:09 -0500
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A few months ago, I posted a patch to make xfs not bump its i_version
counter on atime updates. Dave Chinner NAK'ed that patch, mentioning
that xfs would need to replace it with an entirely new field as the
existing counter is used for other purposes and its semantics are set in
stone.

Has anything been done toward that end? Should I file a bug report or
something? It would be nice to get this going so that XFS can continue
to be a viable filesystem for exporting via NFS.

Thanks,
--=20
Jeff Layton <jlayton@kernel.org>
