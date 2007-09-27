Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 19:15:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8R2F6m7004926
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 19:15:07 -0700
Message-ID: <46FB1229.2070706@sandeen.net>
Date: Wed, 26 Sep 2007 21:15:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
References: <20070926082614.D92CE300F406@linuxbuild.melbourne.sgi.com> <46FA4FA5.5040405@sandeen.net> <20070926122854.GA17050@infradead.org>
In-Reply-To: <20070926122854.GA17050@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Sep 26, 2007 at 07:25:09AM -0500, Eric Sandeen wrote:
>> So, what's to be done about xfs_refcache.c... right now it's 2.4-only,
>> but i'm not convinced that there is similar generic nfs functionality in
>> 2.6, anyone know for sure?
> 
> We keep the inodes around through nfsd, yes.  There's a slight problem
> with ->release beeing called to early, but Greg is working on fixing
> that using an open files cache in nfsd.

hch, could you point me to where?  I went looking once...

-Eric
