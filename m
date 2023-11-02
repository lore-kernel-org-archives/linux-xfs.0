Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC178C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 00:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjKBAgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 20:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbjKBAgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 20:36:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E39115;
        Wed,  1 Nov 2023 17:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=gGm0sYWnnrJGarxSgyGZcxG+ZjgGMcHCRe0pP5641sY=; b=gl+A1oDhQSo2DWsqEXNFPd+oJF
        YoHlaJivSM8nJLEcziJKP8tUAaLW6Hk93ZQUfmsdhg9Wk6JhKCaHgYuzOp/LkABNzy8odEB6dDOLC
        sEQp4c+9Bub/zM7IkPYsAMU8EF8NiQjznuck1OuxdZW7asa3HtFgvcpF2tcTddOP2XWoPuw0611ep
        Q0xe3bd3VcrxClzt/3ydGWnSJxjk90rmNzg7/VpzJffmaBwi3mPk4IQZyVrHM0yME28JVL0BUjwgI
        JaiJgJzrQ/zZ53J8RQpJ8WWMoOWGgQg4Jt9auJsxdR6mchQX5rTp3rR00pQGCZlrEiVLGHeK2r7DQ
        9TiTtHug==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qyLgz-008PIJ-1g;
        Thu, 02 Nov 2023 00:36:13 +0000
Date:   Wed, 1 Nov 2023 17:36:13 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <p.raghav@samsung.com>,
        Daniel Gomez <da.gomez@samsung.com>
Subject: xfs/599 on LBS
Message-ID: <ZULu/Rm/EiBY8ZzG@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/599 takes a long time on LBS, but it passes. The amount of time it
takes, however, begs the question if the test is could be trimmed to
do less work because the larger the block size the larger the number of
dirents and xattrs are used to create. The large dirents are not a
problem. The amount of time it takes to create xattrs with hashcol however
grows exponentially in time.

n=16k   takes 5   seconds
n=32k   takes 30  seconds
n=64k     takes 6-7 minutes
n=1048576 takes 30 hours

n=1048576 is what we use for block size 32k.

Do we really need so many xattrs for larger block sizes for this test?

S1="KNR4qb1wJE1ncgC83X2XQg7CKwuqEYQjwuX3MG1o6FyqwrCXagIYlgGqtbLlpUn9prWpkCo9ChrxJOINgc3MBSG0La6Qhm9imcduPeGtC3IvQOzuKPsQAN3O5lVS9zha1giONke1RfnTcidsDlIxNcupydmZrdJmwHU7HRxWWqLTenWh3Gi5YNWExX0Ft94NEtfY8Lov2qvYJbTA5knONimQq5wUaK1Eo449pDXTnCOTRRhPnSHMXzNqT"

mkfs.xfs -f -b size=32k -s size=4k /dev/loop16
mount /dev/loop16 /mnt
touch /mnt/foo
time xfs_db -r -c "hashcoll -a -n 1048576 -p /mnt/foo $S1" /dev/loop16 

But also, for the life of me, I can't get the btree printed out, I see
the nvlist but not btree, you can print *everything* out with just
-c 'print':

xfs_db -c 'path /hah' -c 'ablock 0' -c 'addr btree[0].before' -c 'print' /dev/loop16

  Luis
