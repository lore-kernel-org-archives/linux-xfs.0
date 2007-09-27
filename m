Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 17:51:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8R0pL2G024736
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 17:51:25 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA21853; Thu, 27 Sep 2007 10:50:57 +1000
Message-ID: <46FAFE71.9070000@sgi.com>
Date: Thu, 27 Sep 2007 10:50:57 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
References: <20070926082614.D92CE300F406@linuxbuild.melbourne.sgi.com> <46FA4FA5.5040405@sandeen.net> <20070926122854.GA17050@infradead.org>
In-Reply-To: <20070926122854.GA17050@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Sep 26, 2007 at 07:25:09AM -0500, Eric Sandeen wrote:
>> So, what's to be done about xfs_refcache.c... right now it's 2.4-only,
>> but i'm not convinced that there is similar generic nfs functionality in
>> 2.6, anyone know for sure?
> 
> We keep the inodes around through nfsd, yes.  There's a slight problem
> with ->release beeing called to early, but Greg is working on fixing
> that using an open files cache in nfsd.

Cool I'll keep that in mind,

I'm going to remove support/Makefile which is 2.4 specific as well.
Are there any other 2.4 isms you guys know of?

Don
