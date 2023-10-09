Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D149CD611E
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377521AbjJISSm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377414AbjJISSl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:18:41 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A721C9D;
        Mon,  9 Oct 2023 11:18:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D93C433C8;
        Mon,  9 Oct 2023 18:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875520;
        bh=y0CE5gzTW8YBWCZOVa8nFbGS99x7KYBXAW9Lb1amYi8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tndI3fitj/Ye73d+rYXfF84upha6NG5uOE9toLwSlu8xKiVPviiBUsRTLDn+scp6Q
         ZINh/KEogHFIznx2IeS+rzHdCoBLmXR9+tuNNrC1yN8OiuRG4riye+wtAY+uzZkKdn
         QEriWi/fBNjygKb6tYnv25UECLHHA44WCgpvbA4vVysIryIQ6rg1OrAF6viYjOgpTl
         1qVv36+soM4Hyd7XAs6gUH54rCyH4erWbvQJqKsRobYbVbNaxAszasEt3KPZTvj0eq
         ZIkqjwZPr9c81qUuHjKtaJTwaRCYnF9Y3GHyOTCPLApPnvlgd84AfQ0T+Y0+b80JA6
         bcwi+QiRCmt7A==
Subject: [PATCH 2/3] generic/465: only complain about stale disk contents when
 racing directio
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     tytso@mit.edu, jack@suse.cz, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 09 Oct 2023 11:18:39 -0700
Message-ID: <169687551965.3948976.15125603449708923383.stgit@frogsfrogsfrogs>
In-Reply-To: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test does a strange thing with directio -- it races a reader thread
with an appending aio writer thread and checks that the reader thread
only ever sees a (probably short) buffer containing the same contents
that are being read.

However, this has never worked correctly on XFS, which supports
concurrent readers and writers for directio.  Say you already have a
file with a single written mapping A:

AAAAAAAAAA
0        EOF

Then one thread initiates an aligned appending write:

AAAAAAAAAA---------
0        EOF      new_EOF

However, the free space is fragmented, so the file range maps to
multiple extents b and c (lowercase means unwritten here):

AAAAAAAAAAbbbbccccc
0        EOF      new_EOF

This implies separate bios for b and c.  Both bios are issued, but c
completes first.  The ioend for c will extend i_size all the way to
new_EOF.  Extent b is still marked unwritten because it hasn't completed
yet.

Next, the test reader slips in and tries to read the range between the
old EOF and the new EOF.  The file looks like this now:

AAAAAAAAAAbbbbCCCCC
0        EOF      new_EOF

So the reader sees "bbbbCCCCC" in the mapping, and the buffer returned
contains a range of zeroes followed by whatever was written to C.

For pagecache IO I would say that i_size should not be extended until
the extending write is fully complete, but the pagecache also
coordinates access so that reads and writes cannot conflict.

However, this is directio.  Reads and writes to the storage device can
be issued and acknowledged in any order.  I asked Ted and Jan about this
point, and they echoed that for directio it's expected that application
software must coordinate access themselves.

In other words, the only thing that the reader can check here is that
the filesystem is not returning stale disk contents.  Amend the test so
that null bytes in the reader buffer are acceptable.

Cc: tytso@mit.edu, jack@suse.cz
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../aio-dio-append-write-read-race.c               |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/src/aio-dio-regress/aio-dio-append-write-read-race.c b/src/aio-dio-regress/aio-dio-append-write-read-race.c
index 911f27230b..d9f8982f00 100644
--- a/src/aio-dio-regress/aio-dio-append-write-read-race.c
+++ b/src/aio-dio-regress/aio-dio-append-write-read-race.c
@@ -191,7 +191,7 @@ int main(int argc, char *argv[])
 		}
 
 		for (j = 0; j < rdata.read_sz; j++) {
-			if (rdata.buf[j] != 'a') {
+			if (rdata.buf[j] != 'a' && rdata.buf[j] != 0) {
 				fail("encounter an error: "
 					"block %d offset %d, content %x\n",
 					i, j, rbuf[j]);

