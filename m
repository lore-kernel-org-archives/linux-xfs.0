Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Mar 2007 08:42:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l21GgN6p027191
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2007 08:42:24 -0800
Message-ID: <45E701A2.1020304@sandeen.net>
Date: Thu, 01 Mar 2007 10:38:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: can't mount xfs partition
References: <29a617af0703010748g51ef81b1x9c0467602d09793@mail.gmail.com>
In-Reply-To: <29a617af0703010748g51ef81b1x9c0467602d09793@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: M Kili <m0kili@gmail.com>
Cc: xfs@oss.sgi.com

M Kili wrote:
> xfs_check doesn't give any message, and still, the image can't be
> mounted, with the same error:
> # mount -o loop hda5.img /mnt/
> mount: /dev/loop0: can't read superblock

look at dmesg output, see what it says.

Does "-t xfs" help?

-Eric
