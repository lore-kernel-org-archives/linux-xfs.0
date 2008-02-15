Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 08:19:20 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1FGJAhI016839
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 08:19:11 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87D2D5DE7C3
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 08:19:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id Jv8NY5qEItgxRLkc for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 08:19:35 -0800 (PST)
Date: Fri, 15 Feb 2008 11:19:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] XFS: replace *_IDELETE with *_IKEEP
Message-ID: <20080215161902.GA32398@infradead.org>
References: <47B3B6AE.4030505@sandeen.net> <1202975139-10546-1-git-send-email-jeffpc@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202975139-10546-1-git-send-email-jeffpc@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, sandeen@sandeen.net

On Thu, Feb 14, 2008 at 02:45:39AM -0500, Josef 'Jeff' Sipek wrote:
> Change the *_IDELETE flags to *_IKEEP, and flip the logic as necessary.
> 
> This completely eliminates the no-no-no-idelete madness.
> 
> Additionally, "ikeep" or "noikeep" is always displayed in /proc/mounts
> option string. This should help clear up any confusion about what the
> current mode is.

Looks fine to me, and I think the changed display in /proc/<pid>/mounts
is fine aswell.
