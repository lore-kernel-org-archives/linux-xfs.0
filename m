Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 18:25:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T1Pg9X005327
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 18:25:42 -0700
Message-ID: <488E7334.90205@sgi.com>
Date: Tue, 29 Jul 2008 11:32:36 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 981498 - kill bhv_vnode_t
References: <20080728062625.BB57158C4C3F@chook.melbourne.sgi.com> <20080728121534.GA12715@infradead.org>
In-Reply-To: <20080728121534.GA12715@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Mon, Jul 28, 2008 at 04:26:25PM +1000, Lachlan McIlroy wrote:
>> kill bhv_vnode_t
>>
>> All remaining bhv_vnode_t instance are in code that's more or less Linux
>> specific.  (Well, for xfs_acl.c that could be argued, but that code is
>> on the removal list, too).  So just do an s/bhv_vnode_t/struct inode/
>> over the whole tree.  We can clean up variable naming and some useless
>> helpers later.
> 
> Thanks,  but I wonder how this could even apply without the
> intialize_vnode cleanup..

It applied fine.  Didn't build though - I had to change a couple more
bhv_vnode_t's.
