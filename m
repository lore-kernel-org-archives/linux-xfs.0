Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6E72E7CA2
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 17:37:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 31C388F8037
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 15:37:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qDxmj5BBsyEFQngQ for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 15:37:12 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8D439541
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 17:37:11 -0500 (CDT)
Subject: Re: Some xfstests failures on non-crc xfs with latest xfsprogs
	(v4.5.0-rc1)
References: <20160304112354.GX11419@eguan.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <727b405b-7df2-641a-d4d0-24333e003374@sandeen.net>
Date: Fri, 24 Jun 2016 17:37:10 -0500
MIME-Version: 1.0
In-Reply-To: <20160304112354.GX11419@eguan.usersys.redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 3/4/16 5:23 AM, Eryu Guan wrote:
> Hi,
> 
> I noticed some xfstests failures while testing v4 XFS with latest
> v4.5.0-rc1 xfsprogs on v4.5-rc6 kernel, and all these failures are gone
> if I use v3.2.4 xfsprogs, or if test on v5 XFS.
> 
> So either xfstests needs update or xfsprogs breaks something for non-crc
> XFS. But I'm not sure which is which, so I post them out for broader
> review.
> 
> (All tests are checked with 'MKFS_OPTIONS="-m crc=0" ./check <sometest>')

Eryu, sorry you didn't get a reply on this in March.  We should have
listened!  ;)  The patches I sent in the pat day or two should
fix some of these ...

> == 1. xfs/032 fsck failure (xfs_db check) on ppc64 host ==

but not this one.  Do you still see this?

> == 2. xfs/033 fsck failure ==
> 
> xfs_repair detects more nlinks error. And this happens after commit
> "c2c5096 libxfs: update to 3.16 kernel code"

this should be fixed by
[PATCH] xfs_repair: set rsumino version to 2
 
> == 3. xfs/108 xfs/196 xfs/261 xfs/244 fsck failure. ==

this should be fixed by
[PATCH] xfs_repair: don't call xfs_sb_quota_from_disk twice

although I'm not sure about the ppc-specific failure.
 
> These tests fail in a similiar way, and they are all quota related.
> Note that xfs/244 only fails on ppc64, others fail on all arches.

> == 4. xfs/186 xfs/187 attr test failure ==
> 
> xfs/186 is missing almost all the attr values.

[PATCH] xfs/186: fix test for crc=0, ftype=1

> xfs/187 reports test needs update.

Not sure on this one yet.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
