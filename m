Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBC1C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 05:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E2FB20786
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 05:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIBFLM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 01:11:12 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26654 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726177AbgIBFLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 01:11:12 -0400
X-IronPort-AV: E=Sophos;i="5.76,381,1592841600"; 
   d="scan'208";a="98821876"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Sep 2020 13:11:07 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 2246E48990C9;
        Wed,  2 Sep 2020 13:11:02 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 2 Sep 2020 13:11:00 +0800
Message-ID: <5F4F2964.8050809@cn.fujitsu.com>
Date:   Wed, 2 Sep 2020 13:11:00 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <linux-xfs@vger.kernel.org>, <ira.weiny@intel.com>
Subject: Re: [PATCH] xfs: Add check for unsupported xflags
References: <20200831133745.33276-1-yangx.jy@cn.fujitsu.com> <20200831172250.GT6107@magnolia> <5F4DE4C1.6010403@cn.fujitsu.com> <20200901163551.GW6107@magnolia> <5F4F0647.5060305@cn.fujitsu.com> <20200902030946.GL6096@magnolia> <5F4F12E2.3080200@cn.fujitsu.com> <20200902041039.GM6096@magnolia>
In-Reply-To: <20200902041039.GM6096@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: 2246E48990C9.AAC96
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

于 2020/9/2 12:10, Darrick J. Wong 写道:
> On Wed, Sep 02, 2020 at 11:34:58AM +0800, Xiao Yang wrote:
>> 于 2020/9/2 11:09, Darrick J. Wong 写道:
>>> On Wed, Sep 02, 2020 at 10:41:11AM +0800, Xiao Yang wrote:
>>>> On 2020/9/2 0:35, Darrick J. Wong wrote:
>>>>> On Tue, Sep 01, 2020 at 02:05:53PM +0800, Xiao Yang wrote:
>>>>>> On 2020/9/1 1:22, Darrick J. Wong wrote:
>>>>>>> On Mon, Aug 31, 2020 at 09:37:45PM +0800, Xiao Yang wrote:
>>>>>>>> Current ioctl(FSSETXATTR) ignores unsupported xflags silently
>>>>>>>> so it it not clear for user to know unsupported xflags.
>>>>>> Hi Darrick,
>>>>>>
>>>>>> Sorry for a typo(s/it it/it is/).
>>>>>>>> For example, use ioctl(FSSETXATTR) to set dax flag on kernel
>>>>>>>> v4.4 which doesn't support dax flag:
>>>>>>>> --------------------------------
>>>>>>>> # xfs_io -f -c "chattr +x" testfile;echo $?
>>>>>>>> 0
>>>>>>>> # xfs_io -c "lsattr" testfile
>>>>>>>> ----------------X testfile
>>>>>>>> --------------------------------
>>>>>>>>
>>>>>>>> Add check to report unsupported info as ioctl(SETXFLAGS) does.
>>>>>>>>
>>>>>>>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>>>>>>>> ---
>>>>>>>>      fs/xfs/xfs_ioctl.c      | 4 ++++
>>>>>>>>      include/uapi/linux/fs.h | 8 ++++++++
>>>>>>>>      2 files changed, 12 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>>>>>>> index 6f22a66777cd..cfe7f20c94fe 100644
>>>>>>>> --- a/fs/xfs/xfs_ioctl.c
>>>>>>>> +++ b/fs/xfs/xfs_ioctl.c
>>>>>>>> @@ -1439,6 +1439,10 @@ xfs_ioctl_setattr(
>>>>>>>>
>>>>>>>>      	trace_xfs_ioctl_setattr(ip);
>>>>>>>>
>>>>>>>> +	/* Check if fsx_xflags have unsupported xflags */
>>>>>>>> +	if (fa->fsx_xflags&     ~FS_XFLAG_ALL)
>>>>>>>> +                return -EOPNOTSUPP;
>>>>>>> Shouldn't this be in vfs_ioc_fssetxattr_check, since we're checking
>>>>>>> against all the vfs defined XFLAGS?
>>>>>> Right, different filesystems support different XFLAGS so I think it is hard
>>>>>> to put this
>>>>>> check into vfs_ioc_fssetxattr_check().  For example,
>>>>>> 1) ext4 defines EXT4_SUPPORTED_FS_XFLAGS and do the check before
>>>>>> vfs_ioc_fssetxattr_check():
>>>>> I guess I wasn't clear enough about the xflags checks.
>>>>>
>>>>> Historically, XFS never checked the flags value for set bits that don't
>>>>> correspond to a known (X)FS_XFLAG_ value.  If your program passes in a
>>>>> set bit that the kernel doesn't know about, the kernel does nothing
>>>>> about it, and a subsequent FSGETXATTR will not have that bit set.
>>>> Hi Darrick,
>>>>
>>>> Yes, we have to confirm if XFS supports the specified xflag by both
>>>> FSSETXATTR and
>>>> FSGETXATT(instead of the single FSSETXATTR) so it is not clear and simple
>>>> for user.
>>>> This patch just makes ioctl(FSSETXATTR) return -EOPNOTSUPP when XFS doesn't
>>>> support
>>>> the specified xflag.
>>>> Note: ext4/f2fs/btrfs have implemented the behavior.
>>>>
>>>> BTW:
>>>> With this patch, current '_require_xfs_io_command "chattr"' in xfstests can
>>>> check XFS's
>>>> supported xflags directly and don't need to check them by extra
>>>> ioctl(FSGETXATTR).
>>>>> The old ioctl (back when it was xfs only) wasn't officially documented,
>>>>> so it wasn't clear whether the kernel should do that or return EINVAL.
>>>>>
>>>>> Then the ioctl pair was hoisted to the VFS, a manpage was written
>>>>> specifying an EINVAL return for invalid arguments, and ext4, f2fs, and
>>>>> btrfs followed this.
>>>>>
>>>>> FS_XFLAG_ALL is the set of all defined FS_XFLAG_* values.  Therefore,
>>>>> the VFS needs to check that userspace does not try to pass in a flags
>>>>> value with totally unknown bits set in it.  That's what I thought you
>>>>> were trying to do with this patch.
>>>>>
>>>>> Since you bring it up, however -- ext4/f2fs/btrfs support only a subset
>>>>> of the (X)FS_XFLAG values, so they implement a second check to constrain
>>>>> the flags values to the ones that those filesystems support.  I doubt
>>>>> that the set of flags that XFS supports will stay the same as the set of
>>>>> flags that the VFS header establishes, so it would be wise to implement
>>>>> a second check in XFS, even if right now it provides no added benefit
>>>>> over the VFS check.
>>>> This patch just tries to implement the second check in XFS.
>>>>
>>>> Different filesystems(ext4/f2fs/btrfs/xfs) support different xflags so the
>>>> check depends
>>>> on these filesystems instead of vfs.  I am not sure why we need to implement
>>>> the first
>>>> check?(I think the first check seems surplus)
> Oops, sorry, I didn't notice this.
>
> The reason for checking both in the VFS and in the fs driver itself is
> to ensure that there's at least some checking of the syscall inputs even
> if a new fs implementation neglects to check the flags.
Hi Darrick,

