Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAB3F7F54
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 14:15:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4F1EFAC003
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 12:15:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kDmjomGGXuxEcF6w for
	<xfs@oss.sgi.com>; Thu, 20 Jun 2013 12:15:20 -0700 (PDT)
Message-ID: <51C35410.2040109@redhat.com>
Date: Thu, 20 Jun 2013 15:12:16 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] userns: Convert xfs to use kuid/kgid where appropriate
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com> <51C31F48.9070503@redhat.com>
	<20130620133903.5193d3ee@oracle.com>
In-Reply-To: <20130620133903.5193d3ee@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

On 06/20/2013 01:39 PM, Dwight Engen wrote:
> On Thu, 20 Jun 2013 11:27:04 -0400
> Brian Foster <bfoster@redhat.com> wrote:
> 
>> On 06/20/2013 09:54 AM, Dwight Engen wrote:
>>> On Thu, 20 Jun 2013 10:13:41 +1000
>>> Dave Chinner <david@fromorbit.com> wrote:
>>>
>>>> On Wed, Jun 19, 2013 at 11:09:48AM -0400, Dwight Engen wrote:
...
>>
>> Hi Dwight,
>>
>> If I understand correctly, the proposition is to turn
>> XFS_EOF_FREE_EOFBLOCKS into administrator only functionality and run
>> ns conversions on the inode uid/gid and associated eofb values for
>> the ID filtering functionality.
> 
> Hi Brian, yeah that was the proposal :) I think there are really two
> issues here. One is that the uid_t/gid_t may come from a userns so we
> should be aware of that. Currently the ids passed in are used for
> *filtering* so a malicious user can't do anything more than they
> already can by not passing ids at all, but we should fix this so only
> the intended files are affected. Second is that currently the ioctl
> allows an unprivileged user to affect another user (as Eric pointed
> out):
> 
>> I am little dubious about XFS_IOC_FREE_EOFBLOCKS allowing any
>> user to affect any other user.  Your changes just seem to make
>> it guaranteed that when called from a user namespace the wrong
>> user will be affected.
> 
> I don't think the nsown_capability() I proposed is enough to take care
> of this. Do you agree that if the caller is going to affect other
> users, they should be CAP_SYS_ADMIN (or maybe CAP_FOWNER) in
> init_user_ns?
> 

Yeah, that's what I was getting at below by restricting "global" scans
to admin privilege.

>> The latter sounds reasonable to me, though I'm not so sure about the
>> CAP_SYS_ADMIN bit. For example, I think we'd expect a regular user to
>> be able to run an eofblocks scan against files covered under his
>> quota.
>>
>> Perhaps the right thing to do here is to restrict global (and project
>> quota?) scans to CAP_SYS_ADMIN and uid/gid based scans to processes
>> with the appropriate permissions (i.e., CAP_SYS_ADMIN, matching
>> uid/gid or CAP_FOWNER). Thoughts?
> 
> That sounds good to me. Maybe for a regular user the appropriate
> permission check (at the top of xfs_inode_free_eofblocks()) could be
> something like:
> 

I think the various capability/permission checks should be in the ioctl
code. xfs_icache_free_eofblocks() and below are internal interfaces
where these checks are probably not relevant. I actually have code lying
around that creates an internal structure for that code, similar but
separate from the xfs_eofblocks structure.

> 	if (!capable(CAP_SYS_ADMIN) &&
> 	    !uid_eq(VFS_I(ip)->i_uid, current_fsuid()) &&
> 	    !in_group_p(VFS_I(ip)->i_gid))
> 		return 0;
> 

This is a little confusing (and pardon me, I'm a bit new to the
namespace work). What might be a bit more clear is to do the capability
checks against the EOFBLOCKS command flags in xfs_file_ioctl() and
return an appropriate error if permission is not granted for the
requested type of scan (i.e., a regular user doing a global or non-id
matching scan). Then restrict the changes in xfs_icache_free_eofblocks()
to just dealing with the namespace conversions.

This would still allow use cases such as the pending code I have that
invokes an eofblocks scan on write() failure due to EDQUOT/ENOSPC in the
case of project or user/group quotas. I suspect adding the namespace
conversion stuff wouldn't break the typical user/group quota case, but
we'd still require the ability to run a project quota scan from a
particular user context. I think the combined check you have above would
break that.

Brian

> This has the drawback that the caller won't know if they supplied a
> uid/gid in eofblocks that won't actually get cleared, so maybe we
> want to validate a uid/gid in eofblocks after its copy_from_user()ed
> in instead? Also, I'm not sure if this is the same as "under his quota"
> and how it plays with project quotas.
> 
>> Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
