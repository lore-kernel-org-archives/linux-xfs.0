Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33790 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbfHDRMs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 4 Aug 2019 13:12:48 -0400
Subject: Re: [PATCH 16/24] xfs: Lower CIL flush limit for large logs
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-17-david@fromorbit.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b8b711fc-ba44-b510-91e8-8b6c247c30f3@suse.com>
Date: Sun, 4 Aug 2019 20:12:45 +0300
MIME-Version: 1.0
In-Reply-To: <20190801021752.4986-17-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org



On 1.08.19 г. 5:17 ч., Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current CIL size aggregation limit is 1/8th the log size. This
> means for large logs we might be aggregating at least 250MB of dirty objects
> in memory before the CIL is flushed to the journal. With CIL shadow
> buffers sitting around, this means the CIL is often consuming >500MB
> of temporary memory that is all allocated under GFP_NOFS conditions.
> 
> FLushing the CIL can take some time to do if there is other IO
> ongoing, and can introduce substantial log force latency by itself.
> It also pins the memory until the objects are in the AIL and can be
> written back and reclaimed by shrinkers. Hence this threshold also
> tends to determine the minimum amount of memory XFS can operate in
> under heavy modification without triggering the OOM killer.
> 
> Modify the CIL space limit to prevent such huge amounts of pinned
> metadata from aggregating. We can 2MB of log IO in flight at once,
There is a word missing between 'can' and '2MB'
> so limit aggregation to 8x this size (arbitrary). This has some
> impact on performance (5-10% decrease on 16-way fsmark) and
> increases the amount of log traffic (~50% on same workload) but it
> is necessary to prevent rampant OOM killing under iworkloads that
> modify large amounts of metadata under heavy memory pressure.
> 
> This was found via trace analysis or AIL behaviour. e.g. insertion
s/or/of/

> from a single CIL flush:

<snip>
