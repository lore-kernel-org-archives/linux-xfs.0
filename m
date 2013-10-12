Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DED57F4E
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 16:11:18 -0500 (CDT)
Message-ID: <5259BAF6.5080509@sgi.com>
Date: Sat, 12 Oct 2013 16:11:18 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfs: reject completely bogus remount options
References: <52584C8A.1060808@redhat.com> <52584D56.7090902@sandeen.net>
	<52586ED8.3030804@sgi.com> <5258A884.7000104@sandeen.net>
In-Reply-To: <5258A884.7000104@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/11/13 20:40, Eric Sandeen wrote:
> On 10/11/13 4:34 PM, Mark Tinguely wrote:
>> On 10/11/13 14:11, Eric Sandeen wrote:
>>> There's a long comment about handling non-remountable
>>> options in xfs_fs_remount, but nothing addresses the case
>>> of completely bogus mount options at remount time, which
>>> can lead to some severe strangeness:
>>>
>>> # for I in `seq 1 10`; do mount -o remount,noacl /mnt/test2; done
>>> # for I in `seq 1 10`; do mount -o remount,badoption /mnt/test2; done
>>> # grep sdb4 /etc/mtab
>>> /dev/sdb4 /mnt/test2 xfs rw,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption 0 0
>>>
>>> This is a bit of a hack, but we can re-use xfs_parseargs()
>>> with a dummy mount struct to just vet all of the remount
>>> options which were passed in.  With this, we get a saner
>>> result:
>>>
>>> [44898.102990] EXT4-fs (sdb4): Unrecognized mount option "badoption" or missing value
>>>
>>> if we try to remount with something ridiculous.
>>>
>>> In the long run we should probably revamp a lot of the mount option
>>> handling...
>>>
>>> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
>>> ---
>>
>>
>> I don't seem to get the duplicate mtab entries on a top of tree kernel.
>> Is this still appropriate?
>
> Maybe different mount(8) behavior on your system?  (probably symlinked to /proc/mounts)
>
> On RHEL6:
>
> # mount /dev/sdb1 /mnt/test
> # for I in `seq 1 10`; do mount -o remount,noacl /mnt/test; done
> # mount | grep sdb1
> /dev/sdb1 on /mnt/test type xfs (rw,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl)
> # uname -a
> Linux hostname 3.12.0-rc4+ #41 SMP Fri Oct 11 19:43:01 CDT 2013 x86_64 x86_64 x86_64 GNU/Linux
>
>
> -Eric

Yep, confirmed the described behavior on a RHEL 6 box without patch.
The patch looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
