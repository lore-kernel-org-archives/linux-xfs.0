Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H6VTeK021647 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 01:31:29 -0500
Message-ID: <4F8D0DBC.4020105@oracle.com>
Date: Tue, 17 Apr 2012 14:29:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: Introduce test case 285 to check statfs(2)
	will not cause ASSERT(XFS_IS_QUOTA_RUNNING(mp)) failed.
References: <4F87ED3D.5060105@oracle.com> <20120416174929.GD2924@sgi.com>
In-Reply-To: <20120416174929.GD2924@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hi Ben,

On 04/17/2012 01:49 AM, Ben Myers wrote:

> Jeff,
> 
> On Fri, Apr 13, 2012 at 05:09:17PM +0800, Jeff Liu wrote:
>> Call statfs(2) against a project directory cause ASSERT(XFS_IS_QUOTA_RUNNING(mp)) at xfs_qm_dqget() failed pre-vanilla kernel-3.4
>> if the "pquota" or "prjquota" mount option was not enabled on the underlying partition.  This test case can help checking it.
> 
> A nice find.
> 
>> +echo "Silence is golden."
>> +
>> +# Modify as appropriate.
>> +_supported_fs xfs
>> +_supported_os Linux
>> +_require_xfs_quota
>> +_require_scratch
>> +
>> +proj_dir="${SCRATCH_MNT}/test_project"
>> +test_file="${proj_dir}/test_file"
>> +
>> +_scratch_mkfs_xfs			>/dev/null 2>&1
>> +_qmount
>> +
>> +mkdir $proj_dir
>> +touch $test_file
>> +
>> +$XFS_QUOTA_PROG -x -c "project -s -p ${proj_dir} 2012" $SCRATCH_DEV \
>> +					>/dev/null 2>&1
>> +du -sh $proj_dir			>/dev/null 2>&1
> 
> I was unable to reproduce this until I changed 'du -sh' to 'df'.  Now it does
> crash consistently without your fix for xfs_fs_statfs().

Thanks for help review.
Strange, I can always reproducing that with du(1).  How about call `stat -f /xxx` to be a bit more explicit from the testing point of view?

> 
> With that change you can consider this
> Reviewed-by: Ben Myers <bpm@sgi.com>

Sure, I will add that.

Thanks,
-Jeff

> 
> -Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
