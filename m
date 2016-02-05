Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DBE07CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 23:27:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEA47AC001
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 21:27:42 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Qe0PC2iTvfsZ7Ov4 for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 21:27:40 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A665663C5D8D
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 23:27:39 -0600 (CST)
Subject: Re: [PATCH 1/2] xfs_quota: allow operation on foreign filesystem types
References: <1454627718-19583-1-git-send-email-david@fromorbit.com>
	<1454627718-19583-2-git-send-email-david@fromorbit.com>
	<56B3E6F3.802@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B432CB.5080709@sandeen.net>
Date: Thu, 4 Feb 2016 23:27:39 -0600
MIME-Version: 1.0
In-Reply-To: <56B3E6F3.802@sandeen.net>
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



On 2/4/16 6:04 PM, Eric Sandeen wrote:
> Looks ok, but now with the new option:
> 
> 1) needs a manpage update
> 2) usage() should be updated to include -f

So, I haven't quite worked out what this *is* doing, but on further reflection,
it seems like "-f" should definitely relate to behavior which iterates over
all filesystems.  i.e. without -f, non-xfs filesystems are skipped; with -f,
"foreign" filesystems are included.  That was my main concern.

But if an xfs_quota command is pointed directly at a non-xfs filesystem,
I'm not sure what's best.  Assume the user intended it, and operate on
that fs w/o needing -f?  Or require "-f" for consistency?  What do you think?

And, we can specify multiple mount points to operate on, i.e.

xfs_quota -c "foo" /mnt/ext4 /mnt/xfs

so ... I guess I don't know if that should require -f or not.  principle of
least surprise?  Keep old behavior of ignoring the non-xfs mount?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
