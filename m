Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B1637F3F
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:29:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A66C304048
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 06:29:19 -0800 (PST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id 2irutrQEP35xt47r
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 06:29:16 -0800 (PST)
Received: by wmuu63 with SMTP id u63so131862700wmu.0
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 06:29:15 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <CAD-J=zZh1dtJsfrW_Gwxjg+qvkZMu7ED-QOXrMMO6B-G0HY2-A@mail.gmail.com>
	<20151130141000.GC24765@bfoster.bfoster>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565C5D39.8080300@scylladb.com>
Date: Mon, 30 Nov 2015 16:29:13 +0200
MIME-Version: 1.0
In-Reply-To: <20151130141000.GC24765@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>
Cc: xfs@oss.sgi.com



On 11/30/2015 04:10 PM, Brian Foster wrote:
>> 2) xfs_buf_lock -> down
>> This is one I truly don't understand. What can be causing contention
>> in this lock? We never have two different cores writing to the same
>> buffer, nor should we have the same core doingCAP_FOWNER so.
>>
> This is not one single lock. An XFS buffer is the data structure used to
> modify/log/read-write metadata on-disk and each buffer has its own lock
> to prevent corruption. Buffer lock contention is possible because the
> filesystem has bits of "global" metadata that has to be updated via
> buffers.
>
> For example, usually one has multiple allocation groups to maximize
> parallelism, but we still have per-ag metadata that has to be tracked
> globally with respect to each AG (e.g., free space trees, inode
> allocation trees, etc.). Any operation that affects this metadata (e.g.,
> block/inode allocation) has to lock the agi/agf buffers along with any
> buffers associated with the modified btree leaf/node blocks, etc.
>
> One example in your attached perf traces has several threads looking to
> acquire the AGF, which is a per-AG data structure for tracking free
> space in the AG. One thread looks like the inode eviction case noted
> above (freeing blocks), another looks like a file truncate (also freeing
> blocks), and yet another is a block allocation due to a direct I/O
> write. Were any of these operations directed to an inode in a separate
> AG, they would be able to proceed in parallel (but I believe they would
> still hit the same codepaths as far as perf can tell).

I guess we can mitigate (but not eliminate) this by creating more 
allocation groups.  What is the default value for agsize?  Are there any 
downsides to decreasing it, besides consuming more memory?

Are those locks held around I/O, or just CPU operations, or a mix?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
