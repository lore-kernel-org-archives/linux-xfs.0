Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 17:48:16 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K0mBXP016396
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 17:48:11 -0700
Message-ID: <48FBD5AB.6090306@sgi.com>
Date: Mon, 20 Oct 2008 11:49:47 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS_ERROR use - was Re: [PATCH] prevent NULL returns from d_obtain_alias
References: <20081015192839.GA867@lst.de> <E1KqWzC-00087u-TG@pomaz-ex.szeredi.hu> <20081016180947.GA26285@lst.de> <48F7D814.2080705@sgi.com> <20081017171000.GC18582@lst.de>
In-Reply-To: <20081017171000.GC18582@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
>> Fair enough.
>> But XFS_ERROR is used throughout the function.
> 
> Can we leave it the simple way for now?  

Yep.

> I have to revamp that whole
> function anyway as it's extremly buggy in many ways, especially when
> used to open directories (can lead to multiple dentries for a single
> directory - ouch) and then I'll kill the other uses.

Oh ok.

In userspace,
we use it for opening directories on xfsdump via jdm_open in order to
do bulkstat driven dirent dumping.
We also use it in xfsrestore - though I am not convinced we should -
it was initially done for "performance" reasons apparently.

--Tim
