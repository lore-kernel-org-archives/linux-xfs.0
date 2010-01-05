Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o05HL0sn223501 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 11:21:00 -0600
Received: from radon.netxsys.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 665551C2EF2F
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 09:21:50 -0800 (PST)
Received: from radon.netxsys.com (radon.netxsys.com [204.16.202.162]) by
	cuda.sgi.com with ESMTP id bt7HiNfcJJ7nDTFX for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2010 09:21:50 -0800 (PST)
Message-ID: <43686.205.189.93.240.1262712109.squirrel@webmail.netxsys.com>
In-Reply-To: <4B437240.3030902@sandeen.net>
References: <1262652500.24160.27.camel@oxygen.netxsys.com>
	<4B437240.3030902@sandeen.net>
Date: Tue, 5 Jan 2010 12:21:49 -0500 (EST)
Subject: Re: NFS export broke with change from ext3 to xfs
From: "Krzysztof Adamski" <k@adamski.org>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> Krzysztof Adamski wrote:
>> Hi All,
>>
>> I just changed one filesystem on my mythbox from ext3 to xfs, and now I
>> can't get a client machine to NFS mount from it.
>>
>> This is the export file on the server:
>> /file-store/nfs-roots/f1/home
>> f1(rw,no_root_squash,sync,no_subtree_check)
>> /file-store/nfs-roots/f1/usr
>> f1(rw,no_root_squash,sync,no_subtree_check)
>> /file-store/nfs-roots/f1/var
>> f1(rw,no_root_squash,sync,no_subtree_check)
>>
>> and on the client(f1) the three filesystems are mount on /home, /usr,
>> and /var
>>
>> This worked fine when /file-store on the server was formatted with ext3,
>> now that it is formatted with xfs I get this message on the client:
>> mount.nfs: Stale NFS file handle
>> I get this message 3 times.
>
> I dunno, this should work.  Anything in either of the system logs?

On the server:
Jan  4 19:27:03 Myth mountd[5342]: authenticated mount request from
x.x.x.x:741 for /file-store/nfs-roots/f1/var
(/file-store/nfs-roots/f1/var)
Jan  4 19:27:03 Myth mountd[5342]: authenticated mount request from
x.x.x.x:757 for /file-store/nfs-roots/f1/usr
(/file-store/nfs-roots/f1/usr)
Jan  4 19:27:03 Myth mountd[5342]: authenticated mount request from
x.x.x.x:759 for /file-store/nfs-roots/f1/home
(/file-store/nfs-roots/f1/home)
but this is identical to when it worked.
No logs on the client, /var is not yet mounted.

Should I be asking on the NFS list?


> -Eric
>
>> Nothing else changed, both systems are Debian Lenny with custom kernel.
>> Server is 2.6.28, client is 2.6.29.6. NFS is version 3.
>> The fstab on the server has this:
>> /dev/mapper/big--raid-file--store       /file-store     xfs
>> noatime,logbsize=256k,inode64   0       1
>>
>> The reason for the change of the filesystem was an upgrade of the drives
>> in the RAID, now the filesystem is 7T instead of 2.4T,
>> nothing else was changed. Why did this work with ext3 and does not with
>> XFS? What can I do to get this to work, short of reverting to ext3?
>>
>> K
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
