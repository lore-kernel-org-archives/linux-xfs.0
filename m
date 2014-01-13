Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A0F3F29DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 21:59:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BC09304039
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 19:59:37 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id RDDtwj03I2lawBTI for
	<xfs@oss.sgi.com>; Sun, 12 Jan 2014 19:59:35 -0800 (PST)
Message-ID: <52D364DA.4000708@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 12:00:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Add pairing mount options test
References: <1389162648-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
	<52D01CA9.4040107@sandeen.net> <52D33F92.2000609@cn.fujitsu.com>
	<52D342F0.5020402@sandeen.net> <20140113015239.GD3469@dastard>
	<52D34EBD.4020508@cn.fujitsu.com> <20140113032650.GH3469@dastard>
In-Reply-To: <20140113032650.GH3469@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Mon, 13 Jan 2014 14:26:50 +1100, Dave Chinner wrote:
> On Mon, Jan 13, 2014 at 10:26:05AM +0800, Qu Wenruo wrote:
>> On mon, 13 Jan 2014 12:52:39 +1100, Dave Chinner wrote:
>>> On Sun, Jan 12, 2014 at 07:35:44PM -0600, Eric Sandeen wrote:
>>>> I won't say no to this, but it seems to be of somewhat limited use.
>>> What happens to the test when mount options are deprecated/removed?
>>> How are we going to handle the matrix of testable/untestable mount
>>> options across kernels with different mount option support?
>> In my opinion,there may be two ways to deal it:
>> 1) Introduce up_limit_kver and down_limit_kver to *every* mount option.
>> If needed also add deprecated flags.
> Both of which are messy, and kernel version number checks don't work
> with vendor kernels that have stuff back ported to them.
>
>> This method will introduce more effort tomaintain the test case, but
>> due to the small codes and
>> relativly less changes in mount options, I consider it as an
>> acceptable method.
> What you are saying is that such a test will require constant
> maintenance from upstream developers to keep working across all the
> kernels that btrfs supports.
>
> When combined with Eric's comments that it doesn't test the
> functionality and so has relatively little benefit in terms of
> improving code coverage, it doesn't paint a pretty picture. So from
> that point of view, I'd say no to such a test.
>
>> It would be quite nice if any one can provide any better idea.
> Write a test for each individual feature that exercises and
> validates that feature in some way. Part of a functional test would
> be to test that the mount options for that function do what they are
> intended to do. Eric suggested the same thing (though in a different
> way).
>
> Cheers,
>
> Dave.
That's right, individual test case is the best way.

But most of the options are just instructive options,
and only affects performance, it's very hard to test. (like space_cace 
and nospace_cache)

If really spilt into individual test case, most cases will be much like this
case just remount it with backgroud fsstress.

Only inode_cache can cause different inode number allocation and can be 
examined.

Now I'm interested in how other filesystems like xfs makes sure that 
every pairing
mount options are tested.

Thanks
Qu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
