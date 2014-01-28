Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6C4C7F91
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 09:36:13 -0600 (CST)
Message-ID: <52E7CE68.6030207@sgi.com>
Date: Tue, 28 Jan 2014 09:36:08 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] xfsprogs for-3.1.12 branch has been updated to 40c65a7
References: <201401201822.48520.arekm@maven.pl> <52E6A9A2.1010905@sgi.com>
	<20140128042024.GH2212@dastard>
In-Reply-To: <20140128042024.GH2212@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 01/27/2014 10:20 PM, Dave Chinner wrote:
> On Mon, Jan 27, 2014 at 12:46:58PM -0600, Rich Johnston wrote:
>> Arkadiusz,
>>
>> Thanks for compiling the list.
>>
>> The for-3.1.12  Branch created from "a547280... 3.1.11 release"
>>
>> If there are others you want committed, please let me know.
>
> What testing have you done on the branch?

Just a quick test.  I wanted to get it out for others who are interested 
in this branch to start testing.

>
>> 40c65a7... xfs_metadump: Make -F (force) optional
>> ec3a1f1... xfs_repair: suggest reboot after dangerous repair
>> 8660952... xfsprogs: suggest "-d" option for repair of RO mount
>> 5a8206c... xfs_repair: correct docs for "-t" units
>> 0d5c444... xfs_fsr: fix SWAPEXT failures under selinux
>> f3d3dae... libxfs: fix root inode handling inconsistencies
>> cf507b6... xfsprogs: remove xfs_check references from fsck.xfs
>> script & manpage
>> 6e2f2d1... xfsprogs: fix resource leak in longform_dir2_rebuild()
>> ecde3f9... xfs_repair: test for bad level in dir2 node
>> d299df7... xfs_repair: avoid segfault if reporting progress early in repair
>> e660c2e... Sent: Friday, October 11, 2013 12:38:11 AM Subject:
>> Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
>
> Can you fix the subject line of this commit, please?

Sorry I missed that.

I can, but a git rebase --interactive e660c2e^ will change the commit 
ids after it.  Is there another way to do this that does not change the 
commit ids?

Thanks
--Rich
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
