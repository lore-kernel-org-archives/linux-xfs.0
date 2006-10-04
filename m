Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Oct 2006 12:08:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k94J80aG004989
	for <xfs@oss.sgi.com>; Wed, 4 Oct 2006 12:08:01 -0700
Received: from mx1.suse.de (ns.suse.de [195.135.220.2])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C017546CC57
	for <xfs@oss.sgi.com>; Wed,  4 Oct 2006 10:59:20 -0700 (PDT)
Subject: Re: [RFC 0/3] Convert XFS inode hashes to radix trees
References: <20061003060610.GV3024@melbourne.sgi.com>
	<20061003212335.GA13120@tuatara.stupidest.org>
	<20061003222256.GW4695059__33273.3314754025$1159914338$gmane$org@melbourne.sgi.com>
From: Andi Kleen <ak@suse.de>
Date: 04 Oct 2006 19:59:15 +0200
In-Reply-To: <20061003222256.GW4695059__33273.3314754025$1159914338$gmane$org@melbourne.sgi.com>
Message-ID: <p73y7rwynbg.fsf@verdi.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com, dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>

David Chinner <dgc@sgi.com> writes:
> 
> And yes, 64 bit systems are cheap, cheap, cheap so IMO this
> functionality is really irrelevant moving forward. If it had come
> along a couple of years ago then it would be different, but I think
> mainstream technology is finally catching up with XFS so it's not a
> critical issue anymore... ;)

One issue is that people often still run a lot of 32bit userland
even with 64bit kernels. The compat layer will just truncate
the inodes I think. But so far I haven't heard of anybody
complaining on x86-64.

-Andi
