Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 09:47:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4RGlcbd024030
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:47:38 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9917BEED9B
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:48:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ztWTxCPsCnOn7Ouq for <xfs@oss.sgi.com>; Tue, 27 May 2008 09:48:29 -0700 (PDT)
Message-ID: <483C3B5C.3040407@sandeen.net>
Date: Tue, 27 May 2008 11:48:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_check
References: <20080527162605.GA30344@lst.de>
In-Reply-To: <20080527162605.GA30344@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> In the past we had quite a few cases where we told people to run
> xfs_repair -n instead of xfs_check.  I think that makes a lot of sense
> because xfs_repair -n generally gives output at least as useful as
> xfs_check if not more so and also is a lot faster.  Is there any reason
> why we shouldn't simply kill xfs_check and replaced it with a wrapper
> around xfs_repair?
> 
> 

xfs_check checks... $SOMETHING that xfs_repair still does not, I think?

But, if you can't run it on any fs of reasonable size due to memory
piggishness, then... *shrug*

-Eric
