Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39DE47F58
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 23:02:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 245518F8035
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 21:02:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Fegt7oWQVn9ld2Ei for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 21:02:41 -0700 (PDT)
Message-ID: <5147E360.10605@sandeen.net>
Date: Mon, 18 Mar 2013 23:02:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs_repair and journalling
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<51455408.4070801@hardwarefreak.com>
	<CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
In-Reply-To: <CAEUQceie41dh7h6uZSMu4-JB_BDu82X5CrKxHb=9wVQVAPzKgQ@mail.gmail.com>
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
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On 3/17/13 6:42 AM, Subranshu Patel wrote:
> 
> In case of EXT4, journal will not be replayed on performing mount.
> One need to invoke fsck which performs journal playback and then
> other corruption checks/recovery. Correct me if I am wrong.

You are wrong, I'm afraid.

Simple tests, or reading the code, will show you that ext4
replays a dirty log at mount time.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
