Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4ED77F50
	for <xfs@oss.sgi.com>; Wed, 27 Mar 2013 11:42:31 -0500 (CDT)
Message-ID: <5153217B.5070909@sgi.com>
Date: Wed, 27 Mar 2013 11:42:35 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: Announce re-factor all current xfstests patches request
References: <5152F2BB.4000709@sgi.com> <20130327134606.GJ5861@thunk.org>
In-Reply-To: <20130327134606.GJ5861@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 03/27/2013 08:46 AM, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 08:23:07AM -0500, Rich Johnston wrote:
>> All xfstest developers,
>>
>> Thanks again for all your time in submitting and reviewing patches
>> for xfstests.  The latest patchset posted here:
>>
>> http://oss.sgi.com/archives/xfs/2013-03/msg00467.html
>>
>> requires all current patches to be re-factored.
>
> Given that we are now segregating patches into subdirectories, is it
> correct in the future tests should be named descriptively, instead of
> using 3 digit NNN numbers (which has been a major pain from a central
> assignment perspective)?
Yes
>
> If so, is there a suggested naming convention that is being recommended?
>
> Thanks for getting this change merged in!!
>
> 					- Ted
>

I suggest:

1. They should also be descriptive of the test rather than a number.
2. All lowercase letters separated by _

i.e.
something like
tests/$FSTYP/break_my_filesystem

Thanks
--Rich


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
