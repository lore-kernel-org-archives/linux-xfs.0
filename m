Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 086597F3F
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 12:45:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD1878F8035
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 10:45:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jmVeBe4b2KHlwmUe for <xfs@oss.sgi.com>;
	Tue, 10 Nov 2015 10:45:28 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id DDEFB6372A81
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 12:45:27 -0600 (CST)
Subject: Re: [PATCH] xfsprogs: fix cut & paste error in xfs_fsr.c
References: <56423596.3030300@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56423B47.4060306@sandeen.net>
Date: Tue, 10 Nov 2015 12:45:27 -0600
MIME-Version: 1.0
In-Reply-To: <56423596.3030300@redhat.com>
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

On 11/10/15 12:21 PM, Eric Sandeen wrote:
> Commit:
> 
> 7141fc xfsprogs: make fsr use mntinfo when there is no mntent
> 
> added an inadvertent "break;" to initallfs() after the call
> to find_mountpoint_check(); this is likely a cut & paste error
> from the call in find_mountpoint(), where we really *do* want to
> stop after the first one we find.
> 
> Fix that by removing the break, and fix the declaration-after-code.
> 
> Addresses-Coverity-Id: 1338431
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Actually, unless Jan's commit fixes something important for this
release (and I don't think it does?) I'd just revert it; it's
pretty chock full of outright errors and other weirdness.

For example:

initallfs(mtab);
   struct stat64 sb;
   mntp = find_mountpoint_check(&sb, mp, &ms);

and find_mounpoint_check() does:

     if (S_ISDIR(sb->st_mode)) {

so "sb" is never initialized on that path.  Weird that Coverity
didn't see it.

(I'm also not a fan of using "sb" and "mp" for things that aren't
superblocks and xfs_mount_t's, but that's just style I guess...)

((and every caller passes an ms stat buffer into the function,
which can be local to the function, as no caller uses it ...))

(((and there's whitespace damage)))

Jan said this patch "fell under the sofa" - I think it might need a
bit more dusting off before it's ready to go... ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
