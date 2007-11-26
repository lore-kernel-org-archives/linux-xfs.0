Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 16:26:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAQ0QnRd018748
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2007 16:26:51 -0800
Message-ID: <474A1289.2080500@sgi.com>
Date: Mon, 26 Nov 2007 11:25:45 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix up xfs_buf_associate_memory()
References: <47465712.1050000@sgi.com> <20071123134302.GA4256@infradead.org>
In-Reply-To: <20071123134302.GA4256@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Fri, Nov 23, 2007 at 03:29:06PM +1100, Lachlan McIlroy wrote:
>> Fixed a few bugs in xfs_buf_associate_memory() including:
>>
>> - calculation of 'page_count' was incorrect as it did not
>>   consider the offset of 'mem' into the first page.  The
>>   logic to bump 'page_count' didn't work if 'len' was <=
>>   PAGE_CACHE_SIZE (ie offset = 3k, len = 2k).
>> - setting b_buffer_length to 'len' is incorrect if
>>   'offset' is > 0.  Set it to the total length of the
>>   buffer.
>> - I suspect that passing a non-aligned address into
>>   mem_to_page() for the first page may have been causing
>>   issues - don't know but just tidy up that code anyway.
>>
>> These fixes prevent an data corruption issue that can
>> occur during log replay.
> 
> Last time I tried to clean up this gem everything went bezerk, so be
> aware :)
> 
> 
> --- fs/xfs/linux-2.6/xfs_buf.c_1.247	2007-11-23 12:03:16.000000000 +1100
> +++ fs/xfs/linux-2.6/xfs_buf.c	2007-11-23 12:02:32.000000000 +1100
> @@ -726,14 +726,14 @@ xfs_buf_associate_memory(
>  	int			rval;
>  	int			i = 0;
>  	size_t			ptr;
> +	size_t			buflen;
>  	off_t			offset;
>  	int			page_count;
>  
> +	ptr = (size_t) mem & PAGE_CACHE_MASK;
> +	offset = (off_t) mem - (off_t) ptr;
> 
> Casting pointers to size_t or off_t makes little sense, these should be
> unsigned long.  And using a variable name of ptr is quite odd :)

I just left those as they were before the change.  I'll tidy them too.

> 
> +	while (i < bp->b_page_count) {
> +		bp->b_pages[i++] = mem_to_page((void *)ptr);
>  		ptr += PAGE_CACHE_SIZE;
>  	}
> 
> This could be much cleaner written as:
> 
> 	for (i = 0; i < bp->b_page_count; i++) {
> 		bp->b_pages[i] = mem_to_page((void *)ptr);
> 		ptr += PAGE_CACHE_SIZE;
> 	}
> 

Fine with me.

Thanks.
