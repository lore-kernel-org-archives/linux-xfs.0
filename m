Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6SG0aT1189693 for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 11:00:36 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7B071410528
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 09:01:22 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id ObSZWdcF3r5pVhYG for
	<xfs@oss.sgi.com>; Tue, 28 Jul 2009 09:01:22 -0700 (PDT)
Message-ID: <4A6F20D0.4050303@sandeen.net>
Date: Tue, 28 Jul 2009 11:01:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
References: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	
	<1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>	
	<b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>	
	<4A6F0978.4070709@sandeen.net>
	<b094161c0907280759w6c525201vd4a17e22a8c1d582@mail.gmail.com>
In-Reply-To: <b094161c0907280759w6c525201vd4a17e22a8c1d582@mail.gmail.com>
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
To: Eddy Zhao <eddy.y.zhao@gmail.com>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>, xfs@oss.sgi.com

Eddy Zhao wrote:
> Hello Eric:
> 
>>
>> Well, the fact that you have 2 arches would have been highly relevant in
>> your first email.  ;)  Is this the old abi or the new?  Guessing old,
>> based on the alignment issues.
>>
> 
> ARM compiler is producing eabi. The problem lies in: "long long" on arm
> is 8 bytes aligned, on x86 is 4 bytes aligned. So 4 more bytes are
> padded before xfs_inode_log_format::ilf_ino on arm.

A tool that can be very helpful here is "pahole" found in the dwarves
package:

# pahole -C xfs_inode_log_format xfs-arm-eabi.ko
struct xfs_inode_log_format {
	__uint16_t                 ilf_type;          /*     0     2 */
	__uint16_t                 ilf_size;          /*     2     2 */
	__uint32_t                 ilf_fields;        /*     4     4 */
	__uint16_t                 ilf_asize;         /*     8     2 */
	__uint16_t                 ilf_dsize;         /*    10     2 */

	/* XXX 4 bytes hole, try to pack */

	__uint64_t                 ilf_ino;           /*    16     8 */
	union {
		__uint32_t         ilfu_rdev;         /*           4 */
		uuid_t             ilfu_uuid;         /*          16 */
	} ilf_u;                                      /*    24    16 */
	__int64_t                  ilf_blkno;         /*    40     8 */
	__int32_t                  ilf_len;           /*    48     4 */
	__int32_t                  ilf_boffset;       /*    52     4 */

	/* size: 56, cachelines: 1, members: 10 */
	/* sum members: 52, holes: 1, sum holes: 4 */
	/* last cacheline: 56 bytes */
};

That was for an arm eabi xfs.ko from 2.6.25.  Don't worry about the "try
to pack" message; as long as holes match everywhere it's ok ;)

...


>> To be honest, I am not certain that this is "worth fixing" - we already
>> have the requirement that log replay can only be done on an architecture
>> of the same endianness, and a further requirement that it can only be
>> done on architectures with similar alignment rules doesn't seem so bad.
>>
> 
> Where is the official description of such requirment? The requirment is
> not obvious to new XFS users, and they should be warned :)

For the endian requirement ... not sure where it's doc'd to be honest.
if you don't find it in Documentation/filesystems/xfs.txt feel free to
send a patch ;)

> Why is such requirment? For backward compatibility?

The xfs log was done native-endian for performance reasons, I think.

> I think the requirment is bad. It inhibit user from exchanging data
> freely between systems, which is an obvious requirment for file system
> design.

No, it just means that you have to cleanly unmount on one filesystem
before you try to mount it on another different system.

>> The problem is, if you go off and "fix" this on arm now, you'll find
>> that logs created under older arm kernels can't be replayed on newer arm
>> kernels and vice versa...
> 
> Compared with the above restriction("requirment"), we can afford this :)
> 
> Do I miss any other log/metadata needs pack on 2.6.10?

I can't really speak to 2.6.10, I don't want to go back that far ;)  I'm
afraid  you're on your own there.

So just to be clear, on 2.6.28, arm eabi logs replay fine on x86_64?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
