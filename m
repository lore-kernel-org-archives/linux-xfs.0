Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE0F77F5D
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 20:18:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89D62304059
	for <xfs@oss.sgi.com>; Mon,  9 Sep 2013 18:18:57 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 8bp4pMJ782OPyG6u for
	<xfs@oss.sgi.com>; Mon, 09 Sep 2013 18:18:56 -0700 (PDT)
Message-ID: <522E73D4.1080805@cn.fujitsu.com>
Date: Tue, 10 Sep 2013 09:20:20 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] xfs: Allow user to change project id in un-init userns
References: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
	<20130906013033.GB23571@dastard> <20130910004210.GX12779@dastard>
In-Reply-To: <20130910004210.GX12779@dastard>
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
Cc: bfoster@redhat.com, dwight.engen@oracle.com, ebiederm@xmission.com, xfs@oss.sgi.com

On 09/10/2013 08:42 AM, Dave Chinner wrote:
> On Fri, Sep 06, 2013 at 11:30:33AM +1000, Dave Chinner wrote:
>> On Wed, Sep 04, 2013 at 02:38:33PM +0800, Gao feng wrote:
>>> This patchset add two helper functions to convert user space project id
>>> to kernel space project id without any struct changed.
>>>
>>> Since the projid_map of user namespace has limit the range of valid project
>>> ids for user namespace, we can safely allow user to change file's project
>>> id in un-init user namespace.
>>
>> This doesn't address any of the concerns about whether access to
>> project IDs are valid in a user namaspacee environment.
>>
>> Project IDs are not the same as UIDs and GIDs. They got included in
>> all the mapping stuff because of the fact that they are used for
>> quotas, but the fact is that they are not a property owned by a user
>> or a group or control access.
>>
>> IOWs, project IDs are an *accounting* construct rather than an
>> *access control mechanism* If project IDs are being used by the
>> system administrators for accounting the space used by a *mount
>> namespace* container, then they must not be modifiable by a user
>> in a user namespace.
>>
>> This is a fundamentally different use case from UID/GID mapping,
>> because there is no possible competing access for on-disk uid/gid
>> fields possible from the initns like there is for project quotas.
>> IOWs, project quota IDs are not owned by a namespace, and so mapping
>> them like we do for UID/GID is not clearly the right solution for
>> everyone.
>>
>> So, there's a bigger policy issue here that needs to be decided
>> first. i.e. whether project quotas and therefore project IDs should
>> be accessible to users inside a user namespace.
>>
>> If we decide to make it optional so that a system administrator can
>> chose whether project IDs are to be mapped via the userns mapping
>> infrastructure, then we need some kind of infrastructure to support
>> and enforce that first.
> 
> BTW, if we are making project IDs mapped to userns, stuff like
> XFS_PROJID_DEFAULT and project ID inheritence need work as well...
> 


Yes, let's make it simple, if we find some cases that we have to make
project IDs mapped to userns, let's restart this work :)

Thanks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
