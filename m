Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0FFC001B2
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 03:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbiLTDRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 22:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiLTDRD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 22:17:03 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8D813F46
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 19:17:01 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2BK3GhnG026138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 22:16:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1671506205; bh=AUO3hX41d59kcr1GVWXAeTK09oFfMUrFiF1nZ3HcXAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=mSFT9Eo+nzgri83W15A78YT0fFG3vpFSdCoVdUUd4p8QLYmn+uJdIgtpiqBCfZiqS
         G0YFzXMVkwsufvuUN/65mTxAcG9LqOr4dC7cjywBh1uShxpS9+kknLni09H+F95THr
         496Qmt3jqEnjoPwPU//MjIR0cM+2YfewYbiLpPvY8ov/vkfIs9NzexQ4+u2QWMj+DD
         6M16zbf9uDoPdp42HDPekG9dhFkQCicdsGH3coWIYRhNdBjc5IBo+i9B0HunXvM8qI
         OgxIndLWTlaSOsFVqHUqi/zkjr5VuKo7cZFvASLIZhCqHAi3gpuPNxnUHM9G77Q+a/
         t2gz09wuswNqQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 9835D15C3511; Mon, 19 Dec 2022 22:16:43 -0500 (EST)
Date:   Mon, 19 Dec 2022 22:16:43 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, leah.rumancik@gmail.com,
        quwenruo.btrfs@gmx.com
Subject: Re: [PATCH 1/8] check: generate section reports between tests
Message-ID: <Y6EpG8cpQDH0XuGz@mit.edu>
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149446946.332657.17186597494532662986.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167149446946.332657.17186597494532662986.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 04:01:09PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Generate the section report between tests so that the summary report
> always reflects the outcome of the most recent test.  Two usecases are
> envisioned here -- if a cluster-based test runner anticipates that the
> testrun could crash the VM, they can set REPORT_DIR to (say) an NFS
> mount to preserve the intermediate results.  If the VM does indeed
> crash, the scheduler can examine the state of the crashed VM and move
> the tests to another VM.  The second usecase is a reporting agent that
> runs in the VM to upload live results to a test dashboard.

Leah has been working on adding crash recovery for gce-xfstests.
It'll be interesting to see how her work dovetails with your patches.

The basic design we've worked out works by having the test framework
recognize whether the VM had been had been previously been running
tests.  We keep track of the last test that was run by hooking into
$LOGGER_PROG.  We then use a python script[1] to append to the xunit file
a test result for the test that was running at the time of the crash,
and we set the test result to "error", and then we resume running
tests from where we had left off.

[1] https://github.com/lrumancik/xfstests-bld/blob/ltm-auto-resume-new/test-appliance/files/usr/local/bin/add_error_xunit

To deal with cases where the kernel has deadlocked, when the test VM
is launched by the LTM server, the LTM server will monitor the test
VM, if the LTM server notices that the test VM has failed to make
forward progress within a set time, it will force the test VM to
reboot, at which point the recovery process described above kicks in.

Eventually, we'll have the LTM server examine the serial console of
the test VM, looking for indications of kernel panics and RCU / soft
lockup warnings, so we can more quickly force a reboot when the system
under test is clearly unhappy.

The advantage of this design is that it doesen't require using NFS to
store the results, and in theory we don't even need to use a separate
monitoring VM; we could just use a software and kernel watchdogs to
notice when the tests have stopped making forward progress.

       	    	      	   	   - Ted

P.S.  We're not using section reporting since we generally use launch
separate VM's for each "section" so we can speed up the test run time
by sharding across those VM's.  And then we have the LTM server merge
the results together into a single test run report.
