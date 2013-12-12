Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 86AB27F54
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 05:45:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40A40304066
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 03:45:28 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 93BBIRI6OHduXzXA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 03:45:23 -0800 (PST)
Message-ID: <52A9A1AD.5090103@oracle.com>
Date: Thu, 12 Dec 2013 15:44:45 +0400
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] nfsd: revoking of suid/sgid bits after chown() in a
	consistent way
References: <20131206204747.GB12613@fieldses.org>
	<1386756996-28083-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<52A845C6.2080109@oracle.com> <20131212033859.GA5978@fieldses.org>
In-Reply-To: <20131212033859.GA5978@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: vasily.isaenko@oracle.com, hch@infradead.org, linux-nfs@vger.kernel.org, sprabhu@redhat.com, xfs@oss.sgi.com



On 12/12/2013 07:38 AM, J. Bruce Fields wrote:
> On Wed, Dec 11, 2013 at 03:00:22PM +0400, Stanislav Kholmanskikh wrote:
>>
>>
>> On 12/11/2013 02:16 PM, Stanislav Kholmanskikh wrote:
>> [cut off]
>>>
>>> This patch makes NFS to behave like local file systems.
>>>
>> [cut off]
>>
>> This patch allows to run generic/193 without any issues with NFSv3.
>>
>> With NFSv4 generic/193 fails (but with the other issues, which
>> existed even before the patch).
>>
>> generic/193 expects that suid/sgid bits are cleared after the file
>> truncation:
>>
>> touch file
>> chown fsgqa:fsgqa file
>> chmod u+s file
>> echo 'xyz' > file
>> ls -l file
>> su fsgqa -c 'echo > file'
>> ls -l file
>>
>> With ext4 (for example), we have expectable results:
>> -rwSr--r-- 1 fsgqa fsgqa 4 Dec 11 05:21 file
>> -rw-r--r-- 1 fsgqa fsgqa 1 Dec 11 05:22 file
>>
>> With NFSv3 as well:
>> -rwSr--r-- 1 fsgqa fsgqa 4 Dec 11 05:24 file
>> -rw-r--r-- 1 fsgqa fsgqa 1 Dec 11 05:25 file
>>
>> But with NFSv4 the bits are not cleared:
>> -rwSr--r-- 1 fsgqa fsgqa 1 Dec 11 05:19 file
>> -rwSr--r-- 1 fsgqa fsgqa 1 Dec 11 05:21 file
>>
>> 'echo > file' issues:
>>
>> open("file", O_WRONLY|O_CREAT|O_TRUNC, 0666)
>>
>> Can it be because of design differences between NFSv3 and NFSv4?
>
> In the v3 case I'd expect the open O_TRUNC to result in a SETATTR rpc,
> in the v4 case an OPEN rpc.  Both result in a call to nfsd_setattr,
> though I only see nfsd_setattr turning off the SUID/SGID bits in the
> chown case.  Are you sure it isn't the subsequent write that clears
> those bits?

Actually, in the above test script I occasionally swapped positions of 
"echo 'xyz' > file" and "chmod u+s file". Of course, chmod should be 
after the writing. Sorry.

But here we are:

rm -f file; touch file
chown fsgqa:fsgqa file
echo 'xyz' > file
chmod u+s file
ls -l file
su fsgqa -c 'echo -n > file'  # open(O_TRUNC), close()
ls -l file
su fsgqa -c 'echo > file'     # open(O_TRUNC), write("\n"), close()
ls -l file

With NFSv3 suid is cleared after write:
-rwSr--r-- 1 fsgqa fsgqa 4 Dec 12 05:24 file
-rwSr--r-- 1 fsgqa fsgqa 0 Dec 12 05:24 file
-rw-r--r-- 1 fsgqa fsgqa 1 Dec 12 05:25 file

With NFSv4 suid is not cleared after write("\n"):
-rwSr--r-- 1 fsgqa fsgqa 4 Dec 12 05:26 file
-rwSr--r-- 1 fsgqa fsgqa 0 Dec 12 05:26 file
-rwSr--r-- 1 fsgqa fsgqa 1 Dec 12 05:27 file

but if we issue "su fsgqa -c 'echo -n b > file'", we will clear it:
-rw-r--r-- 1 fsgqa fsgqa 1 Dec 12 05:28 file

So if "file" is a file on NFSv4:
-rwSr--r-- 1 fsgqa fsgqa 4 Dec 12 05:26 file
and we do:

fd = open(file, O_WRONLY);

then write(fd, "\n", 1) will not clear suid bit, but write(fd, "b", 1) 
will do.

With ext4 suid is cleared after open(O_TRUNC):
-rwSr--r-- 1 fsgqa fsgqa 4 Dec 12 05:29 file
-rw-r--r-- 1 fsgqa fsgqa 0 Dec 12 05:29 file
-rw-r--r-- 1 fsgqa fsgqa 1 Dec 12 05:30 file

Execution of (via 'su fsgqa -c ...'):
fd = open("file", O_WRONLY);
close(fd);
if "file" is on ext4 file system and has suid bit on will not clear suid 
bit.

Execution of (via 'su fsgqa -c ...'):
fd = open("file", O_WRONLY);
write(fd, "a", 1);
close(fd);
if "file" is on ext4 file system and has suid bit on will clear suid bit.

To conclude:
1. With NFS suid is not cleared after open(O_TRUNC)
This may be solved by addition of ATTR_SIZE handling in nfsd_setattr 
(i.e nfsd_sanitize_attrs). Right?

2. NFSv4 treats "\n" on write() specially.
No ideas by the moment.

>
> But looks to me like nfsd_vfs_write (used in both v3 & v4 cases) clears
> suid & guid, so I still don't see it.
>
> --b.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
