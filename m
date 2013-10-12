Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A96A67F3F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 20:40:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 861638F808F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 18:40:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id p6ONtE78RhbX4Yfo for <xfs@oss.sgi.com>;
	Fri, 11 Oct 2013 18:40:22 -0700 (PDT)
Message-ID: <5258A884.7000104@sandeen.net>
Date: Fri, 11 Oct 2013 20:40:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: reject completely bogus remount options
References: <52584C8A.1060808@redhat.com> <52584D56.7090902@sandeen.net>
	<52586ED8.3030804@sgi.com>
In-Reply-To: <52586ED8.3030804@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/11/13 4:34 PM, Mark Tinguely wrote:
> On 10/11/13 14:11, Eric Sandeen wrote:
>> There's a long comment about handling non-remountable
>> options in xfs_fs_remount, but nothing addresses the case
>> of completely bogus mount options at remount time, which
>> can lead to some severe strangeness:
>>
>> # for I in `seq 1 10`; do mount -o remount,noacl /mnt/test2; done
>> # for I in `seq 1 10`; do mount -o remount,badoption /mnt/test2; done
>> # grep sdb4 /etc/mtab
>> /dev/sdb4 /mnt/test2 xfs rw,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption 0 0
>>
>> This is a bit of a hack, but we can re-use xfs_parseargs()
>> with a dummy mount struct to just vet all of the remount
>> options which were passed in.  With this, we get a saner
>> result:
>>
>> [44898.102990] EXT4-fs (sdb4): Unrecognized mount option "badoption" or missing value
>>
>> if we try to remount with something ridiculous.
>>
>> In the long run we should probably revamp a lot of the mount option
>> handling...
>>
>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>> ---
> 
> 
> I don't seem to get the duplicate mtab entries on a top of tree kernel.
> Is this still appropriate?

Maybe different mount(8) behavior on your system?  (probably symlinked to /proc/mounts)

On RHEL6:

# mount /dev/sdb1 /mnt/test
# for I in `seq 1 10`; do mount -o remount,noacl /mnt/test; done 
# mount | grep sdb1
/dev/sdb1 on /mnt/test type xfs (rw,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl)
# uname -a
Linux hostname 3.12.0-rc4+ #41 SMP Fri Oct 11 19:43:01 CDT 2013 x86_64 x86_64 x86_64 GNU/Linux


-Eric

> --Mark.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
