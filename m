Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 22:36:00 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAH6ZpaG017339
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 22:35:51 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 697D85B8F46
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 22:35:03 -0800 (PST)
Message-ID: <52841.10.0.0.2.1163745285.squirrel@sandeen.net>
In-Reply-To: <20061117055521.GS11034@melbourne.sgi.com>
References: <455CB54F.8080901@sandeen.net>
    <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
    <20061117023946.GN11034@melbourne.sgi.com>
    <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>
    <20061117055521.GS11034@melbourne.sgi.com>
Date: Fri, 17 Nov 2006 00:34:45 -0600 (CST)
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
From: sandeen@sandeen.net
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> On Fri, Nov 17, 2006 at 02:11:12PM +1000, Timothy Shimmin wrote:

> Whenever you add to the table, you now need to modify both the new
> entry and the terminator to get it right.
>
> Nor (IMO) is it obvious that it is a terminator or why it is
> different to all the other entries in the structure. A field such as
> sb_dummy or sb_pad before the terminator is fairly obvious, and it
> means that you don't need to modify the table terminator every time
> the superblock gets extended.
>
> That way the code stays more consistent over time, diffs are smaller
> and neater, and you can see at a simple diff just how the features
> have been added over time (like I did this morning).....

nothing in the code is terribly obvious.. please add comments however you
decide to fix it :)

and really, now that this is out in the wild, maybe sb_features3 instead
of padding is appropriate, and check both for the attr2 bit...? :(

i'm trying to figure out what the kernel upgrade path is for fc6 users who
have an extra-padded-flipped features2/attr2 filesystem.  :(

-Eric
