Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 055707F37
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2016 09:15:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E875A8F8039
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2016 07:15:12 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id W1tTqNAhXhG2nbHz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 24 Jan 2016 07:15:10 -0800 (PST)
Subject: Bug#766811: spurious library links
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.766811.B766811.14536483939559@bugs.debian.org>
Date: Sun, 24 Jan 2016 16:13:08 +0100
From: Jakub Wilk <jwilk@debian.org>
Message-ID: <20160124151308.GA7620@jwilk.net>
References: <20141026004825.GA27863@bongo.bofh.it>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141026004825.GA27863@bongo.bofh.it>
Reply-To: Jakub Wilk <jwilk@debian.org>, 766811@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 766811@bugs.debian.org
Cc: Marco d'Itri <md@linux.it>

Control: found -1 4.3.0

* Marco d'Itri <md@linux.it>, 2014-10-26, 02:48:
>These links do not appear to have any purpose and should be removed:
>
>/lib/libhandle.a -> /usr/lib/libhandle.a
>/lib/libhandle.la -> /usr/lib/libhandle.la
>/usr/lib/libhandle.so -> /lib/libhandle.so

I can still see them in the current version:

$ dpkg -c xfslibs-dev_4.3.0_amd64.deb | grep ^l.*/usr/lib/libhandle
lrwxrwxrwx root/root         0 2015-11-27 01:33 ./usr/lib/libhandle.so -> /lib/libhandle.so
lrwxrwxrwx root/root         0 2015-11-27 01:33 ./lib/libhandle.a -> /usr/lib/libhandle.a
lrwxrwxrwx root/root         0 2015-11-27 01:33 ./lib/libhandle.la -> /usr/lib/libhandle.la

-- 
Jakub Wilk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
