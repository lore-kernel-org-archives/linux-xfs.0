Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qALEJ12e052322 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 08:19:01 -0600
Message-ID: <50ACD545.8030102@sgi.com>
Date: Wed, 21 Nov 2012 07:21:09 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: fix the buffer log format for contiguous buffers
References: <20121120224120.224166649@sgi.com>
	<20121120224146.479983109@sgi.com>
	<20121121095422.GB23339@infradead.org>
In-Reply-To: <20121121095422.GB23339@infradead.org>
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

On 11/21/12 03:54, Christoph Hellwig wrote:
> Do we have proper test coverage for the xfs_buf_item_format_segment
> changes?  Given that they change what gets written into the log I'd
> prefer them separate from a big cleanup patch, and including test
> coverage verifying everything works fine when hitting these corner
> cases.
>
>>   		chunk_num = byte>>  XFS_BLF_SHIFT;
>>   		word_num = chunk_num>>  BIT_TO_WORD_SHIFT;
>>   		bit_num = chunk_num&  (NBWORD - 1);
>> -		wordp =&(bip->bli_format.blf_data_map[word_num]);
>> +		wordp =&(bip->bli_formats[0].blf_data_map[word_num]);
>
> This change doesn't seem to be mentioned in the changelog?
>
>> @@ -644,8 +652,14 @@ xfs_buf_item_unlock(
>>   	 * If the buf item isn't tracking any data, free it, otherwise drop the
>>   	 * reference we hold to it.
>>   	 */
>> -	if (xfs_bitmap_empty(bip->bli_format.blf_data_map,
>> -			     bip->bli_format.blf_map_size))
>> +	empty = 1;
>> +	for (i = 0; i<  bip->bli_format_count; i++)
>> +		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
>> +			     bip->bli_formats[i].blf_map_size)) {
>> +			empty = 0;
>> +			break;
>> +		}
>> +	if (empty)
>>   		xfs_buf_item_relse(bp);
>
> This looks like a bug fix, not just a cleanup.  Again I'd prefer this to
> be a patch on its own, with a good description.
>

The bli_format -> bli_formats changes are bug fixes - the description 
should say this is a bug fix not just a cleanup.

Eric's test 291 created a buffer with 4 mapped segments. It found most 
of the issues in the buffer map and in the buffer log format. Dave 
pointed out the xfs_bitmap_empty() error.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
