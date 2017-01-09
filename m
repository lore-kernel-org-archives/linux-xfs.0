Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36071 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935556AbdAIMk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 07:40:58 -0500
Received: by mail-oi0-f68.google.com with SMTP id u143so15989263oif.3
        for <linux-xfs@vger.kernel.org>; Mon, 09 Jan 2017 04:40:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Jan 2017 14:40:56 +0200
Message-ID: <CAOQ4uxhhOqhsZwrncsfUmra9nLGKpF2mFGp35BuiPyucWkN1yw@mail.gmail.com>
Subject: Re: [PATCH v4 00/47] xfs: online scrub/repair support
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jan 7, 2017 at 2:35 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> Hi all,
>
...
> If you're going to start using this mess, you probably ought to just
> pull from my github trees.  The kernel patches[1] should apply against
> 4.10-rc2.  xfsprogs[2] and xfstests[3] can be found in their usual
> places.
>
> The patches have survived all auto group xfstests both with scrub-only
> mode and also a special debugging mode to xfs_scrub that forces it to
> rebuild the metadata structures even if they're not damaged.  Since the
> last patch release, I have now had time to run the new tests in [3] that
> try to fuzz every field in every data structure on disk.
>

Darrick,

I started running the dangerous_scrub group yersterday and it's killing my
test machine. The test machine is x86_64 (i5-3470) 16GB RAM
and test partitions are 100GB volume on spinning disk.

xfs_db swaps my system to death and most of the tests it eventually
gets shot down by oom killer.

Is that surprising to you? How much RAM does you test systems have?
Can you figure out a minimal RAM requirement to run these fuzzers
and maybe check required RAM before running the test?

Alternatively, can you figure out how to reduce the amount of RAM
used by the fuzzer?

I was using mkfs options "-m rmapbt=1,reflink=1"
and I tried running with and then without TEST_XFS_SCRUB=1.
I don't see a reason to send the logs at this point, they are just a complete
mass of destruction.

Let me know if you need more inputs from me.

Amir.
