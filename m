Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5NMp7Fs050855 for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 17:51:07 -0500
Received: from mail-bw0-f228.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6524B128876D
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 15:59:55 -0700 (PDT)
Received: from mail-bw0-f228.google.com (mail-bw0-f228.google.com
	[209.85.218.228]) by cuda.sgi.com with ESMTP id
	1jeAqlzYw0xQQvK9 for <xfs@oss.sgi.com>;
	Tue, 23 Jun 2009 15:59:55 -0700 (PDT)
Received: by bwz28 with SMTP id 28so122627bwz.20
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2009 15:51:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <961884583.292281245481464174.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
References: <941396568.292261245481145500.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<961884583.292281245481464174.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Date: Wed, 24 Jun 2009 02:51:32 +0400
Message-ID: <a4423d670906231551r452b0df2g9749cbd96cc6081f@mail.gmail.com>
Subject: Re: 2.6.30-06725: xfs_fsr: Assertion failed: ip->i_delayed_blks == 0,
	file: fs/xfs/xfs_bmap.c, line: 5991
From: Alexander Beregalov <a.beregalov@gmail.com>
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
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: xfs@oss.sgi.com

2009/6/20 Lachlan McIlroy <lmcilroy@redhat.com>:
> Hi Alexander,
>
> I've seen this assertion before and if it's the problem I think it
> is then it should be fixed with this patch:
>
> http://oss.sgi.com/archives/xfs/2009-02/msg00176.html
>
> It shouldn't be difficult to test this too - If you run about 1024
> dd writers to separate 100MB files and then run xfs_bmap on each
> file afterwards it should assert.
>
Still the same problem with this patch, it does not work for me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
