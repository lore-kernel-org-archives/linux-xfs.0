Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0562IRf188644 for <xfs@oss.sgi.com>; Thu, 5 Jan 2012 00:02:18 -0600
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id pKTsEfPruRdjAsMv for
	<xfs@oss.sgi.com>; Wed, 04 Jan 2012 22:02:16 -0800 (PST)
Message-ID: <4F053CDC.6030007@oracle.com>
Date: Thu, 05 Jan 2012 14:02:04 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V4
References: <4EFB1B23.7050008@oracle.com> <20120104205255.GA1012@infradead.org>
In-Reply-To: <20120104205255.GA1012@infradead.org>
Reply-To: jeff.liu@oracle.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Christoph,

On 01/05/2012 04:52 AM, Christoph Hellwig wrote:

> Hi Jeff,
> 
> thanks a lot for the patch, it looks good to except for some more
> nitpicks around the unwritten extent probing.
> 
> The other issue is the patch description format - the version changelog
> should go below the  --- line.

ok. :-P.

> 
>> +	do {
>> +		unsigned int	i;
>> +		unsigned	nr_pages;
>> +		int		want = min_t(pgoff_t, end - index,
>> +					     (pgoff_t)PAGEVEC_SIZE - 1) + 1;
>> +		nr_pages = pagevec_lookup_tag(&pvec, inode->i_mapping,
>> +					      &index, tag, want);
>> +		if (nr_pages == 0) {
>> +			/*
>> +			 * Try to lookup pages in writeback mode from the
>> +			 * beginning if no more dirty page can be probed.
>> +			 */
>> +probe_done:
>> +			if (tag == PAGECACHE_TAG_DIRTY) {
>> +				tag = PAGECACHE_TAG_WRITEBACK;
>> +				goto again;
>> +			}
>> +			break;
> 
> The code flow here looks very confusing.  Why not pass the tag as an
> argument to the function, then calling it twice and use the minimum?

> (that probably also wants a helper instead of duplication)

That's just because I was inclined to implement a helper rather than duplicating the probe function twice.
I have gone through the page lookup stuff, looks we can introduce a helper to wrap something like
radix_tree_gang_lookup_tag_slot()(maybe name it as radix_tree_gang_lookup_tags_slot()),
it can accept a tags array argument(dirty/unwritten), return those intertwined pages in ascending order based on offset.

Even that, I was still wondering if we can tweak the pages probing function a bit more generic to be a helper too.
Per Dave's comments in our another discussion, the reason why we can not do that is due to the different lock mechanism among FS(ext4, btrfs),
but looks those lock stuff are safe, i.e,
To probing pages, FS using mutex lock, will be something like:
mutex_lock(&inode->i_mutex);
---seek_data_or_hole()
-------probe_unwritten_buffer()
mutex_unlock(&inode->i_mutex);

For XFS, still using the shared lock.

For now, how about just calling it twice and use the minimum, and make the code tested more stable, then try to introduce a helper?

> 
> 
>> +				 * dirty data in the page cache it can be
>> +				 * identified by having BH_Unwritten set in
>> +				 * each buffer. Also, the buffer head state
>> +				 * might be in BH_Uptodate if the buffer
>> +				 * writeback procedure was fired, we need to
>> +				 * examine it too.
>> +				 */
>> +				if (buffer_unwritten(bh) ||
>> +				    buffer_uptodate(bh)) {
>> +					found = true;
>> +					if (get_offset)
>> +						*offset = XFS_FSB_TO_B(
>> +								mp, last);
> 
> Currently seek hole doesn't set get_offset we skip the whole extent.
> This seems a bit inconsistent - shouldn't we also return that offset
> for the hole case? if the dirty data only starts past the start block
> of the map the first blocks of it still are a hole.

Indeed, we can get a hole offset a bit more accurate than before in this way.


Thanks,
-Jeff

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
