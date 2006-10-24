Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 09:52:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OGqHaG029961
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 09:52:18 -0700
Received: from postal1.et.byu.edu (postal1.et.byu.edu [128.187.48.11])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F4064D19FA
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 08:48:14 -0700 (PDT)
Date: Tue, 24 Oct 2006 09:48:07 -0600 (MDT)
From: David Dougall <davidd@et.byu.edu>
Subject: kernel panic after upgrading to 2.6
Message-ID: <Pine.LNX.4.58.0610240938400.8370@lewis.et.byu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nfs@lists.sourceforge.net, xfs@oss.sgi.com

I am running kernel 2.6.18 after trying 2.6.17.6 and 2.6.17.13 with
similar results.  I continue to have nfs servers kernel panic on a very
regular basis, every few days.  Sometimes I need to do an xfs_repair to
get the filesystem to remount.  I got the following kernel panic message
from the syslog this time:
Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
nfs09 kernel: Oops: 0000 [#1]

Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
nfs09 kernel: CPU:    0

Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
nfs09 kernel: EIP is at xfs_alloc_fix_freelist+0x20/0x486

Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
nfs09 kernel: eax: f7dbb000   ebx: 0009a000   ecx: 00000016   edx:
f8cc8c20

Message from syslogd@nfs09 at Tue Oct 24 09:35:14 2006 ...
nfs09 kernel: esi: 00000016   edi: edab7c90   ebp: d8fd8b64   esp:
edab7bd0

Message from syslogd@nfs09 at Tue Oct 24 09:35:15 2006 ...
nfs09 kernel: ds: 007b   es: 007b   ss: 0068

Message from syslogd@nfs09 at Tue Oct 24 09:35:15 2006 ...
nfs09 kernel: Process nfsd (pid: 4837, ti=edab6000 task=eda8f030
task.ti=edab6000)

Message from syslogd@nfs09 at Tue Oct 24 09:35:15 2006 ...
nfs09 kernel: Stack: 00000000 00001a9a 00000009 00000200 00000002 c026fffe
f0995b80 f7dbb000

Message from syslogd@nfs09 at Tue Oct 24 09:35:15 2006 ...
nfs09 kernel:        d8fd8b64 f8cc8c20 c0225507 fffffffe 00000000 0000000b
00000000 00000000

Message from syslogd@nfs09 at Tue Oct 24 09:35:15 2006 ...
nfs09 kernel:        d8fd8b64 f7dbb000 c0226fef 00000001 00000001 00000000
00000000 0000000b

Message from syslogd@nfs09 at Tue Oct 24 09:35:15 2006 ...
nfs09 kernel: Call Trace:

Message from syslogd@nfs09 at Tue Oct 24 09:35:16 2006 ...
nfs09 kernel: Code: 24 04 46 06 00 00 e9 9f fe ff ff 55 57 56 53 81 ec 8c
00 00 00 89 c7 89 54 24 10 8b 40 04 89 44 24 1c 8b 57 0c 89 54 24 24 8b 2f
<80> 3a 00 0f 84 e7 02 00 00 c7 84 24 88 00 00 00 00 00 00 00 8b

Message from syslogd@nfs09 at Tue Oct 24 09:35:16 2006 ...
nfs09 kernel: EIP: [<c022742e>] xfs_alloc_fix_freelist+0x20/0x486 SS:ESP
0068:edab7bd0



I am guessing this is an xfs bug, but I am not sure.  Would anybody please
confirm this form me.
I am running nfs-utils-1.0.9 and xfsprogs 2.8.10.
If there is any more information you need, please let me know.
Please advise.
--David Dougall
