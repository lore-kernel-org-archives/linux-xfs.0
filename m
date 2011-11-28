Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASDtKIA237212 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 07:55:20 -0600
Received: from campbell-lange.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 652164FB24B
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 05:55:19 -0800 (PST)
Received: from campbell-lange.net (campbell-lange.net [93.191.37.68]) by
	cuda.sgi.com with ESMTP id DBDUzb48tkIwlB55 for
	<xfs@oss.sgi.com>; Mon, 28 Nov 2011 05:55:19 -0800 (PST)
Date: Mon, 28 Nov 2011 13:55:18 +0000
From: Jon Marshall <jon@campbell-lange.net>
Subject: XFS on CoRAID errors with SMB
Message-ID: <20111128135518.GA1232@campbell-lange.net>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: Rory Campbell-Lange <rory@campbell-lange.net>, support@campbell-lange.net

Hi,

We have recently experienced what appear to be XFS filesystem errors on
a samba share. The actual filesystem resides on a network attached
storage device, a Coraid. The attached server locked up totally, and we
forced to hard reset it.

I have the following trace from the kernel logs:

[6128798.051868] smbd: page allocation failure. order:4, mode:0xc0d0
[6128798.051872] Pid: 16908, comm: smbd Not tainted 2.6.32-5-amd64 #1
[6128798.051874] Call Trace:
[6128798.051882]  [<ffffffff810ba5d6>] ? __alloc_pages_nodemask+0x592/0x5f4
[6128798.051885]  [<ffffffff810b959c>] ? __get_free_pages+0x9/0x46
[6128798.051889]  [<ffffffff810e7ea1>] ? __kmalloc+0x3f/0x141
[6128798.051893]  [<ffffffff8110672c>] ? getxattr+0x89/0x117
[6128798.051896]  [<ffffffff810e5b65>] ? virt_to_head_page+0x9/0x2a
[6128798.051899]  [<ffffffff810f9bc4>] ? user_path_at+0x52/0x79
[6128798.051919]  [<ffffffffa0297b17>] ? xfs_xattr_put_listent+0x0/0xe5 [xfs]
[6128798.051922]  [<ffffffff810e5b65>] ? virt_to_head_page+0x9/0x2a
[6128798.051925]  [<ffffffff8118ddcb>] ? _atomic_dec_and_lock+0x33/0x50
[6128798.051928]  [<ffffffff811068b4>] ? sys_getxattr+0x45/0x60
[6128798.051931]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

smbd seems to throw these errors for about 15 minutes, then sshd starts
throwing errors and shortly after the system became unresponsive.

Just wondering if anyone had any experience of similar results, with XFS
on a CoRAID device or XFS SMB shares?

Thanks
Jon

-- 
Jon Marshall
Technical Officer
jon@campbell-lange.net
.
Campbell-Lange Workshop
www.campbell-lange.net
0207 6311 555
3 Tottenham Street London W1T 2AF
Registered in England No. 04551928

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
