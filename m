Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5QLqRCP229317 for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 16:52:27 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF45912FB8A0
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2009 14:52:56 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id y6EP1kZCHKKisHb5 for
	<xfs@oss.sgi.com>; Fri, 26 Jun 2009 14:52:56 -0700 (PDT)
Message-ID: <4A454337.6030100@sandeen.net>
Date: Fri, 26 Jun 2009 16:52:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corrupt file system -- "Structure needs cleaning"
References: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>	<4A452CF7.3040807@sandeen.net>
	<20090626212611.GI29416@mail.physik.uni-wuppertal.de>
In-Reply-To: <20090626212611.GI29416@mail.physik.uni-wuppertal.de>
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
To: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Cc: xfs@oss.sgi.com

Hendrik Hoeth wrote:
> Thus spake Eric Sandeen (sandeen@sandeen.net):
> 
>>> [14:44] root@jetway:/var/log # xfs_check /dev/mapper/hda_crypt_vg-home
>> xfs_check doesn't actually fix anything; I'd run xfs_repair.  Use -n
>> first if you want to see what it would do.
> 
> I thought that if xfs_check doesn't show any errors, the filesystem is
> fine and doesn't need an xfs_repair. Is that wrong?

Well, yes, I suppose that's true.

I almost never use xfs_check mostly because it's a memory hog, still,
and xfs_repair checks almost everything that xfs_check does (and what
isn't checked is rebuilt anyway)

> Anyway xfs_repair looks healthy to me:

good news, I guess :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
