Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36CC17F4E
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 22:14:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 247A4304067
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 20:14:35 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id vn3ES9Jboro0tGCE for
	<xfs@oss.sgi.com>; Mon, 29 Jul 2013 20:14:33 -0700 (PDT)
Message-ID: <51F72FE6.4080202@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 11:15:50 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle
	projids in any user namespace
References: <87txpaph4n.fsf@xmission.com>
	<1361149870-27732-1-git-send-email-ebiederm@xmission.com>
	<1361149870-27732-5-git-send-email-ebiederm@xmission.com>
	<20130219015550.GJ26694@dastard> <51F616F2.5040906@cn.fujitsu.com>
	<20130729075109.GF13468@dastard>
In-Reply-To: <20130729075109.GF13468@dastard>
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
To: Dave Chinner <david@fromorbit.com>, dwight.engen@oracle.com
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>

On 07/29/2013 03:51 PM, Dave Chinner wrote:
> [ cc xfs list ]
> 
> On Mon, Jul 29, 2013 at 03:17:06PM +0800, Gao feng wrote:
>> On 02/19/2013 09:55 AM, Dave Chinner wrote:
>>> On Sun, Feb 17, 2013 at 05:10:58PM -0800, Eric W. Biederman wrote:
>>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>>>
>>>> - Convert the userspace value in fa->fsx_projid into a kprojid and
>>>>   store it in the variable projid.
>>>> - Verify that xfs can store the projid after it is converted into
>>>>   xfs's user namespace.
>>>> - Replace uses of fa->fsx_projid with projid throughout
>>>>   xfs_ioctl_setattr.
>>>>
>>>> Cc: Ben Myers <bpm@sgi.com>
>>>> Cc: Alex Elder <elder@kernel.org>
>>>> Cc: Dave Chinner <david@fromorbit.com>
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> ---
>>>>  fs/xfs/xfs_ioctl.c |   26 ++++++++++++++++++--------
>>>>  1 files changed, 18 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>>> index 016624b..4a55f50 100644
>>>> --- a/fs/xfs/xfs_ioctl.c
>>>> +++ b/fs/xfs/xfs_ioctl.c
>>>> @@ -925,6 +925,7 @@ xfs_ioctl_setattr(
>>>>  	struct xfs_dquot	*gdqp = NULL;
>>>>  	struct xfs_dquot	*olddquot = NULL;
>>>>  	int			code;
>>>> +	kprojid_t		projid = INVALID_PROJID;
>>>>  
>>>>  	trace_xfs_ioctl_setattr(ip);
>>>>  
>>>> @@ -934,11 +935,20 @@ xfs_ioctl_setattr(
>>>>  		return XFS_ERROR(EIO);
>>>>  
>>>>  	/*
>>>> -	 * Disallow 32bit project ids when projid32bit feature is not enabled.
>>>> +	 * Verify the specifid project id is valid.
>>>>  	 */
>>>> -	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
>>>> -			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
>>>> -		return XFS_ERROR(EINVAL);
>>>> +	if (mask & FSX_PROJID) {
>>>> +		projid = make_kprojid(current_user_ns(), fa->fsx_projid);
>>>> +		if (!projid_valid(projid))
>>>> +			return XFS_ERROR(EINVAL);
>>>> +
>>>> +		/*
>>>> +		 * Disallow 32bit project ids when projid32bit feature is not enabled.
>>>> +		 */
>>>> +		if ((from_kprojid(&init_user_ns, projid) > (__uint16_t)-1) &&
>>>> +		    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
>>>> +			return XFS_ERROR(EINVAL);
>>>> +	}
>>>
>>> That looks busted. Why does one use current_user_ns() and the other
>>> &init_user_ns()?
>>>
>>
>> hmm, through this thread had been stopped discussing for a long time, but I'm working on converting
>> ids to kids for xfs now, and I want to remove the finial dependenciy for user namespace.
> 
> You're duplicating work that is already going on - we've been
> talking about this stuff on the XFS list and reviewing patches for
> the last 3-4 weeks for this.
> 

oops.. thanks for your reminder!

> http://oss.sgi.com/pipermail/xfs/2013-July/028467.html
> 
> Basically, the discussion we are currently having is whether project
> IDs should be exposed to user namespaces at all. e.g:
> 
> http://oss.sgi.com/pipermail/xfs/2013-July/028497.html
> http://oss.sgi.com/pipermail/xfs/2013-July/028551.html
> 
> "Basically, until we have worked out *if* project quotas can be used
> safely within user namespaces, we need to reject any attempt to use
> them from within a user namespace container."
> 

yes, seems this v6 patchset allows user in un-init user namespace to setup proj quota
through ioctl, and the projid hasn't been converted to kprojid in this patchset.
Doesn't this will cause user in container has the ability to change the proj quota
which is set by root user in host?

> i.e. the whole "project IDs are part of user namespaces because of
> quotas" looks like a bad decision to have been made. Project IDs are
> independent of users and groups and can be used to account for usage
> across discontiguous directory and permission heirarchies, so trying
> to contain them to a "user namespace" really matches their
> functionality.

I'm ok if we disallow un-init user namespace to setup proj quota right now,
all user namespace will share the same proj quota and only init user namespace
has the rights to modify proj quota. this looks clear to me.


Thanks,
Gao

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
