Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 12:34:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m91JYdXE002850
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 12:34:41 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABCF11306B3B
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 12:36:16 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id vTZa80mHs1ON3B5e for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 12:36:16 -0700 (PDT)
Subject: Re: RAID5/6 writes
From: Andi Kleen <andi@firstfloor.org>
References: <20081001175237.GJ32037@cordes.ca>
Date: Wed, 01 Oct 2008 21:36:13 +0200
In-Reply-To: <20081001175237.GJ32037@cordes.ca> (Peter Cordes's message of "Wed, 01 Oct 2008 14:52:37 -0300")
Message-ID: <87k5csp0pe.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Cordes <peter@cordes.ca>
Cc: xfs@oss.sgi.com

Peter Cordes <peter@cordes.ca> writes:
>
>  XFS knows (or should have been told by the admin with mkfs!) what the
> stripe geometry is: block size and stripe width.  So it could apply
> this optimization only if it would make a write cover more whole
> blocks or whole stripes.

It's a nice idea, but I don't think XFS knows the actual RAID level,
only the stripes. And for 0/1 it wouldn't be a good idea.

-Andi
