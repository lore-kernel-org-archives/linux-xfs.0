Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F750C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 00:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiLUAxe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 19:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiLUAxc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 19:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C901DA45
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 16:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DCD8B81ADA
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 00:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB68C433F0;
        Wed, 21 Dec 2022 00:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671584009;
        bh=h/GIqEIbdwlyMjaBZWVYXkzvhceBkJOhQRICc8EvTu0=;
        h=Subject:From:To:Cc:Date:From;
        b=FQknJ738J/bzh8sdfyBwRQWk2SkgVP5IH2Oo30xh8nN+s+qh65ZtoxXTlX+4r6B7G
         3DIOeU7mEaHm0Q5VmfgtxXmcipiIF7UADC6IUAyb6JkY2T8zmIe3/3/y5R2aXw8CL2
         yWpq6ZasQZLbKmBlRq4ZpX9JqpUp+HanqG6lJ+vTpOwsumZ6OdjUw/Af6tTmnOXRKY
         yaFncKA7UIYaFNlxUqBS8eEXOtoXjAb+9iwQOU5JyyNnWRMhL6h7NMSV9lQzHh7V2T
         ezUvaLcTaO2ELiYxeCBmM8xd8EQu6DxQj7f2KZYqBj5a4seY2DnBd/06I4JmUEKYEe
         jfycRYtdJv7KQ==
Subject: [PATCHSET 0/1] xfsprogs: random fixes for 6.1, part 3
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Dec 2022 16:53:28 -0800
Message-ID: <167158400859.315997.2365290256986240896.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the third rollup of all the random fixes I've collected for
xfsprogs 6.1.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.1
---
 db/check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

