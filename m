Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 20:40:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2J3eCMr015584
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 20:40:15 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0C806BB58F
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 20:40:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id FEJVxSv1PZAZTB0M for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 20:40:40 -0700 (PDT)
Message-ID: <47E08B18.9060500@sandeen.net>
Date: Tue, 18 Mar 2008 22:40:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <b1b17e290803181631x60a3e921l836b115c3b026773@mail.gmail.com> <47E085F3.8030908@sandeen.net>
In-Reply-To: <47E085F3.8030908@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andre Draszik <xfs@andred.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> xfs_dinode_t has no extra padding at the end, though xfs_dir2_sf, a
> member of one of its unions, does (though other union members are larger
> though, so the struct offsets are not changed.)

actually that's not quite right, but in any case it does not change the
size of the union or subsequent member offsets.

-Eric
