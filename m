Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7223D7FAE
	for <xfs@oss.sgi.com>; Sun, 17 Mar 2013 00:26:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5374F304059
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 22:26:33 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id OAYayaryW5D633bA
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 22:26:32 -0700 (PDT)
Message-ID: <51455408.4070801@hardwarefreak.com>
Date: Sun, 17 Mar 2013 00:26:32 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
In-Reply-To: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
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

On 3/16/2013 10:56 AM, Subranshu Patel wrote:

> This is not observed in EXT4, fsck successfully recovers without
> mounting the filesystem.

And this is the real problem.  You're *assuming* XFS should behave in
the same manner as EXT4.  Why would you assume a Ferrari should behave
like a Tata Nano?

XFS is far more sophisticated than EXT4 in many, many ways, including
recovery after unclean shutdown.  XFS kernel code performs journal
playback/recovery automatically when the filesystem is mounted.
xfs_repair is a tool for fixing filesystems that are broken, not simply
in need of journal playback.  Thus xfs_repair has no code to perform
journal recovery.

EXT4 (and EXT3) lacks this sophistication and must call a user space
tool, e2fsck, to perform journal playback/recovery.

XFS is the Ferrari of Linux filesystems and EXT is the Tata.  Keep that
in mind as you discover many of the other differences in the future.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
