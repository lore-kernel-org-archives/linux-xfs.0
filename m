Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Oct 2007 00:36:34 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9B7aL8X029213
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 00:36:24 -0700
Message-ID: <470DD275.9090602@lncsa.com>
Date: Thu, 11 Oct 2007 09:36:21 +0200
From: Laurent CARON <lcaron@lncsa.com>
MIME-Version: 1.0
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
References: <20071004133302.GA5058@apartia.fr> <4704FA19.2080101@theendofthetunnel.de> <20071010151537.GA31573@apartia.fr> <20071010224644.GP995458@sgi.com>
In-Reply-To: <20071010224644.GP995458@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: David Chinner <dgc@sgi.com>

David Chinner wrote:
> Yes, please turn on slab debugging so we can try to find the cause
> of this memory corruption. I expect the problem to be in DRBD as
> nobody else running XFS is reporting this problem. However, without
> running with the right debug options enabled we'll never get to
> the bottom of the problem.


Hi,

Before installing a new kernel i've got a (little?) clue.

The setup is as follows:

The drbd partition is mounted to a generic mountpoint
/dev/drbd1 on /data/web type xfs (rw)

The subdirectories of /data/web are mounted (mount --bind) to another
directory
/data/web/var/www on /var/www type xfs (rw,bind)
/data/web/var/lib/postgresql on /var/lib/postgresql type xfs (rw,bind)
/data/web/var/lib/mysql on /var/lib/mysql type xfs (rw,bind)


It seems I made a mistake here.

mount -t xfs --bind /data/web/var/www /var/www

instead of

mount --bind /data/web/var/www /var/www

Could this be 'THE' root of the problem (if the system then sees
/var/www as a 'real' XFS filesystem and not a directory mounted over) ?

Thanks

Laurent
