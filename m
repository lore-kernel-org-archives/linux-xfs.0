Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52464 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbeJLWdW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Oct 2018 18:33:22 -0400
Subject: Re: [PATCH 2/2] xfs: use offsetof() in place of offset macros for
 __xfsstats
References: <20181010123708.7632-1-cmaiolino@redhat.com>
 <20181010123708.7632-3-cmaiolino@redhat.com> <20181011052957.GO6311@dastard>
 <d81b5be8-23ec-e3c6-9270-fa311848ab38@sandeen.net>
 <20181012070153.GW6311@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dbf1d999-d6d0-4095-f407-0858b55791b7@sandeen.net>
Date: Fri, 12 Oct 2018 10:00:30 -0500
MIME-Version: 1.0
In-Reply-To: <20181012070153.GW6311@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org



On 10/12/18 2:01 AM, Dave Chinner wrote:
> On Thu, Oct 11, 2018 at 09:04:14AM -0500, Eric Sandeen wrote:
>> On 10/11/18 12:29 AM, Dave Chinner wrote:
>>> On Wed, Oct 10, 2018 at 02:37:08PM +0200, Carlos Maiolino wrote:
>>>> Most offset macro mess is used in xfs_stats_format() only, and we can
>>>> simply get the right offsets using offsetof(), instead of several macros
>>>> to mark the offsets inside __xfsstats structure.
>>>>
>>>> Replace all XFSSTAT_END_* macros by a single helper macro to get the
>>>> right offset into __xfsstats, and use this helper in xfs_stats_format()
>>>> directly.
>>>>
>>>> The quota stats code, still looks a bit cleaner when using XFSSTAT_*
>>>> macros, so, this patch also defines XFSSTAT_START_XQMSTAT and
>>>> XFSSTAT_END_XQMSTAT locally to that code. This also should prevent
>>>> offset mistakes when updates are done into __xfsstats.
>>>>
>>>> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> .....
>>> Now that I look at this more closely , it's a little bit ... odd.
>>> i.e. the endpoint offset points to the first variable in the next
>>> line, not the last variable of the stats line described by the text.
>>> While it works, it just doesn't seem quite right to me.
> ....
>> and "what can go wrong" is somebody extends one of the groups without
>> changing the end, or they insert a group without changing where the xqm
>> stats start.
> 
> <snip>
> 
> I don't really care that much - if was easy to change it would be
> nice, but wasting more than a couple of minutes on it isn't worth
> anyone's time. It's not complex, nor is it critical code so we do
> not need to bikeshed this to death. I'll just take the original
> patch as it's just a replacement of existing code and so is are
> acceptable.

I didn't think I was bikeshedding, just trying to actually achieve the
stated goal of making this whole stats structure foolproof when
new statistics get added.  It's not critical code, but it is a user
interface that we inadvertently broke, and we may break again.

Nothing /wrong/ with the original patch, I'm just not sure it achieves
the goal as well as it could.  I'll test & send a 2nd patch on top of it,
since I've already thought it through, and I do think it would be an
improvement.

-Eric
