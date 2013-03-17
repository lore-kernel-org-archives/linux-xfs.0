Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 59D9D7F73
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 09:50:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EABECAC003
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 07:50:35 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id M2ohOOWvUqFEKF5r
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 07:50:31 -0700 (PDT)
Message-ID: <5145D838.8050003@hardwarefreak.com>
Date: Sun, 17 Mar 2013 09:50:32 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
In-Reply-To: <CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
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
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: xfs@oss.sgi.com

On 3/17/2013 6:42 AM, Subranshu Patel wrote:
> What I understand is that, XFS being a journalling filesystem makes running
> xfs_repair after a unclean unmount unnecessary.
>
> After a system crash or force power down, one can mount the filesystem
> which causes the journal to be replayed and handles the half finished
> writes. This is one part. But there can be other file corruption as well
> and these can be handled by xfs_repair.
> So the crux is to mount the filesystem so that journal will be replayed,
> and then unmount the filesystem and run xfs_repair. (Assuming xfs_repair
> may not be a mandatory step always)
> 
> In case of EXT4, journal will not be replayed on performing mount. One need
> to invoke fsck which performs journal playback and then other corruption
> checks/recovery.
> Correct me if I am wrong.

Enough with the foreplay.  Get to your point please.  I'm assuming you
think you have an exception, a bug, to report.

-- 
Stan


> 
> On Sun, Mar 17, 2013 at 10:56 AM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
>>
>> On 3/16/2013 10:56 AM, Subranshu Patel wrote:
>>
>>> This is not observed in EXT4, fsck successfully recovers without
>>> mounting the filesystem.
>>
>> And this is the real problem.  You're *assuming* XFS should behave in
>> the same manner as EXT4.  Why would you assume a Ferrari should behave
>> like a Tata Nano?
>>
>> XFS is far more sophisticated than EXT4 in many, many ways, including
>> recovery after unclean shutdown.  XFS kernel code performs journal
>> playback/recovery automatically when the filesystem is mounted.
>> xfs_repair is a tool for fixing filesystems that are broken, not simply
>> in need of journal playback.  Thus xfs_repair has no code to perform
>> journal recovery.
>>
>> EXT4 (and EXT3) lacks this sophistication and must call a user space
>> tool, e2fsck, to perform journal playback/recovery.
>>
>> XFS is the Ferrari of Linux filesystems and EXT is the Tata.  Keep that
>> in mind as you discover many of the other differences in the future.
>>
>> --
>> Stan
>>
> 
> 
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
