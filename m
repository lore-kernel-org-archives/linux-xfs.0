Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA90B7F47
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 09:53:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0578C8F8064
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 07:53:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yhxOM6o1rD7xWAcB for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 07:53:23 -0800 (PST)
Message-ID: <54F87BF3.3000405@sandeen.net>
Date: Thu, 05 Mar 2015 09:53:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
References: <54EC958E.2000001@pythonanywhere.com>	<20150224215907.GA18360@dastard>	<54EF1A8F.7030505@pythonanywhere.com>
	<54F856E7.10006@pythonanywhere.com>
In-Reply-To: <54F856E7.10006@pythonanywhere.com>
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
To: Harry <harry@pythonanywhere.com>, xfs@oss.sgi.com
Cc: "developers@pythonanywhere.com" <developers@pythonanywhere.com>

On 3/5/15 7:15 AM, Harry wrote:
> Update -- so far, we've not managed to gain any confidence that we'll
> ever be able to re-mount that disk. The general consensus seems to be
> to fish all the data off the disk using rsync, and then move off XFS
> to ext4.
> 
> Not a very helpful message for y'all to hear, I know. But if it's any
> help in prioritising your future work, i think the dealbreaker for us
> was the inescapable quotacheck on mount, which means that any time a
> fileserver goes down unexpectedly, we have an unavoidable,
> indeterminate-but-long period of downtime...
> 
> hp

What you decide to use is up to you of course, and causes us no
heartbreak.  :)  But I think you fundamentally misunderstand the situation;
an unexpected fileserver failure should not result in a lengthy quotacheck
on xfs, because xfs quota is journaled, and will simply be replayed along with
the rest of the log.

I honestly don't know what has led you to the conclusion that remounting
the filesystem will lead to any quotacheck at all, let alone a lengthy one.

> * We're even a bit worried the disk might be in a broken state, such
> that the quotacheck won't actually complete successfully at all.

If your disk is broken, that's not a filesystem issue.  It seems possible
that whatever drbd manipulation you're doing is causing an issue, but because
you haven't really explained it in detail, I don't know.

> We take DRBD offline, so it's no longer writing, then we take
> snapshots of the drives, then remount those elsewhere so we can
> experiment without disturbing the live system.

Did you quiesce the filesystem first with i.e. xfs_freeze?

So far this thread has been long on prose and speculation, and short
on actual analysis, log messages, etc.  Feel free to use ext4 or whatever
suits you, but given that nothing in this thread has implicated misbehavior
by xfs, I don't think that switching filesystems will solve the perceived
problem.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
