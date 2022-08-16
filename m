Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58639C25B0E
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 23:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbiHPXIq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 19:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237417AbiHPXIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 19:08:44 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 510DC80366
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 16:08:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-52-176.pa.nsw.optusnet.com.au [49.181.52.176])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8D39E10E87FB;
        Wed, 17 Aug 2022 09:08:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oO5ft-00DyUb-64; Wed, 17 Aug 2022 09:08:41 +1000
Date:   Wed, 17 Aug 2022 09:08:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/1] xfs: add larp diagram
Message-ID: <20220816230841.GW3600936@dread.disaster.area>
References: <20220816225047.97828-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816225047.97828-1-catherine.hoang@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62fc237a
        a=O3n/kZ8kT9QBBO3sWHYIyw==:117 a=O3n/kZ8kT9QBBO3sWHYIyw==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=MxFkaXIYAAAA:8 a=7-415B0cAAAA:8
        a=20KFwNOVAAAA:8 a=zfJldv4guMf6i8A7R4YA:9 a=CjuIK1q_8ugA:10
        a=-FEs8UIgK8oA:10 a=bWa-HqqoEbs8MZQ2NTq-:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 16, 2022 at 03:50:46PM -0700, Catherine Hoang wrote:
> Hi all,
> 
> I've been working on adding a diagram to document the various logged
> attribute states and their transitions. This is largely based on Dave's
> diagram, with a couple of changes and added details.
> 
> The diagram can also be viewed here:
> https://pasteboard.co/xyGPkCADuH4c.png

What did you generate this image with?

i.e. how do we modify it when the state machine changes? We're
already talking about adding multiple attribute modifications being
run through the state machine, so this image will be rapidly out of
date. Hence we need a mechanism to modify the diagram and rebuild
it rather than just committing a binary image file.

The diagram I posted on #xfs was built from a 100-line text source
file with plantuml (open source tool, shipping in at least debian
based distros) and it's pretty trivial to modify and maintain.

I'd much prefer that we have a slighly less pretty diagram that we
can easily modify and rebuild than a binary image that can't easily
be modified or have the history of changes tracked easily.

The patch I originally wrote for the diagram is attached below for
reference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: add LARP state transition diagram source

From: Dave Chinner <dchinner@redhat.com>

Diagram built with the plantuml gui. Could be built from a CLI
invocation, but this was just a quick hack...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 Documentation/filesystems/xfs-larp-state.txt | 108 +++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/Documentation/filesystems/xfs-larp-state.txt b/Documentation/filesystems/xfs-larp-state.txt
new file mode 100644
index 000000000000..a02cf018c634
--- /dev/null
+++ b/Documentation/filesystems/xfs-larp-state.txt
@@ -0,0 +1,108 @@
+@startuml
+
+state REMOTE_ADD {
+	state XFS_DAS_..._SET_RMT {
+	}
+	state XFS_DAS_..._ALLOC_RMT {
+	}
+	XFS_DAS_..._SET_RMT --> XFS_DAS_..._ALLOC_RMT
+}
+
+state ADD {
+	state add_entry <<entryPoint>>
+	state add_form <<choice>>
+	add_entry --> add_form
+	add_form --> XFS_DAS_SF_ADD : short form
+	add_form --> XFS_DAS_LEAF_ADD : leaf form
+	add_form --> XFS_DAS_NODE_ADD : node form
+	state XFS_DAS_SF_ADD {
+	}
+	state XFS_DAS_LEAF_ADD {
+	}
+	state XFS_DAS_NODE_ADD {
+	}
+
+	XFS_DAS_SF_ADD --> XFS_DAS_LEAF_ADD : Full or too large
+	XFS_DAS_LEAF_ADD --> XFS_DAS_NODE_ADD : full or too large
+
+	XFS_DAS_LEAF_ADD --> XFS_DAS_..._SET_RMT : remote xattr
+	XFS_DAS_NODE_ADD --> XFS_DAS_..._SET_RMT : remote xattr
+
+}
+
+state REMOVE {
+	state remove_entry <<entryPoint>>
+	state remove_form <<choice>>
+	remove_entry --> remove_form
+	remove_form --> XFS_DAS_SF_REMOVE : short form
+	remove_form --> XFS_DAS_LEAF_REMOVE : leaf form
+	remove_form --> XFS_DAS_NODE_REMOVE : node form
+	state XFS_DAS_SF_REMOVE {
+	}
+	state XFS_DAS_LEAF_REMOVE {
+	}
+	state XFS_DAS_NODE_REMOVE {
+	}
+
+}
+
+state REPLACE {
+	state replace_choice <<choice>>
+	replace_choice --> add_entry : larp disable
+	replace_choice --> remove_entry : larp enabled
+}
+
+
+state OLD_REPLACE {
+	state XFS_DAS_..._REPLACE {
+		state XFS_DAS_..._REPLACE : atomic INCOMPLETE flag flip
+	}
+	state XFS_DAS_..._REMOVE_OLD {
+		state XFS_DAS_..._REMOVE_OLD : restore original xattr state for remove
+		state XFS_DAS_..._REMOVE_OLD : invalidate old xattr
+	}
+	XFS_DAS_..._REPLACE --> XFS_DAS_..._REMOVE_OLD
+
+}
+
+state add_done <<choice>>
+add_done -down-> XFS_DAS_DONE : Operation Complete
+add_done -up-> XFS_DAS_..._REPLACE : LARP disabled REPLACE
+XFS_DAS_SF_ADD -down-> add_done : Success
+XFS_DAS_LEAF_ADD -down-> add_done : Success
+XFS_DAS_NODE_ADD -down-> add_done : Success
+XFS_DAS_..._ALLOC_RMT -down-> add_done : Success
+
+state remove_done <<choice>>
+remove_done -down-> XFS_DAS_DONE : Operation Complete
+remove_done -up-> add_entry : LARP enabled REPLACE
+XFS_DAS_SF_REMOVE -down-> remove_done : Success
+XFS_DAS_LEAF_REMOVE -down-> remove_done : Success
+XFS_DAS_NODE_REMOVE -down-> remove_done : Success
+XFS_DAS_..._REMOVE_ATTR -down-> remove_done : Success
+
+state REMOVE_XATTR {
+	state remove_xattr_choice <<choice>>
+	remove_xattr_choice --> XFS_DAS_..._REMOVE_RMT : Remote xattr
+	remove_xattr_choice --> XFS_DAS_..._REMOVE_ATTR : Local xattr
+	state XFS_DAS_..._REMOVE_RMT {
+	}
+	state XFS_DAS_..._REMOVE_ATTR {
+	}
+	XFS_DAS_..._REMOVE_RMT --> XFS_DAS_..._REMOVE_ATTR
+}
+XFS_DAS_..._REMOVE_OLD --> remove_xattr_choice
+XFS_DAS_NODE_REMOVE --> remove_xattr_choice
+
+
+state XFS_DAS_DONE {
+}
+
+state set_choice <<choice>>
+
+[*] --> set_choice
+set_choice --> add_entry : add new
+set_choice --> remove_entry : remove existing
+set_choice --> replace_choice : replace existing
+XFS_DAS_DONE --> [*]
+@enduml
