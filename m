Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Sep 2006 13:30:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8QKUhaG006549
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 13:30:44 -0700
Received: from pat.uio.no (pat.uio.no [129.240.10.4])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3851D118233
	for <xfs@oss.sgi.com>; Tue, 26 Sep 2006 13:30:05 -0700 (PDT)
Subject: Re: [NFS] Long sleep with i_mutex in xfs_flush_device(), affects
	NFS service
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <Pine.LNX.4.64.0609261531430.10642@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
	 <1159297579.5492.21.camel@lade.trondhjem.org>
	 <Pine.LNX.4.64.0609261531430.10642@madrid.max-t.internal>
Content-Type: text/plain
Date: Tue, 26 Sep 2006 16:29:56 -0400
Message-Id: <1159302596.5492.57.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: xfs@oss.sgi.com, nfs@lists.sourceforge.net

On Tue, 2006-09-26 at 16:05 -0400, Stephane Doyon wrote:
> I suppose it's not technically wrong to try to flush all the pages of the 
> file, but if the server file system is full then it will be at its worse. 
> Also if you happened to be on a slower link and have a big cache to flush, 
> you're waiting around for very little gain.

That all assumes that nobody fixes the problem on the server. If
somebody notices, and actually removes an unused file, then you may be
happy that the kernel preserved the last 80% of the apache log file that
was being written out.

ENOSPC is a transient error: that is why the current behaviour exists.

Cheers,
  Trond
