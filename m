Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7AE4NLD061939 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 09:04:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBD5C1D562B7
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:05:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id oBShPzYpVxKY0lMF for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 07:05:16 -0700 (PDT)
Message-ID: <4A80291D.6020200@sandeen.net>
Date: Mon, 10 Aug 2009 09:05:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: 220 - generic quota sanity
References: <1871149413.1673471249881207275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1871149413.1673471249881207275.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> This looks good Eric.
> 
> Is this test just for quota accounting or should it be testing quota
> enforcement too?

I guess 108 just did accounting; I was going to keep it parallel, and do
a different one for accounting, but it could be added to this as well.

-Eric

> Lachlan
> 
> ----- "Eric Sandeen" <sandeen@redhat.com> wrote:
> 
>> Add some very basic quota sanity tests for generic filesystems.
>>
>> This is based on test 108, but uses the generic quota tools,
>> not xfs_quota, and therefore cannot test project quota.
>>
>> Also, the IOs are much smaller (48k) so that ext3 won't get into
>> indirect blocks and throw off the accounting.  This does
>> assume 4k blocks though.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
