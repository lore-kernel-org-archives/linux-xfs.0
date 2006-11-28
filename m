Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Nov 2006 15:59:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kARNx2aG022699
	for <linux-xfs@oss.sgi.com>; Mon, 27 Nov 2006 15:59:04 -0800
Message-ID: <456B7C1A.90209@sgi.com>
Date: Tue, 28 Nov 2006 11:00:26 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: TAKE 956783 - xfs_dm_getall_dmattr() doesn't check if the user
 buffer is at valid address
References: <45629AD8.8000800@sgi.com> <20061127055859.GC1374@infradead.org>
In-Reply-To: <20061127055859.GC1374@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: sgi.bugs.xfs@engr.sgi.com, linux-xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Nov 21, 2006 at 05:21:12PM +1100, Vlad Apostolov wrote:
>   
>> No EFAULT error when dm_getall_dmattr() called with an invalid user 
>> buffer address.
>>     
>
> This fix is broken.  access_ok is not enough to verify the buffer,
> it just does very few static check (basically the address space limit)
>
> You need to use copy_{from,to}_user to access user pointers.  I had
> an untested patch to fix this at my good old SGI time, but Dean wanted
> to review and test it a lot more.  I'll try to dig up that patch if you care.
>   
The fix is actually fine as it gives an early indication (even not complete)
that the user pointer is bad. There is another problem you are pointing at and 
it is the userspace pointer dereference later on without using copy_to_user(). 
If you have any patch fixing this problem it would be great.

Thanks and regards,
Vlad
