Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BF237F37
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 20:15:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBAA38F804B
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 18:15:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nRBgp0AxOMXycIMA for <xfs@oss.sgi.com>;
	Wed, 08 Jul 2015 18:15:28 -0700 (PDT)
Date: Thu, 9 Jul 2015 11:15:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-ID: <20150709011526.GE3902@dastard>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
	<20150702112623.1c83d473@harpe.intellique.com>
	<E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
	<20150703235500.GR7943@dastard>
	<0F9CF77D-1DA5-41DD-87AA-7F4109F08EFB@intomics.com>
	<20150707001900.GU7943@dastard>
	<7B558BFF-FC46-4378-84C0-4442C1209F45@intomics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7B558BFF-FC46-4378-84C0-4442C1209F45@intomics.com>
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
To: Rasmus Borup Hansen <rbh@intomics.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 08, 2015 at 12:28:19PM +0200, Rasmus Borup Hansen
wrote:
> > On 07 Jul 2015, at 02:19, Dave Chinner <david@fromorbit.com>
> > wrote:
> > 
> > On Mon, Jul 06, 2015 at 01:08:52PM +0200, Rasmus Borup Hansen
> > wrote:
> >> I've made a metadump and I'm running another xfs_repair, but
> >> given that the first metadump is 132 GB, will you still be
> >> interested in looking at the dumps?
> > 
> > That's significantly larger than my monthly download quota.  How
> > big is it once you compress it?
> 
> One metadump is 25 GB when compressed with xz -9. The server the
> files currently reside on is not very fast, so I've only
> compressed one of them so far.
> 
> I used the strings command on the metadump files and discovered
> that they contain fragments of files that we really don't want to
> leave our IT systems. However, if you think it's worth the effort,
> I could set up a virtual machine with the metadump files and give
> you access with your SSH public key. But then you'll have to tell
> me which tools you'll need for investigating the files.

<sigh>

I only want to look at one inode with xfs_db....

I don't think ssh access is going be very useful. To isolate the
actual cause of the verifier error I usually run an instrumented
kernel, and to verify that I've fixed the problem I'll need to run
custom kernels and/or xfsprogs binaries. So I really need a local fs
image to do this.

I also like to run a kernel I trust (i.e. one I've built myself) on
a machine I trust not to have storage or hardware issues when doing
diagnostics on broken filesystem images.

Of course, nobody can learn about how to find problems like this
when the triage is hidden away in private....

> Output from ls when listing "lost+found":
> 
> $ ls -laF /backup/lost+found/
> ls: /backup/lost+found/11539619467: Structure needs cleaning

This is the inode I need to look at. Can you grep for this inode in
the xfs_repair output and post it? (grab a couple of lines of
context around each match, too...)

> total 4
> drwxr-xr-x 2 root root     32 Jun 30 07:43 ./
> drwxr-xr-x 5 root root     74 Jul  2 12:55 ../
> -rw-rw-rw- 1 tsj  intomics  0 Jun 23 16:11 11539619467

It's a zero length file, so I'll be interested to know what
attributes it has on it. Can you check that the inode number of
that file is 11539619467 (ls -i will tell you that) and then post
the output of this command:

# xfs_db -r -c "inode 11539619467" -c p /dev/mapper/backup01-data

Then I can give you the commands for walking and dumping the
full attribute tree.

> [503166.562498] XFS (dm-0): Corruption detected. Unmount and run xfs_repair
> [503166.589297] XFS (dm-0): metadata I/O error: block 0x157e84da0 ("xfs_trans_read_buf_map") error 117 numblks 8

Also, post the output of:

# xfs_db -r -c "convert daddr 0x157e84da0 fsb"  /dev/mapper/backup01-data
<fsb>
# xfs_db -r -c "fsb <fsb>" -c p -c "type attr" -c p /dev/mapper/backup01-data

Which will give me the contents of the bad block, both in raw format
and as processed by the attribute leaf format parser in xfs_db.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
