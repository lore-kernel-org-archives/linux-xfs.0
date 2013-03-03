Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C5BE801D
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 16:04:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CB264AC001
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 14:04:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FUHNRFJ0CtbYjVhn for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 14:04:46 -0800 (PST)
Message-ID: <5133C900.9050300@sandeen.net>
Date: Sun, 03 Mar 2013 16:04:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Do not check ocfs2
References: <1362269150-21478-1-git-send-email-richard@nod.at>
	<20130303011917.GI23616@dastard>
	<20130303100254.500b076f@spider.haslach.nod.at>
In-Reply-To: <20130303100254.500b076f@spider.haslach.nod.at>
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
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 3/3/13 3:02 AM, Richard Weinberger wrote:
> Am Sun, 3 Mar 2013 12:19:17 +1100
> schrieb Dave Chinner <david@fromorbit.com>:
> 
>> On Sun, Mar 03, 2013 at 01:05:50AM +0100, Richard Weinberger wrote:
>>> We cannot run fsck.ocfs2 because the file system
>>> is most likely mounted on another node.
>>
>> This patch means that ocfs2 filesystems are *never* checked for
>> consistency, even when you are testing them with exclusive local
>> access. That defeats a primary function of xfstests - ensuring that
>> the tests run do no corrupt the filesystem.
>>
>> Besides, why would you be running xfstests on a filesystem that is
>> mounted on multiple nodes? Yes, ocfs2 is a cluster filesystem, but
>> xfstests is designed to test local filesystem behaviour and is
>> completely cluster naive. Hence having multiple nodes mount the
>> filesystem that is being tested by xfstests does not serve any
>> purpose at all. Further, turning off consistency checking for those
>> that are running ocfs2 testing on single nodes means that testing is
>> now mostly wasted as the majority of problems that can occur are no
>> longer detectable....
> 
> Using xfstests I was able to trigger dlm issues in ocfs2.
> I ran xfstests on one node and other nodes had it mounted too.

Just for my own education, how does that happen?

Were you testing on filesystems already configured into a cluster,
or did the cluster somehow pick up your newly-defined test
fileystems and mount them?

How does fsck.ocfs2 behave when you run it on one node, when the
fs is mounted on others?  Will it proceed w/ no knowledge of the
fact that it's mounted elsewhere?

-Eric

> To ensure that fsck.ocfs2 will not corrupt the filesystem I've applied
> this patch.
> 
> If you don't like the patch I'm perfectly fine with that.
> Maybe it makes more sense to add a feature to xfstests which unmounts
> the ocfs2 filesystem on all nodes (using SSH), then it is allowed to
> run fsck.ocfs2.
> 
> Thanks,
> //richard
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
