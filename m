Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53754 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdHAQ01 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Aug 2017 12:26:27 -0400
Subject: Re: [PATCH] xfs_metadump: properly handle obfuscation of all remote
 attribute blocks
References: <7862201b-e387-8037-ca99-b6ab3212f4a7@redhat.com>
 <20170728125201.GA12444@bfoster.bfoster>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8125572f-a7fa-ecb3-4b50-7684a8ae2372@sandeen.net>
Date: Tue, 1 Aug 2017 11:26:25 -0500
MIME-Version: 1.0
In-Reply-To: <20170728125201.GA12444@bfoster.bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 7/28/17 7:52 AM, Brian Foster wrote:
> On Wed, Jul 26, 2017 at 03:35:37PM -0500, Eric Sandeen wrote:
>> add_remote_vals assumes that it can subtract blocksize
>> from each block that it processes, but with CRCs, there
>> is a header on each block, so the assumption that each
>> block consumes $BLOCKSIZE of the value length is incorrect.
>>
>> This causes us to stop adding remote blocks too soon, and
>> the missed blocks do not get obfuscated.
>>
>> Fix this by accounting for the header size as appropriate,
>> depending on whether or not we have a CRC filesystem.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 96641e0..c8abfeb 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -1602,14 +1602,20 @@ static struct attr_data_s {
>>  
>>  static inline void
>>  add_remote_vals(
>> +	struct xfs_mount	*mp,
>>  	xfs_dablk_t 		blockidx,
>>  	int			length)
>>  {
>> +	int			hdrsize = 0;
>> +
>> +	if (xfs_sb_version_hascrc(&mp->m_sb))
>> +		hdrsize = sizeof(struct xfs_attr3_rmt_hdr);
>> +
>>  	while (length > 0 && attr_data.remote_val_count < MAX_REMOTE_VALS) {
>>  		attr_data.remote_vals[attr_data.remote_val_count] = blockidx;
>>  		attr_data.remote_val_count++;
>>  		blockidx++;
>> -		length -= mp->m_sb.sb_blocksize;
>> +		length -= (mp->m_sb.sb_blocksize - hdrsize);
> 
> XFS_ATTR3_RMT_BUF_SPACE()?

Oh, yeah, why didn't I use that!

Thanks,
-Eric

> Brian
