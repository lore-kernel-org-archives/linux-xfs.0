Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o66CEhOL181156 for <xfs@oss.sgi.com>; Tue, 6 Jul 2010 07:14:45 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD4011B259E6
	for <xfs@oss.sgi.com>; Tue,  6 Jul 2010 05:17:32 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id 8dk7mOH7O7utwkuX for
	<xfs@oss.sgi.com>; Tue, 06 Jul 2010 05:17:32 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Fwd: Need assistance on XFS undeleting files
References: <AANLkTik59zx97OVNXSfk4Gbe5poVAIGgJiTJVlsJZIjL@mail.gmail.com>
	<201007060807.24582.misiek@pld.org.pl>
	<AANLkTikhinYuUDsT-5hqyNkR89Y4PeosvAQ3K2LFqYkn@mail.gmail.com>
Date: Tue, 06 Jul 2010 14:17:28 +0200
In-Reply-To: <AANLkTikhinYuUDsT-5hqyNkR89Y4PeosvAQ3K2LFqYkn@mail.gmail.com>
	(James Shih's message of "Tue, 6 Jul 2010 07:16:20 -0400")
Message-ID: <87fwzwx0rr.fsf@basil.nowhere.org>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: James Shih <shija03@gmail.com>
Cc: xfs@oss.sgi.com

James Shih <shija03@gmail.com> writes:
>
>    I would like to know if the development team carries such tools -
> tools that allow one to list the inodes of the XFS filesystem of
> deleted files, and tools that allow one to cat (dump) the blocks from
> a starting inode to all the following blocks until an indication that
> the file is ended or a new indication of a new file appears. (these
> tools would correspond to TCT's ils and pcat respectively).

XFS has no separate reserved inode table (but just allocates/free blocks
in the fs), so it can be difficult to even find the inodes when they're
gone.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
