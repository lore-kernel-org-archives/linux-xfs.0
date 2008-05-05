Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 May 2008 23:33:16 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m456WthT025920
	for <xfs@oss.sgi.com>; Sun, 4 May 2008 23:32:57 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: Don't use d_alloc_anon for open_by_handle
References: <20080501070244.GH108924158@sgi.com>
	<1209693339-4861-1-git-send-email-xaiki@sgi.com>
	<20080502060654.GA23912@infradead.org>
Date: Mon, 05 May 2008 16:33:34 +1000
In-Reply-To: <20080502060654.GA23912@infradead.org> (Christoph Hellwig's
	message of "Fri, 2 May 2008 02:06:54 -0400")
Message-ID: <ncczlr5b6pt.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:
> On Fri, May 02, 2008 at 11:55:37AM +1000, xaiki@sgi.com wrote:
>> One of our DMAPI user found that in some cases inodes weren't getting through
>> xfs_inactive() in any reasonable amount of time. Investigation tracked it down
>> to the use of d_alloc_anon() combined with another thread accessing the same
>> inode via an open().
>> 
>> So we introduce a stripped down version of d_alloc_anon, that won't try to find
>> an existing dentry, nor will hash it.
>
> No, this is even more buggy than using d_alloc_anon.

I must be missing a point here, can you please further explain why is it
buggy ? We are indeed abusing the normal dentry life, but that's what we
want libhandle to be. i.e. We really don't need it connected, we don't
need to know anything about that file, we just want to access it.

> What really needs to be done in the handle code is to do the full
> reconnect logic nfsd would be doing. 

That would be slow, and we don't really need it. What is wrong with
having a temp hanging dentry if it gets thorn appart properly ? The
dentry we're using never makes it to any kind of cache. We don't even
have security concerns as the 2 pieces of code can only be triggered by
root.

> Aka you should be using exportfs_decode_fh and update xfs's
> fh_to_dentry method to accept the file handle type used by the handle
> interface.

Cheers,
-- 
Niv Sardi
