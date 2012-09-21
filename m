Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8LKJX2t245847 for <xfs@oss.sgi.com>; Fri, 21 Sep 2012 15:19:34 -0500
Message-ID: <505CCC1D.4000203@redhat.com>
Date: Fri, 21 Sep 2012 15:20:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add _require_freeze and minor cleanups
References: <505A4D04.2080105@redhat.com> <20120921163827.GA1140@sgi.com>
	<505C9A35.5000404@redhat.com> <20120921195921.GB1140@sgi.com>
In-Reply-To: <20120921195921.GB1140@sgi.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 9/21/12 2:59 PM, Ben Myers wrote:
> On Fri, Sep 21, 2012 at 11:47:49AM -0500, Eric Sandeen wrote:
>> On 9/21/12 11:38 AM, Ben Myers wrote:
>>> Hey Eric,
>>>

...

>>> Pretty good idea to generalize _require_freeze.  It looks like xfs_freeze is a
>>> script that uses xfs_io which uses xfsctl XFS_IOC_FREEZE.  So isn't what you
>>> have here xfs specific?  It wouldn't work for the other filesystems that
>>> implement s_op.freeze_fs:
>>
>> It got elevated to a generic ioctl:
>>
>> fs/xfs/xfs_fs.h:
>> /*      XFS_IOC_FREEZE            -- FIFREEZE   119      */
>> /*      XFS_IOC_THAW              -- FITHAW     120      */
>>
>> to:
>>
>> include/linux/fs.h:
>> #define FIFREEZE        _IOWR('X', 119, int)    /* Freeze */
>> #define FITHAW          _IOWR('X', 120, int)    /* Thaw */
> 
> Ah, great.  I see it now.  It looks like test 119 is also using freeze.  Should
> that one also _require_freeze?

Since it's xfs-specific, I didn't think it was necessary, but it could.

-Eric

> Reviewed-by: Ben Myers <bpm@sgi.com>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
