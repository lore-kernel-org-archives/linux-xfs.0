Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 93D207CA4
	for <xfs@oss.sgi.com>; Tue, 24 May 2016 07:58:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 59DAA8F804B
	for <xfs@oss.sgi.com>; Tue, 24 May 2016 05:58:56 -0700 (PDT)
Received: from mr003msb.fastweb.it (mr003msb.fastweb.it [85.18.95.87]) by
	cuda.sgi.com with ESMTP id qCFBUpkiR49VtEYq for
	<xfs@oss.sgi.com>; Tue, 24 May 2016 05:58:53 -0700 (PDT)
Received: from ceres.assyoma.it (93.63.55.57) by mr003msb.fastweb.it
	(8.5.140.04)
	id 572A172301273F91 for xfs@oss.sgi.com; Tue, 24 May 2016 14:58:52 +0200
Subject: LVM snapshot and log record CRC mismatch
MIME-Version: 1.0
Date: Tue, 24 May 2016 14:58:51 +0200
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
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
To: xfs@oss.sgi.com
Cc: g.danti@assyoma.it

Hi list,
I have a question about LVM snapshot and XFS.

Some preliminary information: CentOS Linux release 7.0.1406 (Core), with 
kernel version 3.10.0-123.20.1.el7.x86_64

Basically, each time I mount a LVM snapshot (with the "nouuid" option), 
I have the following dmesg entries:

[824501.391058] XFS (dm-7): Mounting Filesystem
[824502.085459] XFS (dm-7): Starting recovery (logdev: internal)
[824502.120435] XFS (dm-7): log record CRC mismatch: found 0x324293f8, 
expected 0x43a1b3b5.
[824502.121035] ffffc90018271000: 00 00 00 10 00 00 00 00 69 01 00 00 6d 
a0 9d a7  ........i...m...
[824502.121649] ffffc90018271010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 
00 00 00  ....i...NART*...
[824502.122403] XFS (dm-7): log record CRC mismatch: found 0x873f6b2, 
expected 0x49045c16.
[824502.122952] ffffc90018271000: 00 00 00 10 00 00 00 08 aa 20 00 00 6e 
55 00 00  ......... ..nU..
[824502.123508] ffffc90018271010: 00 00 00 00 69 00 00 00 4e 41 52 54 2a 
00 00 00  ....i...NART*...
[824502.124239] XFS (dm-7): log record CRC mismatch: found 0x2f6e47af, 
expected 0x7efb222.
[824502.124792] ffffc90018271000: 00 00 00 10 00 00 00 00 69 01 00 00 a7 
66 d7 2e  ........i....f..
[824502.125359] ffffc90018271010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 
00 00 00  ....i...NART*...
[824502.126173] XFS (dm-7): log record CRC mismatch: found 0x324293f8, 
expected 0x43a1b3b5.
[824502.126751] ffffc900182b2000: 00 00 00 10 00 00 00 00 69 01 00 00 6d 
a0 9d a7  ........i...m...
[824502.127332] ffffc900182b2010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 
00 00 00  ....i...NART*...
[824502.153510] XFS (dm-7): log record CRC mismatch: found 0x873f6b2, 
expected 0x49045c16.
[824502.154158] ffffc900182b2000: 00 00 00 10 00 00 00 08 aa 20 00 00 6e 
55 00 00  ......... ..nU..
[824502.154818] ffffc900182b2010: 00 00 00 00 69 00 00 00 4e 41 52 54 2a 
00 00 00  ....i...NART*...
[824502.155654] XFS (dm-7): log record CRC mismatch: found 0x2f6e47af, 
expected 0x7efb222.
[824502.156258] ffffc900182b2000: 00 00 00 10 00 00 00 00 69 01 00 00 a7 
66 d7 2e  ........i....f..
[824502.156869] ffffc900182b2010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 
00 00 00  ....i...NART*...
[824502.906702] XFS (dm-7): Ending recovery (logdev: internal)
[824502.906714] SELinux: initialized (dev dm-7, type xfs), uses xattr

 From my understanding, this should be more or less the expected 
behavior: the snapshot is a "crash consistent" backup point, and 
mounting the snapshotted filesystem can led to mismatched CRC. Anyway, I 
can read from the snapshot without problems.

However, issuing a xfs_info on the original volume shows that crc 
options is 0 (crc=0), so I am somewhat puzzled about the warning above. 
Moreover, on a more recent CentOS 7.2 server (kernel version 
3.10.0-327.13.1.el7.x86_64), I can not reproduce this warning.

So I ask:
1) it really is the expected behavior, or should I be worried by the 
dmesg entries?
2) this is kernel-related, should I update the kernel to newer version?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
