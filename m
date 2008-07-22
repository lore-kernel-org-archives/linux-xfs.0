Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 19:23:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M2MwDV001009
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:22:58 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E245E78DB2
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:24:07 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id TKFUJuMXHBvGz4r4 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 19:24:07 -0700 (PDT)
Date: Tue, 22 Jul 2008 12:24:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Do not access buffers after dropping reference count
Message-ID: <20080722022404.GH6761@disturbed>
References: <4885430D.7000506@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885430D.7000506@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 22, 2008 at 12:16:45PM +1000, Lachlan McIlroy wrote:
> We should not access a buffer after dropping it's reference count otherwise
> we could race with another thread that releases the final reference count
> and frees the buffer causing us to access potentially unmapped memory.

Looks OK. The commit message should point out this is a problem
only for DEBUG kernels, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
