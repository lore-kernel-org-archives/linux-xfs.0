Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J0BC74134180 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 19:11:13 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C100ED58D0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 17:11:11 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id ZWEG5z23mF3FBsA2 for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2011 17:11:11 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6INmpmK032139
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 19:48:51 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6J09sl1136750 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 18:09:54 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6J09sf3022594
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 18:09:54 -0600
Message-ID: <4E24CB50.7020506@linux.vnet.ibm.com>
Date: Mon, 18 Jul 2011 17:09:52 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2 v8] XFS TESTS: ENOSPC Punch Hole Test
References: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
	<1311026953.2790.49.camel@doink>
In-Reply-To: <1311026953.2790.49.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 07/18/2011 03:09 PM, Alex Elder wrote:
> On Sun, 2011-07-17 at 16:52 -0700, Allison Henderson wrote:
>> This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
>> This test will verify that a hole can be punched even when the disk is full.
>> Reserved blocks should be used to complete the operation when there is not blocks
>> to further fragment the file.
>>
>> Because punching a hole does not always require extra blocks, there needs to
>> be several iterations of punching holes, and then filling the file system to 100%
>> usage before it is forced to grow the tree in order to handle the fragmentation.
>> The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.
>
> I have reviewed both of your updated patches.  They
> both look good to me.  I'll give it another day or
> two for others to comment if they like, but unless
> someone suggests changes I'll commit this for you.
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>

Alrighty then, sounds good to me.  Thanks Alex!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
