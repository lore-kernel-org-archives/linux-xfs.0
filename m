Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B22C77F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 12:54:19 -0500 (CDT)
Message-ID: <526AB077.6030800@sgi.com>
Date: Fri, 25 Oct 2013 12:55:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: linux-3.12 userspace
References: <526A6FF9.8000506@sgi.com> <526A87F4.2020207@sandeen.net>
In-Reply-To: <526A87F4.2020207@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 10/25/2013 10:02 AM, Eric Sandeen wrote:
> On 10/25/13 8:19 AM, Rich Johnston wrote:
>> Hey Folks,
>>
>> Dave Chinner has a 32 part userspace patchset that needs to be reviewed
>> and will be committed to coincide with the linux-3.12 kernel release.
I was referring to userspace ( hence the subject ;) ) matching kernel.
>>
>> Are there other userspace patches that support 3.12 kernel features that
>> need to be worked?
>>
>> All other patches on the list will be held back until the linux-3.13
>> merge window has opened.
>
> Are you talking about holding back kernelspace or userspace patches?
Only userspace.
>
> We'd want to get kernelspace merged in the xfs git tree well before
> the merge window,
Yup Ben is working on it.
> and I don't think the kernel merge window needs to
> affect userspace merges.
Umm yes I need to wait until the kernel supports the feature before 
adding it to userspace.  AFAIR the goal was to have userspace features 
match the kernelspace.
>
> Can you talk in more specifics (which series/patches, for what codebase)
> you're proposing?
Yes I was referring to "[PATCH 00/32] xfsprogs: V5 write support for xfs_db"
http://oss.sgi.com/archives/xfs/2013-09/msg00805.html
Which needs to be reviewed before I can pull it in.

I was asking for any other userspace patches that need to be pulled in 
for the next userspace release so it matches kernel 3.12.
>
> In general I think we simply have a review bottleneck, but once patchsets
> are reviewed, in general, they should just get merged, especially in userspace,
> IMHO.
>
No I was chastised for pulling in reviewed userspace patches too early.
Kernel code was not fully hashed out.
> But maybe I just need more details.  :)
Am I still missing details?
>
> -Eric
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
