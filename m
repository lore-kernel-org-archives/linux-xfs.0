Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 473517F5A
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 02:55:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0ACCE8F8035
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 00:55:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vj2FtDb4VYdOkoCI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 00:55:17 -0700 (PDT)
Message-ID: <517F78D2.5020503@oracle.com>
Date: Tue, 30 Apr 2013 15:54:58 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Don't keep silent if sunit/swidth can not be changed
	via mount
References: <517E5D12.5010809@oracle.com> <20130430073659.GH23072@dastard>
In-Reply-To: <20130430073659.GH23072@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 04/30/2013 03:36 PM, Dave Chinner wrote:
> On Mon, Apr 29, 2013 at 07:44:18PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> As per the mount man page, sunit and swidth can be changed via
>> mount options.  For XFS, on the face of it, those options seems
>> works if the specified alignments is properly, e.g.
>> # mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
>> # mount | grep sdb1
>> /dev/sdb1 on /mnt type xfs (rw,sunit=4096,swidth=8192)
>>
>> However, neither sunit nor swidth is shown from the xfs_info output.
>> # xfs_info /mnt
>> meta-data=/dev/sdb1    isize=256    agcount=4, agsize=262144 blks
>>          =             sectsz=512   attr=2
>> data     =             bsize=4096   blocks=1048576, imaxpct=25
>>          =             sunit=0      swidth=0 blks
>> 		       ^^^^^^^^^^^^^^^^^^^^^^^^^^
>> naming   =version 2    bsize=4096   ascii-ci=0
>> log      =internal     bsize=4096   blocks=2560, version=2
>>          =             sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none         extsz=4096   blocks=0, rtextents=0
>>
>> The reason is that the alignment can only be changed if the relevant
>> super block is already configured with alignments, otherwise, the
>> given value will be silently ignored, so it's better to tell user
>> that the alignment-changing can not take affect in one way or another.
>>
>> With this fix, the attempt to mount a storage without strip alignment
>> setup on super block will failed if XFS_MOUNT_RETERR is enabled, or
>> just ignore the given alignment and drop a warning to indicate the
>> cause in syslog.
>>
>> # mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
>> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
>>
>> # dmesg|tail
>> .......
>> XFS (sdb1): can not change alignment: no data alignment on superblock
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>
>> ---
>>  fs/xfs/xfs_mount.c |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index 3806088..bc7fdd4 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -924,6 +924,13 @@ xfs_update_alignment(xfs_mount_t *mp)
>>  				sbp->sb_width = mp->m_swidth;
>>  				mp->m_update_flags |= XFS_SB_WIDTH;
>>  			}
>> +		} else {
>> +			xfs_warn(mp, "can not change alignment: "
>> +				"no data alignment on superblock");
>> +			if (mp->m_flags & XFS_MOUNT_RETERR)
>> +				return XFS_ERROR(EINVAL);
>> +			mp->m_dalign = 0;
>> +			mp->m_swidth = 0;
> 
> Can someone tell me why the XFS_MOUNT_RETERR flag exists?
This is really a very opportune response because I also worked out
another tiny patch for removing XFS_MOUNT_RETERR a few minutes ago,
just hesitating if I missed anything or not.
> 
> It looks like dead code to me as the only time mp->m_dalign is set
> prior to calling xfs_update_alignment() is the same code that sets
> XFS_MOUNT_RETERR in xfs_parseargs().
> 
> IOWs, any time we enter this "if (mp->m_dalign)" branch in
> xfs_update_alignment(), XFS_MOUNT_RETERR is going to be set and so
> we should always be emitting a warning and returning an error.
Yes, I realized that as I can not trigger a warning only, it always
returning an error to me. :(
> 
> If this is correct, Jeff, can you remove the XFS_MOUNT_RETERR flag
> and get rid of all the dead code in xfs_update_alignment() at the
> same time, please?
Sure, I'll post this patch tonight together with another initial patch
for fixing transaction space over-reservation we have discussed two
weeks ago, xfstests is running now.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
