Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43884 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbeJCUsZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 16:48:25 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id DE5234A2
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 08:59:48 -0500 (CDT)
Subject: Re: [PATCH 1/2] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-2-cmaiolino@redhat.com>
 <46ff8aca-5053-541d-6d74-fbc7e12a9898@sandeen.net>
 <20181003133914.gikxezpadsyil7hp@odin.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a4352f35-6cd9-6b05-a914-86c33fb11b33@sandeen.net>
Date: Wed, 3 Oct 2018 08:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <20181003133914.gikxezpadsyil7hp@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 10/3/18 8:39 AM, Carlos Maiolino wrote:
> On Wed, Oct 03, 2018 at 07:47:46AM -0500, Eric Sandeen wrote:
>> On 10/3/18 7:35 AM, Carlos Maiolino wrote:
>>> The addition of FIBT, RMAP and REFCOUNT changed the offsets into
>>> __xfssats structure.
>>>
>>> Although this didn't cause any direct issue,  xqmstat_proc_show() relied
>>> on the old offsets to display the xqm statistics.
>>
>> Well, it caused /proc/fs/xfs/xqmstat to display garbage data, right?
>> That seems worth highlighting in the changelog, and not glossing over.
> 
> Well, I wouldn't say 'garbage' data. I'd say data from other fields in the
> structure (at this point, specifically fino btree data) :P, but sure, I can add
> it to the changelog.

That's kind of like saying stale data exposure or kernel memory leaks isn't
garbage data, it's just someone /else's/ data.  ;)

Anyway, however you want to phrase it, aI think the change needs to highlight
that there /is/ a failure and it's not an irrelevant fix.

>>
>> Could maybe use Fixes: tags for:
>>
>> 00f4e4f9 xfs: add rmap btree stats infrastructure
>> aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
>> 46eeb521 xfs: introduce refcount btree definitions
>>
> 
> No objection.
> 
>> and a stable tag as well?  Though stable is tricky because different patches
>> would be required for different points along the stats structure evolution...
>> maybe best to ignore it, chances of auto-applying it correctly are slim to
>> none.
> 
> Indeed, this may not apply to stable trees, unless the tree itself contains all
> three data structures (rmap finobtree and refcount).

Yeah.  It would go back to 4.10 cleanly, tho.  Just a thought.

-Eric
