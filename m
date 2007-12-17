Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 21:48:52 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBH5mV7g030184
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 21:48:45 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A52245B8B99
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 21:48:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id u4xDg0VzF9FrmqhM for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 21:48:43 -0800 (PST)
Message-ID: <47660DB7.5000104@sandeen.net>
Date: Sun, 16 Dec 2007 23:48:39 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [review] Remove the xfs refcache
References: <4765EC66.5020202@sgi.com> <4765F444.8010705@sgi.com>
In-Reply-To: <4765F444.8010705@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Hey hold on there buddy!  We may need to reactivate this code to fix some
> performance issues.  I've acttually got this code working and proven that
> it is one way to fix some of the NAS/NFS issues we have.
> 
> The little comment that reads "reference cache not needed for NFS in 2.6"
> is wrong - we do need it or something like it.

So, the whole reason this was not built for 2.6 was that ostensibly the
2.6 kernel already did this sort of caching for nfs.  But, last time I
looked I didn't see anything obvious.  Anybody know? :)

-Eric


> Donald Douwsma wrote:
>> Remove the xfs_refcache, it was only needed while we were still building 
>> for
>> 2.4 kernels.
>>
>>
> 
> 
