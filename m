Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 19:58:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBH3whPu019457
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 19:58:46 -0800
Message-ID: <4765F444.8010705@sgi.com>
Date: Mon, 17 Dec 2007 15:00:04 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [review] Remove the xfs refcache
References: <4765EC66.5020202@sgi.com>
In-Reply-To: <4765EC66.5020202@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey hold on there buddy!  We may need to reactivate this code to fix some
performance issues.  I've acttually got this code working and proven that
it is one way to fix some of the NAS/NFS issues we have.

The little comment that reads "reference cache not needed for NFS in 2.6"
is wrong - we do need it or something like it.

Donald Douwsma wrote:
> Remove the xfs_refcache, it was only needed while we were still building 
> for
> 2.4 kernels.
> 
> 
