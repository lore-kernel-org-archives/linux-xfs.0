Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 20:04:16 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L446om003528
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:04:10 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15EF34E807C
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:04:25 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id QtXFWwQljCRVnfum for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:04:25 -0800 (PST)
Date: Mon, 21 Jan 2008 04:04:23 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with
	struct list_head
Message-ID: <20080121040422.GA25541@infradead.org>
References: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

On Sun, Jan 20, 2008 at 07:35:57PM -0500, Josef 'Jeff' Sipek wrote:
> Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> ---
> 
> I tested it with xfsqa, and things work as well as they do without it.

I like this a lot, but I think Dave has plans to replace the linked list
with a more efficient data structure soon, so it might not actually be
worth applying.
