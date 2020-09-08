Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA85C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 07:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD32521D46
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 07:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgIHHty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 03:49:54 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:25220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729319AbgIHHtt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 03:49:49 -0400
X-IronPort-AV: E=Sophos;i="5.76,404,1592841600"; 
   d="scan'208";a="98998490"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 Sep 2020 15:49:45 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id CFFD448990D9;
        Tue,  8 Sep 2020 15:49:42 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 8 Sep 2020 15:49:41 +0800
Message-ID: <5F573794.2040700@cn.fujitsu.com>
Date:   Tue, 8 Sep 2020 15:49:40 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Dave Chinner <david@fromorbit.com>, <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <ira.weiny@intel.com>
Subject: Re: [PATCH v3] xfs: Add check for unsupported xflags
References: <20200903035713.60962-1-yangx.jy@cn.fujitsu.com> <20200903074632.GD12131@dread.disaster.area> <5F5194F1.8010607@cn.fujitsu.com> <20200906230105.GO12131@dread.disaster.area>
In-Reply-To: <20200906230105.GO12131@dread.disaster.area>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: CFFD448990D9.AE2BD
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/9/7 7:01, Dave Chinner wrote:
> On Fri, Sep 04, 2020 at 09:14:25AM +0800, Xiao Yang wrote:
>> On 2020/9/3 15:46, Dave Chinner wrote:
>>> On Thu, Sep 03, 2020 at 11:57:13AM +0800, Xiao Yang wrote:
>>>> Current ioctl(FSSETXATTR) ignores unsupported xflags silently
>>>> so it is not clear for user to know unsupported xflags.
>>>> For example, use ioctl(FSSETXATTR) to set dax flag on kernel
>>>> v4.4 which doesn't support dax flag:
>>>> --------------------------------
>>>> # xfs_io -f -c "chattr +x" testfile;echo $?
>>>> 0
>>>> # xfs_io -c "lsattr" testfile
>>>> ----------------X testfile
>>>> --------------------------------
>>>>
>>>> Add check to return -EOPNOTSUPP as ext4/f2fs/btrfs does.
>>>>
>>>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>>>> Reviewed-by: Darrick J. Wong<darrick.wong@oracle.com>
>>>> ---
>>>>    fs/xfs/xfs_ioctl.c | 12 ++++++++++++
>>>>    1 file changed, 12 insertions(+)
>>>>
>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>>> index 6f22a66777cd..59f9a86f29f7 100644
>>>> --- a/fs/xfs/xfs_ioctl.c
>>>> +++ b/fs/xfs/xfs_ioctl.c
>>>> @@ -1425,6 +1425,14 @@ xfs_ioctl_setattr_check_projid(
>>>>    	return 0;
>>>>    }
>>>>
>>>> +#define XFS_SUPPORTED_FS_XFLAGS \
>>>> +	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
>>>> +	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
>>>> +	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
>>>> +	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
>>>> +	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
>>>> +	 FS_XFLAG_HASATTR)
>>>> +
>>>>    STATIC int
>>>>    xfs_ioctl_setattr(
>>>>    	xfs_inode_t		*ip,
>>>> @@ -1439,6 +1447,10 @@ xfs_ioctl_setattr(
>>>>
>>>>    	trace_xfs_ioctl_setattr(ip);
>>>>
>>>> +	/* Check if fsx_xflags has unsupported xflags */
>>>> +	if (fa->fsx_xflags&   ~XFS_SUPPORTED_FS_XFLAGS)
>>>> +                return -EOPNOTSUPP;
>>> I don't think we can do this as it may break existing applications
>>> that have been working on XFS for many, many years that don't
>>> correctly initialise fsx_xflags....
>> Hi Dave,
>>
>> It seems that the only way is to keep the current behavior. :-(
> Yes, unfortunately that is the case, but it does follow precedence
> set by other syscalls with unchecked flags such as open() - they
> mask off unknown flags so they don't do anything, but they do not
> return an error if any unknown flag is set.
>
>> By the way, _require_xfs_io_command "chattr" in xfstests cannot check XFS's
>> unsupported xflags directly because of the behavior, so we may need to check
>> them by extra xfs_io -c "lsattr".
> *nod*
Hi Darrick, Dave

I had another confusion when trying to add extra xfs_io -c "lsattr" in 
xfstests:
--------------------------------------------------
# xfs_io -f -c "chattr +tPn" file
# xfs_io -f -c "lsattr" file
----------------X file
# xfs_io -f -c "chattr +E" file
xfs_io: cannot set flags on file: Invalid argument
--------------------------------------------------
These four flags are invalid for a regular file , but kernel maskes off 
three flags and returns EINVAL for 'E' flag.
kernel can mask off all four flags for a regular file, so is it 
necessary for 'E' flag to return EINVAL?
fs/xfs/xfs_ioctl.c:
-------------------------------------------------
1160         if (S_ISDIR(VFS_I(ip)->i_mode)) {
1161                 if (xflags & FS_XFLAG_RTINHERIT)
1162                         di_flags |= XFS_DIFLAG_RTINHERIT;
1163                 if (xflags & FS_XFLAG_NOSYMLINKS)
1164                         di_flags |= XFS_DIFLAG_NOSYMLINKS;
1165                 if (xflags & FS_XFLAG_EXTSZINHERIT)
1166                         di_flags |= XFS_DIFLAG_EXTSZINHERIT;
1167                 if (xflags & FS_XFLAG_PROJINHERIT)
1168                         di_flags |= XFS_DIFLAG_PROJINHERIT;
-------------------------------------------------
fs/inode.c:
-------------------------------------------------
2356         if ((fa->fsx_xflags & FS_XFLAG_EXTSZINHERIT) &&
2357                         !S_ISDIR(inode->i_mode))
2358                 return -EINVAL;
-------------------------------------------------
I think the behavior of chattr command seems inconsistent/messy.

Best Regards,
Xiao Yang
> Cheers,
>
> Dave.



