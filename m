Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:24:21 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9OAYA030194
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:24:11 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E58CE154AB67
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:24:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id O2OLfbCYuxJvcHuR for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:24:10 -0800 (PST)
Date: Wed, 12 Nov 2008 04:23:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3 v4]  hook xfs to fiemap ioctl
Message-ID: <20081112092340.GE8896@infradead.org>
References: <49089596.80006@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49089596.80006@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Oct 29, 2008 at 11:55:50AM -0500, Eric Sandeen wrote:
> Also, here's a very hacky (don't laugh!) test app.  I'll clean it
> up at some point   :)  
> 
> (v4: test app slightly more cleaned up)

Can you wire up the test program to xfsqa?  Also instead of having your
own #defines for the constants just use a copy of fiemap.h?
