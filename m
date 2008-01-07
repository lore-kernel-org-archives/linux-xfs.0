Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jan 2008 23:12:01 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m077BsrV022745
	for <xfs@oss.sgi.com>; Sun, 6 Jan 2008 23:11:56 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20F12C08B36
	for <xfs@oss.sgi.com>; Sun,  6 Jan 2008 23:12:10 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id S7ASs8H6stBjDQoN for <xfs@oss.sgi.com>; Sun, 06 Jan 2008 23:12:10 -0800 (PST)
Date: Mon, 7 Jan 2008 07:12:09 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove CONFIG_XFS_SECURITY
Message-ID: <20080107071208.GA29713@infradead.org>
References: <47819E47.4030906@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47819E47.4030906@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Jan 06, 2008 at 09:36:39PM -0600, Eric Sandeen wrote:
> Is there any point to this option?  Sure, it disables the ability
> to set security attributes at runtime, but it doesn't slim down 
> any code.
> 
> Any reason to not remove it, and always allow security attributes
> to be set?

I suspect the reason it is there currently is because the other
filesystems have similar option.   Removing it sounds perfectly
fine to me.
