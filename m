Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAB527F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 12:10:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA282304043
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 10:10:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id nB69M0xW1Gma8Oww for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 10:10:08 -0700 (PDT)
Message-ID: <5579C0EE.1050503@sandeen.net>
Date: Thu, 11 Jun 2015 12:10:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
References: <5579296A.8010208@skylable.com>	<20150611151620.GB59168@bfoster.bfoster>	<5579A904.3020204@skylable.com>	<5579AE85.5080203@sandeen.net>
	<5579B034.4070503@sandeen.net> <5579B804.9050707@skylable.com>
In-Reply-To: <5579B804.9050707@skylable.com>
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
To: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwin@skylable.com>, Brian Foster <bfoster@redhat.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On 6/11/15 11:32 AM, T=F6r=F6k Edwin wrote:
> # cp /tmp/xfs2.test /tmp/xfs2.test.orig
> # umount /export/dfs
> # mount -o loop -t xfs /tmp/xfs2.test /export/dfs
> # mkdir /export/dfs/a
> # sxadm node --new --batch /export/dfs/a/b
> # ls /export/dfs/a/b
> ls: reading directory /export/dfs/a/b: Structure needs cleaning
> # umount /export/dfs
> # cp /tmp/xfs2.test /tmp/xfs2.test.corrupted
> # dmesg >/tmp/dmesg
> # exit

Thanks.  Out of curiosity, if you now do:

# mount -o loop -t xfs /tmp/xfs2.test /export/dfs
# ls /export/dfs/a/b

do you still get the failure?  i.e. is it persistent on disk, still there a=
fter a remount, or is it perhaps only in memory?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
