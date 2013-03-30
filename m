Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 80B077F95
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 07:50:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5DD4C304071
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 05:50:13 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CMU3Lru9QNfeoJOv
	for <xfs@oss.sgi.com>; Sat, 30 Mar 2013 05:49:54 -0700 (PDT)
Message-ID: <5156DF72.1090703@hardwarefreak.com>
Date: Sat, 30 Mar 2013 07:49:54 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling  --  EXT4 journal replay discussion
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	(sfid-20130319_091205_759083_BA6F1AD2)
	<201303190924.29362.Martin@lichtvoll.de>
	<51483A7D.9050202@hardwarefreak.com>
In-Reply-To: <51483A7D.9050202@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

On 3/19/2013 5:14 AM, Stan Hoeppner wrote:
> On 3/19/2013 3:24 AM, Martin Steigerwald wrote:
...
>> Heck, even I was confused at first. Cause the manpage of fsck.ext4 IMHO is 
>> not really clear about that topic to say the least. I tested it out for a 
>> reason.
> 
> I already contacted Ted off list hoping he can point me to the relevant
> kernel documentation, so I don't make such a mistake again with EXT.

Ok, so here's the skinny on the source of our confusion WRT how/when
EXT4 replays journals, and it's rather interesting.  Ted Ts'o explained
the following.

The EXT4 kernel module does have code to perform journal replay, but it
is rarely executed.  The reasons for this are:

1.  EXT4 journal replay can take a lot of time (whereas XFS is instant)
2.  EXT4 systems tend to have multiple filesystems, often one per drive
    (whereas XFS systems tend to have few filesystems)
3.  Linux mounts filesystems serially during startup

To prevent potentially lengthy boot times, the init scripts run e2fsck
to replay all EXT4 filesystem journals in parallel, well before the
mount stage.  Thus the only case where the EXT4 kernel module performs
journal replay is when doing a mount while the system is running, e.g.
USB hard drive.

There are other reasons e2fsck was chosen to perform journal replay at
boot in addition to the speed issue, but as I understood Ted this is the
main reason.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
