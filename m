Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 13:01:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TK1KBe010547
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 13:01:20 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 983271CE0BC
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 13:02:12 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 0NdrPMmvD2YQvz86 for <xfs@oss.sgi.com>; Thu, 29 May 2008 13:02:12 -0700 (PDT)
Message-ID: <483F0BC3.2050901@sandeen.net>
Date: Thu, 29 May 2008 15:02:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS: SB validate failed
References: <3607657a0805291005k457791cej1c5f867da0f95965@mail.gmail.com>	 <483EE5BD.8020407@sandeen.net> <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>
In-Reply-To: <3607657a0805291255i59fd006fi9d6836cf528d19a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Spam Magnet <spam.wax@gmail.com>
Cc: xfs@oss.sgi.com

Spam Magnet wrote:

> So can this be related to the byte ordering or any of the other
> issues mentioned in the FAQ regarding xfs under Linux ?
> How can I figure out if my disk is using XLV or is a v2 directory ?

Byte ordering is only an issue for the log replay; you'd get a message
about that if it were the issue.

Does file -s /dev/sdb? say that any of those things even look like an
xfs filesystem?

If so point xfs_db at it like:

xfs_db -r -c "sb 0" -c "p" /dev/sdb<whatever>

that'll tell you if it has v1 dirs I think.

-Eric
