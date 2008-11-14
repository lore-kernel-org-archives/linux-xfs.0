Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAE8tO6S008651 for <xfs@oss.sgi.com>; Fri, 14 Nov 2008 00:55:25 -0800
Received: from smtp5.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BB0B15699E3
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2008 00:55:24 -0800 (PST)
Received: from smtp5.poczta.onet.pl (smtp5.poczta.onet.pl [213.180.130.32]) by
	cuda.sgi.com with ESMTP id AZWtmBKdnsfxXcUd for
	<xfs@oss.sgi.com>; Fri, 14 Nov 2008 00:55:24 -0800 (PST)
Received: from ip-83-238-22-2.netia.com.pl ([83.238.22.2]:34981 "EHLO
	[192.168.242.3]" rhost-flags-OK-FAIL-OK-FAIL) by ps5.test.onet.pl
	with ESMTPA id S251765163AbYKNIt5EcLVy (ORCPT
	<rfc822;xfs@oss.sgi.com>); Fri, 14 Nov 2008 09:49:57 +0100
Message-ID: <491D3BAB.2090207@poczta.onet.pl>
Date: Fri, 14 Nov 2008 09:49:47 +0100
From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
MIME-Version: 1.0
Subject: Re: [xfs] Calltrace in 2.6.27 kernel]
References: <491C9687.6040305@poczta.onet.pl>
In-Reply-To: <491C9687.6040305@poczta.onet.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: hch@infradead.org
Cc: xfs@oss.sgi.com

Hi

I ran addr2line for both vmlinux and for first call trace (2.6.27)
add2line returned:

addr2line -e ./vmlinux c029553d
fs/xfs/xfs_log.c:3528

in source:

        /*
         * If this happens during log recovery, don't worry about
         * locking; the log isn't open for business yet.
         */
        if (!log ||
            log->l_flags & XLOG_ACTIVE_RECOVERY) {
                mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
                XFS_BUF_DONE(mp->m_sb_bp);                            
//3528 line
                return 0;
        }



and for second call trace (2.6.27.5 + patch for XFS from 2.6.28rc)
add2line returned:

addr2line -e ./vmlinux c029571d
fs/xfs/xfs_log.c:3561


in source:

         /*
         * If this happens during log recovery, don't worry about
         * locking; the log isn't open for business yet.
         */
        if (!log ||
            log->l_flags & XLOG_ACTIVE_RECOVERY) {
                mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
                XFS_BUF_DONE(mp->m_sb_bp);                        //3561
line
                return 0;
        }


>
> On Thu, Nov 13, 2008 at 03:22:58PM +0100, aluno3@poczta.onet.pl wrote:
>   
>> Hi
>>
>> I tested kernel 2.6.27 with stress test using fsstress,dd,LVM and
>> snapshots. After a few hours and overflow of snapshot I got call trace:
>>
>> device-mapper: snapshots: Invalidating snapshot: Unable to allocate
>> exception.
>>     
>
> This is a message from device mapper telling your that it got an EIO
> in pending_complete()
>
>   
>> I/O error in filesystem ("dm-49") meta-data dev dm-49 block
>> 0x1d4c3b0       ("xlog_recover_do..(read#2)")
>>  error 5 buf count 8192
>> XFS: log mount/recovery failed: error 5
>> XFS: log mount failed
>>     
>
> And now XFS complains that it got this error passed up, so far so good.
>
>   
>> BUG: unable to handle kernel NULL pointer dereference at 0000002c
>> IP: [<c029553d>] xfs_log_force_umount+0x3d/0x170
>> *pdpt = 00000000345cf001 *pde = 0000000000000000
>>     
>
> But ut should not crash.  Can you run 
>
> 	addr2line -e /path/to/your/kernel xfs_log_force_umount+0x3d/0x170
>
> (you'll need a kernel with debuginfo for that)
>
>
>   

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
