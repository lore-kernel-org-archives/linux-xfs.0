Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 17:53:23 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBC1rGYd025876
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 17:53:18 -0800
Received: from puma.mxtelecom.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E523710FB12D
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 17:53:27 -0800 (PST)
Received: from puma.mxtelecom.com (mx1.mxtelecom.com [87.86.212.101]) by cuda.sgi.com with ESMTP id bzeFzLUCTkpiLmXU for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 17:53:27 -0800 (PST)
Date: Wed, 12 Dec 2007 01:52:48 +0000 (GMT)
From: Matthew Hodgson <matthew@mxtelecom.com>
Subject: Re: Zero-copy Block IO with XFS
In-Reply-To: <cc7060690712110839j46e0928bv4dae1d33bfe5d0dd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712120113270.5069@puma.mxtelecom.com>
References: <475E76AB.705@mxtelecom.com> <cc7060690712110839j46e0928bv4dae1d33bfe5d0dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Bhagi rathi <jahnu77@gmail.com>

On Tue, 11 Dec 2007, Bhagi rathi wrote:

> On Dec 11, 2007 5:08 PM, Matthew Hodgson <matthew@mxtelecom.com> wrote:
>
>> Hi all,
>>
>> I'm experimenting with using XFS with a network block device (DST), and
>> have come up against the problem that when writing data to the network,
>> it uses kernel_sendpage to hand the page presented at the BIO layer to
>> the network stack.  It then completes the block IO request.
>
> Actually, you can pass a sendpage read actor which takes a reference on 
> the page which ensures valid page exists with you.

Hmm, i'm a little confused as to how one would do that - I can see that 
sendfile can be passed a read actor for use in the underlying read, but I 
can't see anywhere where sendpage can be used with a read actor.  I see 
that nfsd/vfs.c:nfsd_read_actor() adjusts the page refcounting to stop 
them being freed before they are sent - but that only seems to be usable 
when sending with sendfile.

> As long as you have 
> ref on the page and no truncate to the same file, you can safely access 
> the file.  Once NIC sends the data over wire, you can do put_page. This 
> should work.

I'm not sure that it will help, though.  The problem seems to be that XFS 
itself overwrites the page with new data (rather than the page being freed 
and reused) whilst the page is waiting to be sent in the TCP stack.  Is 
there any way to prevent XFS from doing this - or have I misunderstood the 
problem?

Along similar lines, is there any way to stop XFS from passing slab pages 
to the block IO layer?  Attempts to pass slab pages over to the TCP stack 
fail too.

thanks,

Matthew.
