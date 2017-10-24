Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:56827 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdJXKGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2017 06:06:41 -0400
Date: Tue, 24 Oct 2017 12:06:37 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 3/8] lockdep: Remove BROKEN flag of
 LOCKDEP_CROSSRELEASE
Message-ID: <20171024100637.nryez5rgmykod54v@gmail.com>
References: <1508837889-16932-1-git-send-email-byungchul.park@lge.com>
 <1508837889-16932-4-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508837889-16932-4-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: peterz@infradead.org, axboe@kernel.dk, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com


better changelog:

================>
Subject: locking/lockdep: Remove the BROKEN flag from CONFIG_LOCKDEP_CROSSRELEASE and CONFIG_LOCKDEP_COMPLETIONS
From: Byungchul Park <byungchul.park@lge.com>
Date: Tue, 24 Oct 2017 18:38:04 +0900

Now that the performance regression is fixed, re-enable
CONFIG_LOCKDEP_CROSSRELEASE=y and CONFIG_LOCKDEP_COMPLETIONS=y.


