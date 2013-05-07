Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E624829E15
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 14:08:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6B03304053
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 12:08:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KCsAHd3Lbumg4tFp for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 12:08:06 -0700 (PDT)
Message-ID: <51895115.90108@sandeen.net>
Date: Tue, 07 May 2013 14:08:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 3.9.0: XFS rootfs corruption
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
In-Reply-To: <647316680.8155487.1367913231441.JavaMail.root@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com

On 5/7/13 2:53 AM, CAI Qian wrote:
> 
> 
> ----- Original Message -----
>> From: "Eric Sandeen" <sandeen@sandeen.net>
>> To: "CAI Qian" <caiqian@redhat.com>
>> Cc: xfs@oss.sgi.com
>> Sent: Monday, May 6, 2013 10:31:01 PM
>> Subject: Re: 3.9.0: XFS rootfs corruption
>>
>> On 5/6/13 2:50 AM, CAI Qian wrote:
>>> Saw this on several different Power7 systems after kdump reboot. It has
>>> xfsprogs-3.1.10
>>> and rootfs in on LVM. Never saw one of those in any of the RC releases.
>>>
>>> ] Reached target Basic System.
>>> [    4.919316] bio: create slab <bio-1> at 1
>>> [    5.078616] SGI XFS with ACLs, security attributes, large block/inode
>>> numbers, no debug enabled
>>> [    5.081925] XFS (dm-1): Mounting Filesystem
>>> [    5.168530] XFS (dm-1): Starting recovery (logdev: internal)
>>> [    5.333575] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 176 of
>>> file fs/xfs/xfs_dir2_data.c.  Caller 0xd000000002396fdc
>>
>> here:
>>
>>         /*
>>          * Need to have seen all the entries and all the bestfree slots.
>>          */
>>         XFS_WANT_CORRUPTED_RETURN(freeseen == 7);
>>
>> I hope Dave knows offhand what this might mean.  :)
>>
>> Could you get a metadump of the filesystem in question?
> Err, less familiar here. May I ask how can I do that?

since it's the root fs, you might need to do it from some sort of rescue
shell, then just do xfs_metadump /dev/<device> <metadump filename>

the resulting file should compress further with something like bzip2.

...

>>> Also, never saw any of those in other architectures like x64, but started
>>> get those there in 3.9.0.
>>> Unsure if those are related.
>>>
>>> [ 3224.369782]
>>> =============================================================================
>>> [ 3224.370017] BUG xfs_efi_item (Tainted: GF   B       ): Poison
>>> overwritten
>>> [ 3224.370017]
>>> -----------------------------------------------------------------------------
>>
>>   2: 'F' if any module was force loaded by "insmod -f", ' ' if all
>>      modules were loaded normally.
>>
>> Force loaded modules, what's that from?
> This could be just happened after the booting done or we were running a stress test later
> that does load (modprobe *) and unload (modprobe -r *) every module. Again, those warnings
> could be totally unrelated to the above rootfs corruption.
> CAI Qian

hmmm :)  So any one of those modules could have caused memory corruption I guess.

If you can hit it reliably you might try to narrow it down to whether it
is a particular module causing it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
