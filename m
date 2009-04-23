Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NIc77a019529 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 13:38:08 -0500
Received: from eu1sys200aog118.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5355E1445131
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 11:40:53 -0700 (PDT)
Received: from eu1sys200aog118.obsmtp.com (eu1sys200aog118.obsmtp.com
	[207.126.144.145]) by cuda.sgi.com with ESMTP id
	KIX1pG6RLRGLWn80 for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 11:40:53 -0700 (PDT)
Message-ID: <49F0B572.7090101@st.com>
Date: Thu, 23 Apr 2009 19:37:38 +0100
From: Stuart MENEFY <stuart.menefy@st.com>
MIME-Version: 1.0
Subject: Re: Help debugging a use after free
References: <49E37972.1070101@st.com> <49E4DF8C.4050800@thebarn.com>
	<49E8A081.7020200@st.com> <20090419081702.GD16929@discord.disaster>
	<49F092D6.4070507@st.com> <49F09651.6010104@xfs.org>
In-Reply-To: <49F09651.6010104@xfs.org>
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

Russell Cattelan wrote:
> Stuart MENEFY wrote:
>> Dave Chinner wrote:
>>   
>>> On Fri, Apr 17, 2009 at 04:30:09PM +0100, Stuart MENEFY wrote:
>>>     
>>>>> If you can instrument actually free that is causing the problem it
>>>>> would be good to print out the
>>>>> actually pid doing the free and as many return addresses that you can,
>>>>> so we can get an
>>>>> idea of the actual call chain.
>>>>>         
>>>> The free is coming from the xfssyncd thread, the back trace looks like:
>>>>
>>>> [<8418d0e2>] xfs_idestroy+0x22/0x100
>>>> [<8418a1b0>] xfs_ireclaim+0x50/0x80
>>>> [<841ad7f2>] xfs_finish_reclaim+0x32/0x1c0
>>>> [<841ada30>] xfs_finish_reclaim_all+0xb0/0x100
>>>> [<8418a780>] xfs_ilock_nowait+0x0/0x160
>>>> [<841a9df2>] xfs_syncsub+0x52/0x360
>>>> [<84335108>] schedule_timeout+0x48/0x100
>>>> [<841ab684>] xfs_sync+0x24/0x40
>>>> [<841e0ce0>] list_add+0x0/0x20
>>>> [<841c041c>] vfs_sync+0x1c/0x40
>>>> [<841bf37c>] vfs_sync_worker+0x1c/0x60
>>>> [<841bf6b6>] xfssyncd+0xb6/0x140
>>>> [<8402f0dc>] kthread+0x3c/0x80
>>>> [<84012440>] complete+0x0/0x60
>>>> [<841bf600>] xfssyncd+0x0/0x140
>>>> [<8402f060>] kthread_should_stop+0x0/0x20
>>>> [<84003984>] kernel_thread_helper+0x4/0x20
>>>> [<8402f0a0>] kthread+0x0/0x80
>>>> [<84003980>] kernel_thread_helper+0x0/0x20
>>>>       
>>> There were some use-after-free fixes in .27 timeframe to the inode
>>> reclaim code. Can you reeetest with a more recent kernel?
>>>     
>> Possibly. I have a half-finished port of 2.6.27-rc4
>>  to our hardware
>> which I could probably get going fairly quickly. Do you think that
>> would be sufficient to pick up the use-after-free fixes?
>>
>> Thanks
>>
>> Stuart
>>
>>   
> Any reason you are using an rc4? vs 2.6.27?

None, it just happened to be the latest at the time I did the work.

> I would simply run a diff over rc4 fs/xfs and 2.6.27 fs/xfs and see what
> is different if anything.

There are about 500 lines of diff. Tracking them back to the git commits its
about 10 commits, most of which are self contained XFS specific changes,
and a couple are simple changes which affect all users of a kernel wide API.
So on a first glance bringing the XFS code upto 2.6.27 level wouldn't be a
problem. One of these change is a use-after-free fix (in buffers, not inodes
which appears to be the problem I'm seeing), so its probably worth the effort.

OK, I'll give that a try, and see what happens.

Stuart

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
