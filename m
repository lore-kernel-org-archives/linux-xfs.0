Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q02I2vEr220461 for <xfs@oss.sgi.com>; Mon, 2 Jan 2012 12:02:58 -0600
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	Wl7yXFUbUGuNqhyq for <xfs@oss.sgi.com>;
	Mon, 02 Jan 2012 10:02:55 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4EEF52D200387AC4 for xfs@oss.sgi.com; Mon, 2 Jan 2012 18:02:55 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RhmDi-00075b-KM
	for <xfs@oss.sgi.com>; Mon, 02 Jan 2012 18:02:50 +0000
MIME-Version: 1.0
Message-ID: <20225.61770.489211.356415@tree.ty.sabi.co.UK>
Date: Mon, 2 Jan 2012 18:02:50 +0000
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
In-Reply-To: <20225.54924.482210.587313@tree.ty.sabi.co.UK>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
	<4F0181A2.5010505@univ-nantes.fr>
	<20225.54924.482210.587313@tree.ty.sabi.co.UK>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>


>>> The system seems more in I/O wait. Older
>>> kernels (2.6.32.xx and 2.6.26.xx) gives better results.
> [ ... ]
>> When I go back to older kernels, the load go down. With newer
>> kernel, all is working well too, but load (as reported by
>> uptime) is higher.
> [ ... ]
>>> birnie:~/TRACE# uptime
>>> 11:48:34 up 17:18,  3 users,  load average: 0.04, 0.18, 0.23
>>> penderyn:~/TRACE# uptime
>>> 11:48:30 up 23 min,  3 users,  load average: 4.03, 3.82, 3.21
> [ ... ]

> But 'uptime' reports the load average, which is (roughly)
> processes actually running on the CPU. If the load average is
> higher, that usually means that the file system is running
> better, not worse. It looks as if you are not clear whether you
> have a regression or an improvement.

Perhaps it would be useful to see the output of something like
'iostat -d -x 10' and 'vmstat 10' to see if the load average is
higher because of processes waiting less and running more or
whether it is processes running in 'iowait'. It can help also
using 'htop' with an '.htoprc' like this:

--------------------------------------------------------------
fields=0 48 2 17 38 39 13 14 46 62 63 1 
sort_key=63
sort_direction=1
hide_threads=0
hide_kernel_threads=0
hide_userland_threads=0
shadow_other_users=1
highlight_base_name=1
highlight_megabytes=1
highlight_threads=0
tree_view=0
header_margin=0
detailed_cpu_time=1
color_scheme=2
delay=15
left_meters=Memory AllCPUs 
left_meter_modes=1 1 
right_meters=Swap AllCPUs 
right_meter_modes=1 2 
--------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
