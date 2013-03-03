Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1953C8013
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 03:03:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0701D304032
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 01:03:04 -0800 (PST)
Received: from radon.swed.at (a.ns.miles-group.at [95.130.255.143]) by
	cuda.sgi.com with ESMTP id C0wd8Xz2bPudHa1U (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 01:02:58 -0800 (PST)
Date: Sun, 3 Mar 2013 10:02:54 +0100
From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] Do not check ocfs2
Message-ID: <20130303100254.500b076f@spider.haslach.nod.at>
In-Reply-To: <20130303011917.GI23616@dastard>
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Am Sun, 3 Mar 2013 12:19:17 +1100
schrieb Dave Chinner <david@fromorbit.com>:

> On Sun, Mar 03, 2013 at 01:05:50AM +0100, Richard Weinberger wrote:
> > We cannot run fsck.ocfs2 because the file system
> > is most likely mounted on another node.
> 
> This patch means that ocfs2 filesystems are *never* checked for
> consistency, even when you are testing them with exclusive local
> access. That defeats a primary function of xfstests - ensuring that
> the tests run do no corrupt the filesystem.
> 
> Besides, why would you be running xfstests on a filesystem that is
> mounted on multiple nodes? Yes, ocfs2 is a cluster filesystem, but
> xfstests is designed to test local filesystem behaviour and is
> completely cluster naive. Hence having multiple nodes mount the
> filesystem that is being tested by xfstests does not serve any
> purpose at all. Further, turning off consistency checking for those
> that are running ocfs2 testing on single nodes means that testing is
> now mostly wasted as the majority of problems that can occur are no
> longer detectable....

Using xfstests I was able to trigger dlm issues in ocfs2.
I ran xfstests on one node and other nodes had it mounted too.
To ensure that fsck.ocfs2 will not corrupt the filesystem I've applied
this patch.

If you don't like the patch I'm perfectly fine with that.
Maybe it makes more sense to add a feature to xfstests which unmounts
the ocfs2 filesystem on all nodes (using SSH), then it is allowed to
run fsck.ocfs2.

Thanks,
//richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
