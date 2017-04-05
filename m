Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754952AbdDEK7T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:59:19 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170405104205.GZ22845@eguan.usersys.redhat.com>
References: <20170405104205.GZ22845@eguan.usersys.redhat.com> <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk> <149132132595.18980.156040870381065105.stgit@warthog.procyon.org.uk>
Subject: Should xfstest generic/388 be using _require_command for fsstress?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2717.1491389955.1@warthog.procyon.org.uk>
Date: Wed, 05 Apr 2017 11:59:15 +0100
Message-ID: <2718.1491389955@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>, bfoster@redhat.com
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

| 388:45:	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
| 388:58:_require_command "$KILLALL_PROG" "killall"
| 388:79:		$KILLALL_PROG -9 fsstress > /dev/null 2>&1

Should this be using _require_command for fsstress and $FSSTRESS_PROG like the
other tests that use fsstress?

Also, should 388 be printing "Silence is golden" at the end of the test?

David
