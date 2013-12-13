Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5E6667F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 18:00:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E5A38F8033
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:00:46 -0800 (PST)
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	2MIRUWnV3TGpJD7P (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 16:00:44 -0800 (PST)
Received: by mail-ie0-f181.google.com with SMTP id e14so1731340iej.26
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:00:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131212225657.GK10988@dastard>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
	<20131212180130.GA19422@infradead.org>
	<20131212225657.GK10988@dastard>
Date: Thu, 12 Dec 2013 16:00:44 -0800
Message-ID: <CAFA30n9ea3A+V7JgCgqO5xOQchgB55oLP4AgtQ3KQpCMr9iEzQ@mail.gmail.com>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
From: Junho Ryu <jayr@google.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>, Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

> I don't know what the solution here is - everything I think of is
> either messy, ugly or unmaintainable. All I'm trying to do is find a
> way to handle tmpfs filesystems in a way that is maintainable and
> doesn't require every developer to be aware of the quirks of tmpfs
> when writing and reviewing new generic tests....

If it is acceptable that tmpfs running tests which does not make much
sense without actually re-mounting devices, all other developers need
to care is using _scratch_remount() and _test_remount().

Even if someone does not use the functions, tests will only fail on
tmpfs, and people like me who cares about it will be happy to fix it.

So far, generic/053 is the only test which does something else between
umount and mount.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
