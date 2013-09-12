Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBFB37F54
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 16:54:24 -0500 (CDT)
Message-ID: <5232380E.4040300@sgi.com>
Date: Thu, 12 Sep 2013 16:54:22 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Time for an xfsprogs "alpha1" release?
References: <52322F7A.8060405@sandeen.net>
In-Reply-To: <52322F7A.8060405@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 09/12/13 16:17, Eric Sandeen wrote:
> With all of the changes for CRC filesystems in xfsprogs git now, I'm wondering if it'd be a good idea to do a "3.2.0-alpha1" sort of release.
>
> I know it's not yet feature complete, but I think there would be value in getting a version-stamped tarball out there for testing - it could filter to rawhide-ish distros, and get a bit more airtime while the remaining bits get worked out.
>
> We'd probably want a nice readme about what's new and what's not yet done, caveats, etc, but I think it'd be worth getting it out there into the hands of willing testers, w/o requiring them to do a build from git.
>
> Thoughts?
>
> Thanks,
> -Eric
>

Good idea, but xfsprogs is in a state that it can't compile:

    http://oss.sgi.com/archives/xfs/2013-09/msg00396.html

Patch 31 v3 / 55 is broken. It is missing xfs_sb.c and has an extra
xfs_mount.c.

If you want it this week, we could do the corrections or wait for Dave
to repost.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
