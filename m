Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 23:39:07 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0P7d1bG003349
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 23:39:03 -0800
Date: Fri, 25 Jan 2008 02:36:38 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with
	struct list_head
Message-ID: <20080125073638.GA24521@josefsipek.net>
References: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net> <20080121040422.GA25541@infradead.org> <20080121040740.GA14938@josefsipek.net> <20080125070800.GH155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125070800.GH155407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 25, 2008 at 06:08:00PM +1100, David Chinner wrote:
...
> Few things that really should be done in this first patch. Rather
> than passing listheads to the xfs_ail_*() functions, it should
> really be changed to pass the xfs_ail_t to those functions. The
> structure of the list should be opaque to everything outside these
> functions.
 
Agreed. I'm going to send a fixed up version of the patch sometime tomorrow.

> It also needs to build with XFS_DEBUG enabled - that means
> xfs_ail_check needs updating, but I've already got a patch
> for the other bit (xfsidbg.c) that works which is attached below.

Lesson learned...compile with XFS_DEBUG on.

Josef 'Jeff' Sipek.

-- 
Real Programmers consider "what you see is what you get" to be just as bad a
concept in Text Editors as it is in women. No, the Real Programmer wants a
"you asked for it, you got it" text editor -- complicated, cryptic,
powerful, unforgiving, dangerous.
