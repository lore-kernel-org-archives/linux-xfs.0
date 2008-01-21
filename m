Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 20:07:37 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L47WiP004044
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:07:35 -0800
Received: from filer.fsl.cs.sunysb.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D064CAAFCC
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:07:51 -0800 (PST)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2]) by cuda.sgi.com with ESMTP id MIwv4GWlhLD0b6A3 for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 20:07:51 -0800 (PST)
Date: Sun, 20 Jan 2008 23:07:40 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with
	struct list_head
Message-ID: <20080121040740.GA14938@josefsipek.net>
References: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net> <20080121040422.GA25541@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121040422.GA25541@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 21, 2008 at 04:04:23AM +0000, Christoph Hellwig wrote:
> On Sun, Jan 20, 2008 at 07:35:57PM -0500, Josef 'Jeff' Sipek wrote:
> > Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> > ---
> > 
> > I tested it with xfsqa, and things work as well as they do without it.
> 
> I like this a lot, but I think Dave has plans to replace the linked list
> with a more efficient data structure soon, so it might not actually be
> worth applying.

I've spoken with him about this, and he wants to have a tree where the
leaves have linked lists (if I understood correctly). So this just makes it
easier/cleaner for him.

Josef 'Jeff' Sipek.

-- 
Hegh QaQ law'
quvHa'ghach QaQ puS
