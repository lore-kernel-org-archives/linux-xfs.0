Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 11 Nov 2006 03:09:27 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kABB9IaG025713
	for <xfs@oss.sgi.com>; Sat, 11 Nov 2006 03:09:19 -0800
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4443515DA2
	for <xfs@oss.sgi.com>; Sat, 11 Nov 2006 02:56:31 -0800 (PST)
Date: Sat, 11 Nov 2006 10:56:27 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove unused filp from ioctl functions
Message-ID: <20061111105627.GB3356@infradead.org>
References: <4555437B.4040904@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4555437B.4040904@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Nov 10, 2006 at 09:28:59PM -0600, Eric Sandeen wrote:
> There's a stuct file * passed around the ioctl code that is never
> used... just takes up precious stack space near as I can tell :)

While you're at it kill the inode paramater anyway, it can be retrieved
from the vnode by trivial address arithmetics.
