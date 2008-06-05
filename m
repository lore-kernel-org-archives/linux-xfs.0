Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Jun 2008 22:48:55 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m555mlZo021648
	for <xfs@oss.sgi.com>; Wed, 4 Jun 2008 22:48:48 -0700
Received: from QMTA10.westchester.pa.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4EF8178330A
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2008 22:49:41 -0700 (PDT)
Received: from QMTA10.westchester.pa.mail.comcast.net (qmta10.westchester.pa.mail.comcast.net [76.96.62.17]) by cuda.sgi.com with ESMTP id 505stXBNRw37Ckrv for <xfs@oss.sgi.com>; Wed, 04 Jun 2008 22:49:41 -0700 (PDT)
Date: Wed, 4 Jun 2008 22:49:38 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
Message-ID: <20080605054938.GA17690@puku.stupidest.org>
References: <47DB4181.7040603@sandeen.net> <480E89B5.8070006@sandeen.net> <481B7FD1.3030107@sandeen.net> <20080505070847.GH155679365@sgi.com> <481FDCD1.2010905@sgi.com> <4820609C.9090306@sandeen.net> <48477BD6.2020909@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48477BD6.2020909@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 05, 2008 at 12:38:30AM -0500, Eric Sandeen wrote:

> Guys, this is SIMPLE, SAFE, and it fixes a CORRUPTION BUG.

[...]

> >> As it only defines __arch_pack for __arm__,

__arch_pack is a horrible name and not very intuitive, what's wrong
with __on_disk or something else?