It is reasonable for your concern to add a check in VFS, but checking all
defined xflags is too rough in VFS if one filesystem only supports few 
xflags. :-)

Best Regards,
Xiao Yang
> (Or the original implementation<cough>.)
>
>> Hi Darrick,
>>
>> Do you agree this point that only implements the second check in XFS? :-)
> Yes.
>
>>>>> IOWs, I'm suggesting that you write one patch to define a FS_XFLAG_ALL
>>>>> consisting of all known FS_XFLAG_* values, and a check in
>>>>> vfs_ioc_fssetxattr_check that uses that to establish basic sanity of the
>>>>> arguments; and a second patch to define a XFS_XFLAG_ALL consisting of
>>>>> all the flags that XFS supports, and a check in xfs_ioctl_setattr that
>>>>> uses XFS_XFLAG_ALL to establish that we're not passing in an XFLAG that
>>>>> XFS doesn't support.
>>>> How about the following patch(i.e. add a check in xfs_ioctl_setattr):
>>>> -----------------------------------------------------------
>>>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>>>> index 84bcffa87753..8ac19f55c701 100644
>>>> --- a/fs/xfs/libxfs/xfs_fs.h
>>>> +++ b/fs/xfs/libxfs/xfs_fs.h
>>>> @@ -92,6 +92,14 @@ struct getbmapx {
>>>>    #define XFS_FMR_OWN_COW                FMR_OWNER('X', 7) /* cow staging */
>>>>    #define XFS_FMR_OWN_DEFECTIVE  FMR_OWNER('X', 8) /* bad blocks */
>>>>
>>>> +#define XFS_SUPPORTED_FS_XFLAGS \
>>>> +       (FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
>>>> +        FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME |
>>>> FS_XFLAG_NODUMP | \
>>>> +        FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
>>>> +        FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
>>>> +        FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
>>>> +        FS_XFLAG_HASATTR)
>>> This is an implementation detail, so you might as well put it right
>>> above xfs_ioctl_setattr.
>>>
>>> That and xfs_fs.h gets packaged in /usr/include so we don't want to have
>>> to support that symbol for userspace programs forever.
>> Will put the macro above xfs_ioctl_setattr, as below:
>> -------------------------------------------------------------
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 6f22a66777cd..e188e81961bd 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1425,6 +1425,14 @@ xfs_ioctl_setattr_check_projid(
>> return 0;
>> }
>>
>> +#define XFS_SUPPORTED_FS_XFLAGS \
>> + (FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
>> + FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
>> + FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
>> + FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
>> + FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
>> + FS_XFLAG_HASATTR)
>> +
>> STATIC int
>> xfs_ioctl_setattr(
>> xfs_inode_t *ip,
>> @@ -1439,6 +1447,10 @@ xfs_ioctl_setattr(
>>
>> trace_xfs_ioctl_setattr(ip);
>>
>> + /* Check if fsx_xflags has unsupported xflags */
>> + if (fa->fsx_xflags&  ~XFS_SUPPORTED_FS_XFLAGS)
>> + return -EOPNOTSUPP;
>> +
>> code = xfs_ioctl_setattr_check_projid(ip, fa);
>> if (code)
>> return code;
>> -------------------------------------------------------------
>>
>> Best Regards,
>> Xiao Yang
>>> --D
>>>
>>>> +
>>>>    /*
>>>>     * Structure for XFS_IOC_FSSETDM.
>>>>     * For use by backup and restore programs to set the XFS on-disk inode
>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>>> index 6f22a66777cd..ec5feaa8dec8 100644
>>>> --- a/fs/xfs/xfs_ioctl.c
>>>> +++ b/fs/xfs/xfs_ioctl.c
>>>> @@ -1439,6 +1439,10 @@ xfs_ioctl_setattr(
>>>>
>>>>           trace_xfs_ioctl_setattr(ip);
>>>>
>>>> +       /* Check if fsx_xflags have unsupported xflags */
>>>> +       if (fa->fsx_xflags&   ~XFS_SUPPORTED_FS_XFLAGS)
>>>> +                return -EOPNOTSUPP;
>>>> +
>>>>           code = xfs_ioctl_setattr_check_projid(ip, fa);
>>>>           if (code)
>>>>                   return code;
>>>> -----------------------------------------------------------
>>>>
>>>> Best Regards,
>>>> Xiao Yang
>>>>> --D
>>>>>
>>>>>> -------------------------------------------------------------------------------
>>>>>> ext4/ioctl.c:
>>>>>> #define EXT4_SUPPORTED_FS_XFLAGS (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | \
>>>>>>                                      FS_XFLAG_APPEND | FS_XFLAG_NODUMP | \
>>>>>>                                      FS_XFLAG_NOATIME | FS_XFLAG_PROJINHERIT |
>>>>>> \
>>>>>>                                      FS_XFLAG_DAX)
>>>>>> ...
>>>>>>                    if (fa.fsx_xflags&    ~EXT4_SUPPORTED_FS_XFLAGS)
>>>>>>                            return -EOPNOTSUPP;
>>>>>> ...
>>>>>> -------------------------------------------------------------------------------
>>>>>> 2) btrfs adds check_xflags() and calls it before vfs_ioc_fssetxattr_check():
>>>>>> -------------------------------------------------------------------------------
>>>>>> btrfs/ioctl.c:
>>>>>> static int check_xflags(unsigned int flags)
>>>>>> {
>>>>>>            if (flags&    ~(FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE |
>>>>>> FS_XFLAG_NOATIME |
>>>>>>                          FS_XFLAG_NODUMP | FS_XFLAG_SYNC))
>>>>>>                    return -EOPNOTSUPP;
>>>>>>            return 0;
>>>>>> }
>>>>>> ...
>>>>>>            ret = check_xflags(fa.fsx_xflags);
>>>>>>            if (ret)
>>>>>>                    return ret;
>>>>>> ...
>>>>>> -------------------------------------------------------------------------------
>>>>>>
>>>>>> Perhaps, I should rename FS_XFLAG_ALL to XFS_SUPPORTED_FS_XFLAGS and move
>>>>>> it into libxfs/xfs_fs.h.
>>>>>>
>>>>>> Best Regards,
>>>>>> Xiao Yang
>>>>>>> --D
>>>>>>>
>>>>>>>> +
>>>>>>>>      	code = xfs_ioctl_setattr_check_projid(ip, fa);
>>>>>>>>      	if (code)
>>>>>>>>      		return code;
>>>>>>>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>>>>>>>> index f44eb0a04afd..31b6856f6877 100644
>>>>>>>> --- a/include/uapi/linux/fs.h
>>>>>>>> +++ b/include/uapi/linux/fs.h
>>>>>>>> @@ -142,6 +142,14 @@ struct fsxattr {
>>>>>>>>      #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>>>>>>>>      #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
>>>>>>>>
>>>>>>>> +#define FS_XFLAG_ALL \
>>>>>>>> +	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
>>>>>>>> +	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
>>>>>>>> +	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
>>>>>>>> +	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
>>>>>>>> +	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
>>>>>>>> +	 FS_XFLAG_HASATTR)
>>>>>>>> +
>>>>>>>>      /* the read-only stuff doesn't really belong here, but any other place is
>>>>>>>>         probably as bad and I don't want to create yet another include file. */
>>>>>>>>
>>>>>>>> -- 
>>>>>>>> 2.25.1
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>> .
>>>>>>>
>>>>> .
>>>>>
>>>>
>>> .
>>>
>>
>>
>
> .
>



