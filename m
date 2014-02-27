Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F9AC29DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 22:41:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6D7C304059
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:41:17 -0800 (PST)
Received: from mail-qa0-f52.google.com (mail-qa0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id duIFZRn0yMZHsVjV
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:41:16 -0800 (PST)
Received: by mail-qa0-f52.google.com with SMTP id j15so3454388qaq.25
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 20:41:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGW2f1G_HjhVXc9jyNEAaX8VUaZov7qaRVuj+KvnbbqvtL0k3g@mail.gmail.com>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
	<1393355679-11160-6-git-send-email-lczerner@redhat.com>
	<CAGW2f1G_HjhVXc9jyNEAaX8VUaZov7qaRVuj+KvnbbqvtL0k3g@mail.gmail.com>
Date: Wed, 26 Feb 2014 23:41:15 -0500
Message-ID: <CAGW2f1FcoMJpFv=7xqPB4+R3-yOqmn89CnAZAJKif_3a3ETcPg@mail.gmail.com>
Subject: Re: [PATCH 5/6 v2] ext4: Introduce FALLOC_FL_ZERO_RANGE flag for
	fallocate
From: jon ernst <jonernst07@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

On Wed, Feb 26, 2014 at 1:00 AM, jon ernst <jonernst07@gmail.com> wrote:
> On Tue, Feb 25, 2014 at 2:14 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
>> functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
>>
>> It can be used to convert a range of file to zeros preferably without
>> issuing data IO. Blocks should be preallocated for the regions that span
>> holes in the file, and the entire range is preferable converted to
>> unwritten extents
>>
>> This can be also used to preallocate blocks past EOF in the same way as
>> with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
>> size to remain the same.
>>
>> Also add appropriate tracepoints.
>>
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> ---
>>  fs/ext4/ext4.h              |   2 +
>>  fs/ext4/extents.c           | 270 +++++++++++++++++++++++++++++++++++++++++---
>>  fs/ext4/inode.c             |  17 ++-
>>  include/trace/events/ext4.h |  64 +++++------

>>  static int
>> +ext4_ext_convert_initialized_extent(handle_t *handle, struct inode *inode,
>> +                       struct ext4_map_blocks *map,
>> +                       struct ext4_ext_path *path, int flags,
>> +                       unsigned int allocated, ext4_fsblk_t newblock)
>> +{
>> +       int ret = 0;
>> +       int err = 0;
>> +
>> +       /*
>> +        * Make sure that the extent is no bigger than we support with
>> +        * uninitialized extent
>> +        */
>> +       if (map->m_len > EXT_UNINIT_MAX_LEN)
>> +               map->m_len = EXT_UNINIT_MAX_LEN / 2;
>
 Pardon my possible dumb question. Why do you use
"EXT_UNINIT_MAX_LEN/ 2;" here instead of "EXT_UNINIT_MAX_LEN"
 I don't see the reason why we can't use EXT_UNINIT_MAX_LEN here.


(resend, Ping on this question, thank you!)

Thanks!
 Jon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
