Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Feb 2008 05:22:26 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1GDMJI7026249
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 05:22:23 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19E155E3294
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 05:22:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id PNqJyVqKE7idsl9P for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 05:22:41 -0800 (PST)
Date: Sat, 16 Feb 2008 08:22:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] XFS: replace *_IDELETE with *_IKEEP
Message-ID: <20080216132238.GA1344@infradead.org>
References: <47B3B6AE.4030505@sandeen.net> <1202975139-10546-1-git-send-email-jeffpc@josefsipek.net> <20080215161902.GA32398@infradead.org> <47B5BC8F.2090102@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B5BC8F.2090102@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com

On Fri, Feb 15, 2008 at 10:23:43AM -0600, Eric Sandeen wrote:
> IMHO if we want to display defaults, then we should probably change it
> so that all defaults are displayed, and not make noikeep special in this
> respect.  (oh, and "noquota" is already there, too)
> 
> Doesn't matter much to me either way but it should be consistent across
> all options, I think.

True, it's probably better to kill the noikeep string.
