Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6OC4qM5126717 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 07:04:53 -0500
Received: from acsinet11.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 261041B59CD7
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 05:05:36 -0700 (PDT)
Received: from acsinet11.oracle.com (acsinet11.oracle.com [141.146.126.233])
	by cuda.sgi.com with ESMTP id rfhSgim7X7rUi3ZI for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 05:05:36 -0700 (PDT)
Date: Fri, 24 Jul 2009 08:05:19 -0400
From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
Message-ID: <20090724120519.GB16192@think>
References: <20090709110342.2386.A69D9226@jp.fujitsu.com>
	<20090709130134.GH18008@think>
	<20090710153349.17EC.A69D9226@jp.fujitsu.com>
	<7149D747-2769-4559-BAF6-AAD2B6C6C941@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7149D747-2769-4559-BAF6-AAD2B6C6C941@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, xfs mailing list <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Olaf Weber <olaf@sgi.com>

On Fri, Jul 24, 2009 at 12:20:32AM -0500, Felix Blyakher wrote:
>
> On Jul 10, 2009, at 2:12 AM, KOSAKI Motohiro wrote:
>> 3. Current wbc->nr_to_write value is not proper?
>>
>> Current writeback_set_ratelimit() doesn't permit that ratelimit_pages 
>> exceed
>> 4M byte. but it is too low restriction for nowadays.
>> (that's my understand. right?)
>>
>> =======================================================
>> void writeback_set_ratelimit(void)
>> {
>>        ratelimit_pages = vm_total_pages / (num_online_cpus() * 32);
>>        if (ratelimit_pages < 16)
>>                ratelimit_pages = 16;
>>        if (ratelimit_pages * PAGE_CACHE_SIZE > 4096 * 1024)
>>                ratelimit_pages = (4096 * 1024) / PAGE_CACHE_SIZE;
>> }
>> =======================================================
>>
>> Yes, 4M bytes are pretty magical constant. We have three choice
>>  A. Remove magical 4M constant simple (a bit danger)
>
> That's will be outside the xfs, and seems like there is no much interest
> from mm people.
>
>>  B. Decide high border from IO capability

It is worth pointing out that Jens Axboe is planning on more feedback
controlled knobs as part of pdflush rework.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
