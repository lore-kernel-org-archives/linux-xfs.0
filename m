Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMMClU4002837 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 16:12:48 -0600
Message-ID: <495010A2.2030903@sgi.com>
Date: Tue, 23 Dec 2008 09:11:46 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/20] xfs-cmds staging tree
References: <20081222163831.755809000@bombadil.infradead.org>
	<494FF9B3.9030103@sgi.com> <20081222204956.GA23453@infradead.org>
In-Reply-To: <20081222204956.GA23453@infradead.org>
Reply-To: markgw@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com



Christoph Hellwig wrote:
> On Tue, Dec 23, 2008 at 07:33:55AM +1100, Mark Goodwin wrote:
>>
>> Christoph Hellwig wrote:
>>> This is the staging tree of xfs patches.  Given that Barry is gone now it seem
>>> like no one cares about userspace and I'll play patch monkey for now.
>> Thanks Christoph. Lachlan and I were just discussing yesterday that
>> it's time to set up a git repository for xfs-cmds on oss. This would
>> contain all the userspace stuff: attr, acl, xfsprogs, dmapi, xfsdump
>> and xfstests.
>>
>> Anyone have a reason not to keep all of this together in the one tree?
>> I guess we'd need branches for 'master' (aka dev) and 'stable' or
>> something ..?
>
> Yes, that's a plan.  Can you set it up in a way that we can push
> directly to, similar to how Nathan does it for pcp?

I unsure, but don't think a group writable repository would work too well.
Nathan doesn't push directly into the official pcp git tree (which is at
git://oss/pcp/pcp.git) but rather pushes to his own git tree (which is
at git://oss/nathans/pcp.git). SGI review and pull those commits and push
them into the official tree (via an internal staging tree using a hook
for the ptools back-end, but that's transparent to oss users). Nathan also
reviews patches from others and pulls their patches into his tree, and
regularly re-syncs with the official tree. git works it all out just fine.

This is fairly new, but seems to work rather well since it supports
effective collaboration for trusted contributors without SGI becoming
a patch acceptance bottleneck - sort of a multiple maintainership.

> Nathan would also like to push to the xfs-cmds tree for the debian packaging, btw.

ok

> One thing we were discussing is if it's really a good idea to have all
> these together.

It would certainly help SGI if the directory structure for the proposed
xfs-cmds tree remained the same as it is in ptools at the moment. I
guess we could consider splitting each xfs-cmds directory into separate
repositories, but then building it all togetheer would be a pain. It could
certainly make sense to split off xfstests into it's own tree since it's
not part of the xfs-cmds build.

Cheers
- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
