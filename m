Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NGAdI8014191 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 11:10:40 -0500
Received: from eu1sys200aog106.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D69F314444B6
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 09:13:24 -0700 (PDT)
Received: from eu1sys200aog106.obsmtp.com (eu1sys200aog106.obsmtp.com
	[207.126.144.121]) by cuda.sgi.com with ESMTP id
	AstgCvjN0t8rNOGZ for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 09:13:24 -0700 (PDT)
Message-ID: <49F092D6.4070507@st.com>
Date: Thu, 23 Apr 2009 17:09:58 +0100
From: Stuart MENEFY <stuart.menefy@st.com>
MIME-Version: 1.0
Subject: Re: Help debugging a use after free
References: <49E37972.1070101@st.com> <49E4DF8C.4050800@thebarn.com>
	<49E8A081.7020200@st.com> <20090419081702.GD16929@discord.disaster>
In-Reply-To: <20090419081702.GD16929@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Fri, Apr 17, 2009 at 04:30:09PM +0100, Stuart MENEFY wrote:
>>> If you can instrument actually free that is causing the problem it
>>> would be good to print out the
>>> actually pid doing the free and as many return addresses that you can,
>>> so we can get an
>>> idea of the actual call chain.
>> The free is coming from the xfssyncd thread, the back trace looks like:
>>
>> [<8418d0e2>] xfs_idestroy+0x22/0x100
>> [<8418a1b0>] xfs_ireclaim+0x50/0x80
>> [<841ad7f2>] xfs_finish_reclaim+0x32/0x1c0
>> [<841ada30>] xfs_finish_reclaim_all+0xb0/0x100
>> [<8418a780>] xfs_ilock_nowait+0x0/0x160
>> [<841a9df2>] xfs_syncsub+0x52/0x360
>> [<84335108>] schedule_timeout+0x48/0x100
>> [<841ab684>] xfs_sync+0x24/0x40
>> [<841e0ce0>] list_add+0x0/0x20
>> [<841c041c>] vfs_sync+0x1c/0x40
>> [<841bf37c>] vfs_sync_worker+0x1c/0x60
>> [<841bf6b6>] xfssyncd+0xb6/0x140
>> [<8402f0dc>] kthread+0x3c/0x80
>> [<84012440>] complete+0x0/0x60
>> [<841bf600>] xfssyncd+0x0/0x140
>> [<8402f060>] kthread_should_stop+0x0/0x20
>> [<84003984>] kernel_thread_helper+0x4/0x20
>> [<8402f0a0>] kthread+0x0/0x80
>> [<84003980>] kernel_thread_helper+0x0/0x20
> 
> There were some use-after-free fixes in .27 timeframe to the inode
> reclaim code. Can you reeetest with a more recent kernel?

Possibly. I have a half-finished port of 2.6.27-rc4 to our hardware
which I could probably get going fairly quickly. Do you think that
would be sufficient to pick up the use-after-free fixes?

Thanks

Stuart

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
