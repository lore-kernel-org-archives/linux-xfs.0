Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 19:55:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K2tRaB027947
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:55:27 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC9AF1B609A6
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:57:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id lxjsUFxoee4XSDn3 for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:57:11 -0700 (PDT)
Message-ID: <48FBF385.2010709@sandeen.net>
Date: Sun, 19 Oct 2008 21:57:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS slow performance
References: <48FBDC47.5080700@ramunia.com> <48FBEBFA.30200@sandeen.net> <48FBED80.60604@ramunia.com>
In-Reply-To: <48FBED80.60604@ramunia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Muhammad Fakhrul Rozi Bin Mohd Seth <rozi@ramunia.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Muhammad Fakhrul Rozi Bin Mohd Seth wrote:
> Thanks for the reply;

No problem; please keep the list on cc: so that others with similar
problems will have something to find on google :)

> Yes i have test the other's and it is more worst than XFS.
> So here the snapshot is provide by the LVM not the XFS itself?

That's right; xfs itself has no snapshot capability.  It's done at the
block layer (via lvm in your case).

> Have face any issue on snapshot using LVM before?

I don't use snapshots much so can't say, but they do have overhead.  You
may have more luck asking for suggestions on the lvm users list.  There
might be some tuning you can do.

-Eric

> Regards
> Rozi
