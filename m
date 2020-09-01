Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C2FC433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 06:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15B9D208DB
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 06:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgIAGGJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 02:06:09 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:37502 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725987AbgIAGGJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 02:06:09 -0400
X-IronPort-AV: E=Sophos;i="5.76,378,1592841600"; 
   d="scan'208";a="98762408"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Sep 2020 14:05:58 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 1C50248990DD;
        Tue,  1 Sep 2020 14:05:56 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 1 Sep 2020 14:05:54 +0800
Message-ID: <5F4DE4C1.6010403@cn.fujitsu.com>
Date:   Tue, 1 Sep 2020 14:05:53 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <ira.weiny@intel.com>
Subject: Re: [PATCH] xfs: Add check for unsupported xflags
References: <20200831133745.33276-1-yangx.jy@cn.fujitsu.com> <20200831172250.GT6107@magnolia>
In-Reply-To: <20200831172250.GT6107@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: 1C50248990DD.A9D55
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/9/1 1:22, Darrick J. Wong wrote:
> On Mon, Aug 31, 2020 at 09:37:45PM +0800, Xiao Yang wrote:
>> Current ioctl(FSSETXATTR) ignores unsupported xflags silently
>> so it it not clear for user to know unsupported xflags.
Hi Darrick,

Sorry for a typo(s/it it/it is/).
>> For example, use ioctl(FSSETXATTR) to set dax flag on kernel
>> v4.4 which doesn't support dax flag:
>> --------------------------------
>> # xfs_io -f -c "chattr +x" testfile;echo $?
>> 0
>> # xfs_io -c "lsattr" testfile
>> ----------------X testfile
>> --------------------------------
>>
>> Add check to report unsupported info as ioctl(SETXFLAGS) does.
>>
>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>> ---
>>   fs/xfs/xfs_ioctl.c      | 4 ++++
>>   include/uapi/linux/fs.h | 8 ++++++++
>>   2 files changed, 12 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 6f22a66777cd..cfe7f20c94fe 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1439,6 +1439,10 @@ xfs_ioctl_setattr(
>>
>>   	trace_xfs_ioctl_setattr(ip);
>>
>> +	/* Check if fsx_xflags have unsupported xflags */
>> +	if (fa->fsx_xflags&  ~FS_XFLAG_ALL)
>> +                return -EOPNOTSUPP;
> Shouldn't this be in vfs_ioc_fssetxattr_check, since we're checking
> against all the vfs defined XFLAGS?
Right, different filesystems support different XFLAGS so I think it is 
hard to put this
check into vfs_ioc_fssetxattr_check().  For example,
1) ext4 defines EXT4_SUPPORTED_FS_XFLAGS and do the check before
vfs_ioc_fssetxattr_check():
-------------------------------------------------------------------------------
ext4/ioctl.c:
#define EXT4_SUPPORTED_FS_XFLAGS (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | \
                                   FS_XFLAG_APPEND | FS_XFLAG_NODUMP | \
                                   FS_XFLAG_NOATIME | 
FS_XFLAG_PROJINHERIT | \
                                   FS_XFLAG_DAX)
...
                 if (fa.fsx_xflags & ~EXT4_SUPPORTED_FS_XFLAGS)
                         return -EOPNOTSUPP;
...
-------------------------------------------------------------------------------
2) btrfs adds check_xflags() and calls it before vfs_ioc_fssetxattr_check():
-------------------------------------------------------------------------------
btrfs/ioctl.c:
static int check_xflags(unsigned int flags)
{
         if (flags & ~(FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE | 
FS_XFLAG_NOATIME |
                       FS_XFLAG_NODUMP | FS_XFLAG_SYNC))
                 return -EOPNOTSUPP;
         return 0;
}
...
         ret = check_xflags(fa.fsx_xflags);
         if (ret)
                 return ret;
...
-------------------------------------------------------------------------------

Perhaps, I should rename FS_XFLAG_ALL to XFS_SUPPORTED_FS_XFLAGS and move
it into libxfs/xfs_fs.h.

Best Regards,
Xiao Yang
> --D
>
>> +
>>   	code = xfs_ioctl_setattr_check_projid(ip, fa);
>>   	if (code)
>>   		return code;
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index f44eb0a04afd..31b6856f6877 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -142,6 +142,14 @@ struct fsxattr {
>>   #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>>   #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>>
>> +#define FS_XFLAG_ALL \
>> +	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
>> +	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
>> +	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
>> +	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
>> +	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
>> +	 FS_XFLAG_HASATTR)
>> +
>>   /* the read-only stuff doesn't really belong here, but any other place is
>>      probably as bad and I don't want to create yet another include file. */
>>
>> -- 
>> 2.25.1
>>
>>
>>
>
> .
>



