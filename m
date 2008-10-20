Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 16:14:27 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KNEORh017510
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 16:14:25 -0700
Message-ID: <48FD1132.6080503@sgi.com>
Date: Tue, 21 Oct 2008 10:16:02 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS_ERROR use - was Re: [PATCH] prevent NULL returns from	d_obtain_alias
References: <20081015192839.GA867@lst.de> <E1KqWzC-00087u-TG@pomaz-ex.szeredi.hu> <20081016180947.GA26285@lst.de> <48F7D814.2080705@sgi.com> <20081017171000.GC18582@lst.de> <48FBD5AB.6090306@sgi.com> <20081020092346.GA14455@infradead.org>
In-Reply-To: <20081020092346.GA14455@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Oct 20, 2008 at 11:49:47AM +1100, Timothy Shimmin wrote:
>>> I have to revamp that whole
>>> function anyway as it's extremly buggy in many ways, especially when
>>> used to open directories (can lead to multiple dentries for a single
>>> directory - ouch) and then I'll kill the other uses.
>> Oh ok.
>>
>> In userspace,
>> we use it for opening directories on xfsdump via jdm_open in order to
>> do bulkstat driven dirent dumping.
>> We also use it in xfsrestore - though I am not convinced we should -
>> it was initially done for "performance" reasons apparently.
> 
> I think the use of the API is fine, the problem is that the current
> implemention is buggy.
Yeah, I have no problem for xfsdump as it is driven by bulkstat
but for xfsrestore it seems unnecessary.
In fact, it can restore to other filesystems so it must only be using
this in certain ways on restore.
Having a look, yeah it is predicated by:
  if ( tranp->t_dstdirisxfspr )
and then just uses the fd for XFS_IOC_FSSETDM, XFS_IOC_FSSETXATTR
for those xfs-specific things and in the same function it uses
the path for non-xfs-specific: utime, chown, chmod
So it seems unnecessary to me in restore.

--Tim
