Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 03:48:23 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m15BmHoR018967
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 03:48:19 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0BA159FA5F
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 03:48:36 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159]) by cuda.sgi.com with ESMTP id Fz8F6sf10Up2zKGu for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 03:48:36 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so2261341fga.8
        for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 03:48:33 -0800 (PST)
Message-ID: <b0a4f3350802050342i48525c02we95a2a4e89327688@mail.gmail.com>
Date: Tue, 5 Feb 2008 11:42:23 +0000
From: "Jamie Tufnell" <diesql@googlemail.com>
Subject: Linux mkfs.xfs parameters for large files
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I've done some research into how to best-prepare our Linux (2.6.18)
XFS filesystem for a read-heavy workload of mostly large files (files
between 50MB and 500MB) and I have some questions on block-sizes /
extents.

My experience with other filesystems leads me to believe I should
experiment with large block-sizes for this application.  In trying to
do so, I found that the Linux XFS implementation forces the block size
to not exceed the page size -- 4kB -- which seems a bit small in this
case.  At first, I thought this was *really* bad news for me but I've
since read some posts and the impression I'm getting is it's not that
big of a deal?

Can someone please explain why (if that's true)?  I've read that an
extent is one or more "continguous" blocks, so should I simply tune
the extent size in the same way I was expecting to tune the
block-size?  Are there any other mkfs.xfs parameters I should
experiment with.. so far I plan to use stripe width/unit as the
filesystem will be on a striped RAID.

Lastly, would you recommend XFS for this application?  Is there a
better filesystem for what I'm trying to do?

Any help greatly appreciated!

Thanks,
J.
