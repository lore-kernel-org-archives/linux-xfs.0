Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 332587F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 12:13:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 141768F8065
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 10:13:51 -0700 (PDT)
Received: from zimbra.skylable.com (zimbra.skylable.com [5.35.252.9]) by
	cuda.sgi.com with ESMTP id D9WpVAAWlyONBRDr for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2015 10:13:45 -0700 (PDT)
Message-ID: <5579C1C7.6050109@skylable.com>
Date: Thu, 11 Jun 2015 20:13:43 +0300
From: =?windows-1252?Q?T=F6r=F6k_Edwin?= <edwin@skylable.com>
MIME-Version: 1.0
Subject: Re: PROBLEM: XFS on ARM corruption 'Structure needs cleaning'
References: <5579296A.8010208@skylable.com>	<20150611151620.GB59168@bfoster.bfoster>	<5579A904.3020204@skylable.com>	<5579AE85.5080203@sandeen.net>
	<5579B034.4070503@sandeen.net> <5579B804.9050707@skylable.com>
	<5579C0EE.1050503@sandeen.net>
In-Reply-To: <5579C0EE.1050503@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Brian Foster <bfoster@redhat.com>
Cc: Christopher Squires <christopher.squires@hgst.com>, Wayne Burri <wayne.burri@hgst.com>, Luca Gibelli <luca@skylable.com>, xfs@oss.sgi.com

On 06/11/2015 08:10 PM, Eric Sandeen wrote:
> On 6/11/15 11:32 AM, T=F6r=F6k Edwin wrote:
>> # cp /tmp/xfs2.test /tmp/xfs2.test.orig
>> # umount /export/dfs
>> # mount -o loop -t xfs /tmp/xfs2.test /export/dfs
>> # mkdir /export/dfs/a
>> # sxadm node --new --batch /export/dfs/a/b
>> # ls /export/dfs/a/b
>> ls: reading directory /export/dfs/a/b: Structure needs cleaning
>> # umount /export/dfs
>> # cp /tmp/xfs2.test /tmp/xfs2.test.corrupted
>> # dmesg >/tmp/dmesg
>> # exit
> =

> Thanks.  Out of curiosity, if you now do:
> =

> # mount -o loop -t xfs /tmp/xfs2.test /export/dfs
> # ls /export/dfs/a/b

I get 'Structure needs cleaning' again.

> =

> do you still get the failure?  i.e. is it persistent on disk, still there=
 after a remount,

It is persistent. I tried remounting, or unmount + xfs_repair + remount, or=
 rm -rf /export/dfs/a, but once its corrupted it stays like that.

Best regards,
--Edwin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
