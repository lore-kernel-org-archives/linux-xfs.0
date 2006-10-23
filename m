Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Oct 2006 02:47:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9N9ldaG012954
	for <xfs@oss.sgi.com>; Mon, 23 Oct 2006 02:47:40 -0700
Received: from home.jason.bur.st (ppp77-57.lns1.mel3.internode.on.net [59.167.77.57])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 28FAD4C054D
	for <xfs@oss.sgi.com>; Mon, 23 Oct 2006 02:46:54 -0700 (PDT)
Date: Mon, 23 Oct 2006 19:46:34 +1000
From: Jason White <jasonjgw@internode.on.net>
Subject: Re: mount problem with xfs
Message-ID: <20061023094634.GA8449@jdc>
References: <20061023072613.33372.qmail@web8512.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061023072613.33372.qmail@web8512.mail.in.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Oct 23, 2006 at 08:26:13AM +0100, satish kumar wrote:
> I formatted a partition of size 5GB with xfs block size=16K
> I am not able to mount

Block size must be <= page size under Linux (see the XFS FAQ).

The page size is 4k for x86, 8k for ia64; the FAQ explains further.
