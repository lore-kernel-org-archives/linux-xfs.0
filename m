Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 00:13:22 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBI8DGng028706
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 00:13:18 -0800
Received: from sargon.lncsa.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CB93495A01
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 00:13:27 -0800 (PST)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251]) by cuda.sgi.com with ESMTP id L8LUIxg4uF8lFTCF for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 00:13:27 -0800 (PST)
Message-ID: <47678124.80906@lncsa.com>
Date: Tue, 18 Dec 2007 09:13:24 +0100
From: Laurent CARON <lcaron@lncsa.com>
MIME-Version: 1.0
Subject: Re: Issue with 2.6.23 and drbd 8.0.7
References: <20071217143655.chiehahh@trusted.lncsa.com> <20071217220354.GU4396912@sgi.com> <4766F58C.8040000@lncsa.com> <20071217233759.GB4396912@sgi.com>
In-Reply-To: <20071217233759.GB4396912@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:
> Hmmm - no real surprises there, but the numbers are well lower than the
> ~960MB low memory limit. I suspect that there's something at around
> 2.55am that does a filesystem traversal and that blows out the memory
> usage of these slab caches and you run out of lowmem...

Thanks David for this information,

On the previous setup (same pieces of software), we didn't had that kind
of problem.

Do you think that more memory is used while using XFS on a filesystem
traversal than with ReiserFS (the previous setup used ReiserFS)?

I'm of course not trying to blame XFS, but trying to understand what
really happens there.

Laurent
