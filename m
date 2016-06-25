Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1CE607CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 23:44:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB03CAC002
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 21:44:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OAQJE9kuWnir69a4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Jun 2016 21:44:12 -0700 (PDT)
Date: Sat, 25 Jun 2016 12:44:10 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: Some xfstests failures on non-crc xfs with latest xfsprogs
	(v4.5.0-rc1)
Message-ID: <20160625044410.GD23649@eguan.usersys.redhat.com>
References: <20160304112354.GX11419@eguan.usersys.redhat.com>
	<727b405b-7df2-641a-d4d0-24333e003374@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <727b405b-7df2-641a-d4d0-24333e003374@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Jun 24, 2016 at 05:37:10PM -0500, Eric Sandeen wrote:
> On 3/4/16 5:23 AM, Eryu Guan wrote:
> > Hi,
> > 
> > I noticed some xfstests failures while testing v4 XFS with latest
> > v4.5.0-rc1 xfsprogs on v4.5-rc6 kernel, and all these failures are gone
> > if I use v3.2.4 xfsprogs, or if test on v5 XFS.
> > 
> > So either xfstests needs update or xfsprogs breaks something for non-crc
> > XFS. But I'm not sure which is which, so I post them out for broader
> > review.
> > 
> > (All tests are checked with 'MKFS_OPTIONS="-m crc=0" ./check <sometest>')
> 
> Eryu, sorry you didn't get a reply on this in March.  We should have
> listened!  ;)  The patches I sent in the pat day or two should

Thanks for looking at them! :)

> fix some of these ...
> 
> > == 1. xfs/032 fsck failure (xfs_db check) on ppc64 host ==
> 
> but not this one.  Do you still see this?

My recent test with 4.7-rc4 kernel and latest xfsprogs (June 22nd) shows
xfs/032 passed on ppc64 host. But I'll retest to be sure.

> 
> > == 2. xfs/033 fsck failure ==
> > 
> > xfs_repair detects more nlinks error. And this happens after commit
> > "c2c5096 libxfs: update to 3.16 kernel code"
> 
> this should be fixed by
> [PATCH] xfs_repair: set rsumino version to 2
>  
> > == 3. xfs/108 xfs/196 xfs/261 xfs/244 fsck failure. ==
> 
> this should be fixed by
> [PATCH] xfs_repair: don't call xfs_sb_quota_from_disk twice
> 
> although I'm not sure about the ppc-specific failure.

My recent test on RHEL7 shows xfs/244 is not ppc-specific. I'll retest
with latest kernel and xfsprogs on ppc64 and report back.

>  
> > These tests fail in a similiar way, and they are all quota related.
> > Note that xfs/244 only fails on ppc64, others fail on all arches.
> 
> > == 4. xfs/186 xfs/187 attr test failure ==
> > 
> > xfs/186 is missing almost all the attr values.
> 
> [PATCH] xfs/186: fix test for crc=0, ftype=1

Thanks! I've queued it in fstests next pull request.

Thanks,
Eryu

> 
> > xfs/187 reports test needs update.
> 
> Not sure on this one yet.
> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
