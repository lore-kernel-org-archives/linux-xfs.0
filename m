Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9B3F37F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 08:26:07 -0500 (CDT)
Message-ID: <525FE56B.4090302@sgi.com>
Date: Thu, 17 Oct 2013 08:26:03 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfsprog: add mkfs.xfs sb v4 support for dirent
	filetype field
References: <20131016223654.505433792@sgi.com>
	<20131016223812.698179281@sgi.com> <20131016235033.GN4446@dastard>
In-Reply-To: <20131016235033.GN4446@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/16/13 18:50, Dave Chinner wrote:
> On Wed, Oct 16, 2013 at 05:36:57PM -0500, Mark Tinguely wrote:
>> Add directory inode type feature to mkfs.xfs and its manual page.
>>
>> In sb v4, "mkfs.xfs -n ftype=1" turns on the feature. The feature is
>> still automatically turned on for sb v5. Reject the "ftype=1" request
>> if used with the "crc=1" setting.
>>
>> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
>> ---

>> +
>>   	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
>> -					attrversion == 2, !projid16bit, 0);
>> +				   attrversion == 2, !projid16bit, 0,
>> +				   (crcs_enabled && dirftype));

Eek that change was made yesterday and should be:
  (!crcs_enabled && dirftype)
so the feature bit is only turned on for v4 sb.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
