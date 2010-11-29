Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oATEQRFM174328 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 08:26:27 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BE6FAC00C
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 06:28:06 -0800 (PST)
Message-ID: <4CF3B875.3020701@sgi.com>
Date: Mon, 29 Nov 2010 08:28:05 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 4/9] xfsrestore: mmap dirent names for faster lookups
References: <20101119183837.GA9505@sgi.com>
	<20101123134818.GA31206@infradead.org>
In-Reply-To: <20101123134818.GA31206@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/23/2010 07:48 AM, Christoph Hellwig wrote:
> On Fri, Nov 19, 2010 at 12:38:37PM -0600, Bill Kendall wrote:
>> Pathname resolution in xfsrestore is about 4x faster if the file
>> containing dirent names ("namreg") is memory mapped.  If xfsrestore is
>> unable to map the file (e.g., due to virtual memory constraints)
>> fallback to the existing seek-and-read approach.
>>
>> The file is mapped after all directory entries have been written to
>> the "namreg" file. If the caller tries to add additional entries after
>> the file has been mapped, it will be unmapped and restore will resort
>> back to seek-and-read lookups.
>
> This looks much simpler indeed.  Is it intentional that the namreg file
> is never unmapped any more?

There are several modules in xfsrestore which map files. None of them
currently contain a destructor/cleanup function for unmapping the files.
It would be a good change to make though.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
