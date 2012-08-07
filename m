Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q77D4UoB069610 for <xfs@oss.sgi.com>; Tue, 7 Aug 2012 08:04:30 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id WJ72eorh5uzpVoip
	for <xfs@oss.sgi.com>; Tue, 07 Aug 2012 06:04:29 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id E6C096C139
	for <xfs@oss.sgi.com>; Tue,  7 Aug 2012 08:04:28 -0500 (CDT)
Message-ID: <5021125C.7060706@hardwarefreak.com>
Date: Tue, 07 Aug 2012 08:04:28 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs hang when filesystem filled
References: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>
In-Reply-To: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 8/7/2012 12:54 AM, Guk-Bong, Kwon wrote:
> HI all
> 
> I tested xfs over nfs using bonnie++
> 
> xfs and nfs hang when xfs filesystem filled
> 
> What's the problem?

The problem is likely the OP has been given enough rope to hang himself. ;)

>     b. lvcreate -L 90G -n test ld1

~90GB device

> data     =                       bsize=4096   blocks=23592960, imaxpct=25

4096*23592960/1048576/1000= ~92GB filesystem

> bonnie++ -s 0 -n 200:1024000:1024000 -r 32G -d /test/ -u 0 -g 0 -q &

((((200*1024=204800 files)*(1024000 bytes))/1048576)/1000)= ~200GB

If my understanding of the bonnie++ options, and my math, are correct,
you are attempting to write 200GB of 1MB files, in parallel, over NFS,
to a 90GB filesystem.  Adding insult to injury, you're mounting with
inode32, causing allocation to serialize on AG0, which will cause head
thrashing when alternating between writing directory information and
file extents.

So, first and foremost, you're attempting to write twice as many bytes
as the filesystem can hold.  You're then hamstringing the filesystem's
ability to allocate in parallel.  Inode64 would be a better choice here.
 You didn't describe the underlying storage hardware, which will likely
have a role to play in the 120 second blocking and the unresponsiveness,
or "hang" as you describe it.

In summary, you're intentionally writing twice the bytes of the FS
capacity.  Processes block due to latency, and the FS hangs.

What result were you expecting to see as a result of trying to
intentionally break things?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
