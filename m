Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 18:54:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8R1sNqo001820
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 18:54:25 -0700
Message-ID: <46FB0D4E.4070704@sandeen.net>
Date: Wed, 26 Sep 2007 20:54:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
References: <20070926082614.D92CE300F406@linuxbuild.melbourne.sgi.com> <46FA4FA5.5040405@sandeen.net> <20070926122854.GA17050@infradead.org> <46FAFE71.9070000@sgi.com>
In-Reply-To: <46FAFE71.9070000@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Donald Douwsma wrote:

> Christoph Hellwig wrote:
>   
>> On Wed, Sep 26, 2007 at 07:25:09AM -0500, Eric Sandeen wrote:
>>     
>>> So, what's to be done about xfs_refcache.c... right now it's 2.4-only,
>>> but i'm not convinced that there is similar generic nfs functionality in
>>> 2.6, anyone know for sure?
>>>       
>> We keep the inodes around through nfsd, yes.  There's a slight problem
>> with ->release beeing called to early, but Greg is working on fixing
>> that using an open files cache in nfsd.
>>     
>
> Cool I'll keep that in mind,
>
> I'm going to remove support/Makefile which is 2.4 specific as well.
> Are there any other 2.4 isms you guys know of?
>
> Don
>
>
>   
It may be worth diffing the linux-2.4/* and linux-2.6/* to see if there are 
any no-ops in 2.6 there only for 2.4... I believe there are.

linux-2.6/mutex.h could probably go away...

hm, there are quite a few 2 or 3 line headers in there, dunno if it makes sense
to have them split out... maybe.

you could lose HAVE_SPLICE and HAVE_FOP_OPEN_EXEC I think

Hmm I wonder if custom do_div is still needed.

-Eric
