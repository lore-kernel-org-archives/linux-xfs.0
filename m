Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6RBeQC5094166 for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 06:40:27 -0500
Received: from mail.reagi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5CE5388972
	for <xfs@oss.sgi.com>; Mon, 27 Jul 2009 04:41:09 -0700 (PDT)
Received: from mail.reagi.com (mail.reagi.com [195.60.188.80]) by cuda.sgi.com
	with ESMTP id cV4HC4U9yUkh5jx8 for <xfs@oss.sgi.com>;
	Mon, 27 Jul 2009 04:41:09 -0700 (PDT)
Message-ID: <4A6D9221.5080603@oxeva.fr>
Date: Mon, 27 Jul 2009 13:40:17 +0200
From: Gabriel Barazer <gabriel@oxeva.fr>
MIME-Version: 1.0
Subject: Re: XFS filesystem shutting down on linux 2.6.28.9 (xfs_rename)
References: <000c01ca0ae0$e85420a0$b8fc61e0$@fr> <4A67E2F5.2030400@sandeen.net>
In-Reply-To: <4A67E2F5.2030400@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Gabriel Barazer wrote:
>   
>> Hi,
>>
>> I recently put a NFS file server into production, with mostly XFS volumes on LVM. The server was quite low on traffic until this morning and one of the filesystems crashed twice since this morning with the following backtrace:
>>
>> Filesystem "dm-24": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811b09a7
>> Pid: 2053, comm: nfsd Not tainted 2.6.28.9-filer #1
>> Call Trace:
>>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
>>  [<ffffffff811b1806>] xfs_trans_cancel+0x56/0xed
>>  [<ffffffff811b09a7>] xfs_rename+0x4a1/0x4f6
>>     
> ...
>
>   
>> xfs_force_shutdown(dm-24,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff811b181f
>> Filesystem "dm-24": Corruption of in-memory data detected.  Shutting down filesystem: dm-24
>>
>> The two crashed are related to the same function: xfs_rename.
>>     
>
> Can you do objdump -d xfs.ko | grep "xfs_rename\|xfs_trans_cancel" and
> maybe we can see which call to xfs_trans_cancel in xfs_rename this was.
>
> The problem relates to canceling a dirty transaction on an error path.
>   
Hi,

sorry for the late reply

I don't have any xfs.ko as my kernel is compiled without CONFIG_MODULES. 
However I objdump'd the vmlinux uncompressed kernel, and here are the 
results:

ffffffff8116dcb8:       e8 f3 3a 04 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8116f61b:       e8 90 21 04 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8116f68f:       e8 1c 21 04 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8116fbaa:       e8 01 1c 04 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8116fbee:       e8 bd 1b 04 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117073c:       e8 6f 10 04 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117261b:       e8 90 f1 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff81174dde:       e8 cd c9 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff81175303:       e8 a8 c4 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117c08a:       e8 21 57 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117c146:       e8 65 56 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117cf06:       e8 a5 48 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117d000:       e8 ab 47 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117dd83:       e8 28 3a 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8117dfa3:       e8 08 38 03 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811845fa:       e8 b1 d1 02 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff81184929:       e8 82 ce 02 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>

ffffffff81199b89:       e9 22 7c 01 00          jmpq   ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff8119aa30:       e8 7b 6d 01 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a46d1:       e8 da d0 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a4813:       e8 98 cf 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a4929:       e8 82 ce 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a4b8a:       e8 21 cc 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a4e8b:       e8 20 c9 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a509e:       e8 0d c7 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a6bf7:       e8 b4 ab 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811a6c86:       e8 25 ab 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811aa18a:       e8 21 76 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811abe18:       e8 93 59 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811aeb5c:       e8 4f 2c 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811aecf9:       e8 b2 2a 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b04ca <xfs_rename_unlock4>:
ffffffff811b04e6:       74 19                   je     ffffffff811b0501 
<xfs_rename_unlock4+0x37>
ffffffff811b04ed:       74 08                   je     ffffffff811b04f7 
<xfs_rename_unlock4+0x2d>
ffffffff811b04ff:       75 dd                   jne    ffffffff811b04de 
<xfs_rename_unlock4+0x14>
ffffffff811b0506 <xfs_rename>:
ffffffff811b0563:       74 21                   je     ffffffff811b0586 
<xfs_rename+0x80>
ffffffff811b0568:       75 1c                   jne    ffffffff811b0586 
<xfs_rename+0x80>
ffffffff811b056f:       74 15                   je     ffffffff811b0586 
<xfs_rename+0x80>
ffffffff811b0580:       0f 87 38 04 00 00       ja     ffffffff811b09be 
<xfs_rename+0x4b8>
ffffffff811b0628:       75 23                   jne    ffffffff811b064d 
<xfs_rename+0x147>
ffffffff811b064f:       74 04                   je     ffffffff811b0655 
<xfs_rename+0x14f>
ffffffff811b0653:       eb 18                   jmp    ffffffff811b066d 
<xfs_rename+0x167>
ffffffff811b0666:       74 13                   je     ffffffff811b067b 
<xfs_rename+0x175>
ffffffff811b0676:       e9 27 03 00 00          jmpq   ffffffff811b09a2 
<xfs_rename+0x49c>
ffffffff811b0695:       74 39                   je     ffffffff811b06d0 
<xfs_rename+0x1ca>
ffffffff811b06a6:       74 28                   je     ffffffff811b06d0 
<xfs_rename+0x1ca>
ffffffff811b06b2:       e8 13 fe ff ff          callq  ffffffff811b04ca 
<xfs_rename_unlock4>
ffffffff811b06c1:       e8 ea 10 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b06cb:       e9 ee 02 00 00          jmpq   ffffffff811b09be 
<xfs_rename+0x4b8>
ffffffff811b06ef:       74 1a                   je     ffffffff811b070b 
<xfs_rename+0x205>
ffffffff811b0729:       74 37                   je     ffffffff811b0762 
<xfs_rename+0x25c>
ffffffff811b0757:       0f 85 ab 00 00 00       jne    ffffffff811b0808 
<xfs_rename+0x302>
ffffffff811b075d:       e9 88 00 00 00          jmpq   ffffffff811b07ea 
<xfs_rename+0x2e4>
ffffffff811b0779:       0f 85 51 02 00 00       jne    ffffffff811b09d0 
<xfs_rename+0x4ca>
ffffffff811b07a7:       0f 84 23 02 00 00       je     ffffffff811b09d0 
<xfs_rename+0x4ca>
ffffffff811b07af:       0f 85 2e 02 00 00       jne    ffffffff811b09e3 
<xfs_rename+0x4dd>
ffffffff811b07c7:       0f 84 a6 00 00 00       je     ffffffff811b0873 
<xfs_rename+0x36d>
ffffffff811b07d2:       0f 84 9b 00 00 00       je     ffffffff811b0873 
<xfs_rename+0x36d>
ffffffff811b07e5:       e9 81 00 00 00          jmpq   ffffffff811b086b 
<xfs_rename+0x365>
ffffffff811b07f4:       0f 84 dd 01 00 00       je     ffffffff811b09d7 
<xfs_rename+0x4d1>
ffffffff811b0802:       0f 87 cf 01 00 00       ja     ffffffff811b09d7 
<xfs_rename+0x4d1>
ffffffff811b082f:       0f 85 ae 01 00 00       jne    ffffffff811b09e3 
<xfs_rename+0x4dd>
ffffffff811b0851:       0f 85 8c 01 00 00       jne    ffffffff811b09e3 
<xfs_rename+0x4dd>
ffffffff811b085c:       74 15                   je     ffffffff811b0873 
<xfs_rename+0x36d>
ffffffff811b086d:       0f 85 70 01 00 00       jne    ffffffff811b09e3 
<xfs_rename+0x4dd>
ffffffff811b087d:       74 35                   je     ffffffff811b08b4 
<xfs_rename+0x3ae>
ffffffff811b0884:       74 2e                   je     ffffffff811b08b4 
<xfs_rename+0x3ae>
ffffffff811b08ae:       0f 85 2f 01 00 00       jne    ffffffff811b09e3 
<xfs_rename+0x4dd>
ffffffff811b08c6:       74 21                   je     ffffffff811b08e9 
<xfs_rename+0x3e3>
ffffffff811b08cb:       75 07                   jne    ffffffff811b08d4 
<xfs_rename+0x3ce>
ffffffff811b08d2:       74 15                   je     ffffffff811b08e9 
<xfs_rename+0x3e3>
ffffffff811b08e3:       0f 85 fa 00 00 00       jne    ffffffff811b09e3 
<xfs_rename+0x4dd>
ffffffff811b0910:       0f 85 cd 00 00 00       jne    ffffffff811b09e3 
<xfs_rename+0x4dd>
ffffffff811b0941:       74 18                   je     ffffffff811b095b 
<xfs_rename+0x455>
ffffffff811b0966:       74 09                   je     ffffffff811b0971 
<xfs_rename+0x46b>
ffffffff811b098a:       74 21                   je     ffffffff811b09ad 
<xfs_rename+0x4a7>
ffffffff811b09a2:       e8 09 0e 00 00          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b09ab:       eb 11                   jmp    ffffffff811b09be 
<xfs_rename+0x4b8>
ffffffff811b09d5:       eb 11                   jmp    ffffffff811b09e8 
<xfs_rename+0x4e2>
ffffffff811b09e1:       eb 05                   jmp    ffffffff811b09e8 
<xfs_rename+0x4e2>
ffffffff811b09f8:       eb a3                   jmp    ffffffff811b099d 
<xfs_rename+0x497>
ffffffff811b17b0 <xfs_trans_cancel>:
ffffffff811b17c1:       74 0c                   je     ffffffff811b17cf 
<xfs_trans_cancel+0x1f>
ffffffff811b17d3:       74 4a                   je     ffffffff811b181f 
<xfs_trans_cancel+0x6f>
ffffffff811b17de:       75 3f                   jne    ffffffff811b181f 
<xfs_trans_cancel+0x6f>
ffffffff811b1839:       74 06                   je     ffffffff811b1841 
<xfs_trans_cancel+0x91>
ffffffff811b1848:       74 12                   je     ffffffff811b185c 
<xfs_trans_cancel+0xac>
ffffffff811b3bb7:       e8 f4 db ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b3c32:       e8 79 db ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b4753:       e8 58 d0 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b53e9:       e8 c2 c3 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b5497:       e8 14 c3 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b5baa:       e8 01 bc ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b5f40:       e8 6b b8 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6000:       e8 ab b7 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6458:       e8 53 b3 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6730:       e8 7b b0 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6a58:       e8 53 ad ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6c5c:       e8 4f ab ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6c95:       e8 16 ab ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6cf7:       e8 b4 aa ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b6d83:       e8 28 aa ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b706b:       e8 40 a7 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b715b:       e8 50 a6 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b7305:       e8 a6 a4 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b7372:       e8 39 a4 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b7407:       e8 a4 a3 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b74e5:       e8 c6 a2 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b77a9:       e8 02 a0 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b7f94:       e8 17 98 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b83e8:       e8 c3 93 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b866b:       e8 40 91 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b8838:       e8 73 8f ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b8bb0:       e8 fb 8b ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b8d2c:       e8 7f 8a ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b8f17:       e8 94 88 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b9463:       e8 48 83 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b950f:       e8 9c 82 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811b9677:       e8 34 81 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811be2af:       e8 fc 34 ff ff          callq  ffffffff811b17b0 
<xfs_trans_cancel>
ffffffff811bfacc:       e8 35 0a ff ff          callq  ffffffff811b0506 
<xfs_rename>


Gabriel

> -Eric
>
>   
>> I _really_ cannot upgrade to 2.6.29 or later because of the "reconnect_path: npd != pd" bug and the maybe related radix-tree bug ( http://bugzilla.kernel.org/show_bug.cgi?id=13375 ) affecting all kernel version afeter 2.6.28.
>>
>> Unmounting then remounting the filesystem allow to access the mountpoint again without any error message or apparent file corruption.
>> This filesystem is used by ~30 NFS clients and contains about 5M files (100GB).
>>
>> Before using the volume over NFS, there was only local activity (rsync syncing) and we didn't get any error.
>>
>> I expect to see this crash again in a few hours except if the volume is really corrupted. Does a full filesystem copy to a newly created volume would have a chance to solve the problem?
>>
>> Thanks,
>>
>> Gabriel
>>
>>     

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
