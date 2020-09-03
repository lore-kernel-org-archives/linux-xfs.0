Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7ECCC433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 03:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2EBD20716
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 03:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgICDvh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:51:37 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59825 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728266AbgICDvh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 23:51:37 -0400
X-IronPort-AV: E=Sophos;i="5.76,384,1592841600"; 
   d="scan'208";a="98860128"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Sep 2020 11:51:33 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id C893C48990DB;
        Thu,  3 Sep 2020 11:51:27 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 3 Sep 2020 11:51:26 +0800
Message-ID: <5F50683E.7000209@cn.fujitsu.com>
Date:   Thu, 3 Sep 2020 11:51:26 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <ira.weiny@intel.com>
Subject: Re: [PATCH v2] xfs: Add check for unsupported xflags
References: <20200902040601.10293-1-yangx.jy@cn.fujitsu.com> <20200902175851.GY6096@magnolia>
In-Reply-To: <20200902175851.GY6096@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: C893C48990DB.A9ED6
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/9/3 1:58, Darrick J. Wong wrote:
> On Wed, Sep 02, 2020 at 12:06:01PM +0800, Xiao Yang wrote:
>> Current ioctl(FSSETXATTR) ignores unsupported xflags silently
>> so it is not clear for user to know unsupported xflags.
>> For example, use ioctl(FSSETXATTR) to set dax flag on kernel
>> v4.4 which doesn't support dax flag:
>> --------------------------------
>> 0
>> ----------------X testfile
>> --------------------------------
Hi Darrick,

Oops, the example shows incomplete info and see the correct one:
--------------------------------------------------------
# xfs_io -f -c "chattr +x" testfile;echo $?
0
# xfs_io -c "lsattr" testfile
----------------X testfile
--------------------------------------------------------

I will send the v3 patch shortly.

Best Regards,
Xiao Yang
>> Add check to return -EOPNOTSUPP as ext4/f2fs/btrfs does.
>>
>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
> Looks good to me,
> Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
>
> --D
>
>> ---
>>   fs/xfs/xfs_ioctl.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 6f22a66777cd..e188e81961bd 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1425,6 +1425,14 @@ xfs_ioctl_setattr_check_projid(
>>   	return 0;
>>   }
>>
>> +#define XFS_SUPPORTED_FS_XFLAGS \
>> +	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
>> +	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
>> +	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
>> +	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
>> +	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
>> +	 FS_XFLAG_HASATTR)
>> +
>>   STATIC int
>>   xfs_ioctl_setattr(
>>   	xfs_inode_t		*ip,
>> @@ -1439,6 +1447,10 @@ xfs_ioctl_setattr(
>>
>>   	trace_xfs_ioctl_setattr(ip);
>>
>> +	/* Check if fsx_xflags has unsupported xflags */
>> +	if (fa->fsx_xflags&  ~XFS_SUPPORTED_FS_XFLAGS)
>> +                return -EOPNOTSUPP;
>> +
>>   	code = xfs_ioctl_setattr_check_projid(ip, fa);
>>   	if (code)
>>   		return code;
>> -- 
>> 2.25.1
>>
>>
>>
>
> .
>



