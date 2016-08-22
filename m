Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A209B7CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 19:45:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6437D8F8033
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 17:45:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IgizKxnZdvUWCZei for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 17:45:17 -0700 (PDT)
Subject: Re: [PATCH V5] xfs_db: add crc manipulation commands
References: <8cb34b7c-5154-ebb4-7706-1375e94abd74@redhat.com>
	<0bb88897-3dfc-de4e-05fb-b737221f0d80@sandeen.net>
	<20160822003800.GN19025@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9bee7dc5-f53f-5a86-9972-3a53fb4aac90@sandeen.net>
Date: Sun, 21 Aug 2016 19:45:16 -0500
MIME-Version: 1.0
In-Reply-To: <20160822003800.GN19025@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 8/21/16 7:38 PM, Dave Chinner wrote:
...

> io.c: In function =BFwrite_cur=BF:
> io.c:500:13: warning: variable =BFino=BF set but not used [-Wunused-but-s=
et-variable]
>    xfs_ino_t ino;
> =

> I've just removed the unused xfs_ino_t here, because it doesn't seem
> to have any purpose here.

Thanks - yeah I just saw that as well, sorry for missing it
the first go-round.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
