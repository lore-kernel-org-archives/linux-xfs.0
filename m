Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ECB5E7F4E
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 05:27:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63C02AC001
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 03:27:39 -0800 (PST)
Received: from darcachon.resolversystems.com (darcachon.resolversystems.com
	[80.68.93.186]) by cuda.sgi.com with ESMTP id 5xPY6DGnhZyFpw2r
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Mar 2015 03:27:36 -0800 (PST)
Received: from host81-136-198-183.in-addr.btopenworld.com ([81.136.198.183]
	helo=[192.168.0.105]) by darcachon.resolversystems.com with esmtpsa
	(TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80)
	(envelope-from <harry@pythonanywhere.com>) id 1YTqPm-0001Qo-Bn
	for xfs@oss.sgi.com; Fri, 06 Mar 2015 11:27:34 +0000
Message-ID: <54F98F20.9000208@pythonanywhere.com>
Date: Fri, 06 Mar 2015 11:27:28 +0000
From: Harry Percival <harry@pythonanywhere.com>
MIME-Version: 1.0
References: <54EC958E.2000001@pythonanywhere.com>	<20150224215907.GA18360@dastard>	<54EF1A8F.7030505@pythonanywhere.com>	<54F856E7.10006@pythonanywhere.com>	<54F87BF3.3000405@sandeen.net>	<54F88CEC.4030009@pythonanywhere.com>	<54F89201.60805@sandeen.net>	<54F893AF.2070406@pythonanywhere.com>	<54F895FA.4050205@sandeen.net>
	<54F89B47.4010702@pythonanywhere.com>
	<54F8B7D6.2000501@sandeen.net>
In-Reply-To: <54F8B7D6.2000501@sandeen.net>
Subject: Re: trying to avoid a lengthy quotacheck by deleting all quota data
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

Glad we managed to nail down a probable culprit!   Here's hoping Debian 
and Ubuntu pull in a new kernel :)

In other news, any advice on running this

     xfstests:src/bstat

command as a way of estimating how long a quotacheck will take? Would it 
still be a useful estimator?  Do you think it would significantly affect 
the performance of a disk that's under fairly heavy use?

hp

On 05/03/15 20:08, Eric Sandeen wrote:
> On 3/5/15 12:07 PM, Harry wrote:
>> Here's the syslog, if you're curious.
>>
>> http://pastebin.com/raw.php?i=kKvWJcze
>>
>> Search for "Failed to initialize"
> Ok, there is no other message offering more info, sadly.
>
>> So your best guess is that it's the drbd layer that's causing the
>> quotacheck?  Out of curiosity, i may try mounting a non-drbd drive
>> with xfs, and seeing if we can still repro the
>> hard-reboot-causes-quotacheck thing...  Unless you think it's just an
>> old behaviour that's more to do with the version of the kernel we're
>> using?
> I really don't have a good guess at this point..... oh, wait, finally,
> a bell goes off:
>
> commit 5ef828c4152726f56751c78ea844f08d2b2a4fa3
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Mon Aug 4 11:35:44 2014 +1000
>
>      xfs: avoid false quotacheck after unclean shutdown
>      
>      The commit
>      
>      83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
>      
>      added a new function xfs_sb_quota_from_disk() which swaps
>      on-disk XFS_OQUOTA_* flags for in-core XFS_GQUOTA_* and XFS_PQUOTA_*
>      flags after the superblock is read.
>      
>      However, if log recovery is required, the superblock is read again,
>      and the modified in-core flags are re-read from disk, so we have
>      XFS_OQUOTA_* flags in memory again.  This causes the
>      XFS_QM_NEED_QUOTACHECK() test to be true, because the XFS_OQUOTA_CHKD
>      is still set, and not XFS_GQUOTA_CHKD or XFS_PQUOTA_CHKD.
>      
>      Change xfs_sb_from_disk to call xfs_sb_quota_from disk and always
>      convert the disk flags to in-memory flags.
>      
>      Add a lower-level function which can be called with "false" to
>      not convert the flags, so that the sb verifier can verify
>      exactly what was on disk, per Brian Foster's suggestion.
>      
>      Reported-by: Cyril B. <cbay@excellency.fr>
>      Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>
>
> 83e782e went in at v3.11; the above commit hit v3.17, so it was broken
> for a while.
>
> I still can't explain the "quota init failed" bit, but the above
> probably explains the unexpected quotacheck problem.
>
> -Eric
>
>> HP

-- 
Harry Percival
Developer
harry@pythonanywhere.com

PythonAnywhere - a fully browser-based Python development and hosting environment
<http://www.pythonanywhere.com/>

PythonAnywhere LLP
17a Clerkenwell Road, London EC1M 5RD, UK
VAT No.: GB 893 5643 79
Registered in England and Wales as company number OC378414.
Registered address: 28 Ely Place, 3rd Floor, London EC1N 6TD, UK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
