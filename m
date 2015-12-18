Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A85D27F47
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 20:51:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 942C58F8037
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 18:51:26 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GLuOj5SJXilp7oLM for <xfs@oss.sgi.com>;
	Thu, 17 Dec 2015 18:51:24 -0800 (PST)
Subject: Re: Ideas on unified real-ro mount option across all filesystems
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
	<5673616C.1040706@cn.fujitsu.com>
	<1450404066.6498.70.camel@scientia.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <567374AA.6030007@sandeen.net>
Date: Thu, 17 Dec 2015 20:51:22 -0600
MIME-Version: 1.0
In-Reply-To: <1450404066.6498.70.camel@scientia.net>
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
To: Christoph Anton Mitterer <calestyo@scientia.net>, Qu Wenruo <quwenruo@cn.fujitsu.com>, Eric Sandeen <sandeen@redhat.com>, fsdevel <linux-fsdevel@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>, kzak@redhat.com
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com



On 12/17/15 8:01 PM, Christoph Anton Mitterer wrote:
> On Fri, 2015-12-18 at 09:29 +0800, Qu Wenruo wrote:
>> Given that nothing in the documentation implies that the block
>>> device itself
>>> must remain unchanged on a read-only mount, I don't see any problem
>>> which
>>> needs fixing.  MS_RDONLY rejects user IO; that's all.
>>
>> And thanks for the info provided by Karel, it's clear that at least 
>> mount(8) itself already has explain on what ro will do and what it
>> won't do.
> 
> I wouldn't really agree, here. At least not from the non-developer side
> (and one should hope filesystems and their manpages aren't only made
> for fs-devlopers).
> 
> The manpage says:
>> ro     Mount the filesystem read-only.
>> rw     Mount the filesystem read-write.
> 
> IMHO, that leaves absolutely unclear, what this actually means,
> especially given that most end-users will probably consider the
> filesystem and its device being basically "the same".

<lots of words snipped>

Karel pointed out that recent mount(8) says:

>    -r, --read-only
>        Mount the filesystem read-only.  A synonym is -o ro.
> 
>        Note  that,  depending  on the filesystem type, state and
>        kernel behavior, the system may still write to the device.  For
>        example, ext3 and ext4 will replay the journal if the
>        filesystem is dirty.  To prevent this kind of write access, you
>        may want to mount an ext3 or ext4 filesystem with the ro,noload
>        mount options or set the  block  device itself to read-only
>        mode, see the blockdev(8) command.

which should leave nothing to the imagination.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
