Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3F9A29DFB
	for <xfs@oss.sgi.com>; Fri, 13 Sep 2013 09:17:45 -0500 (CDT)
Message-ID: <52331E85.2090601@sgi.com>
Date: Fri, 13 Sep 2013 09:17:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 31/55 V3] libxfs: switch over to xfs_sb.c and remove
	xfs_mount.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-32-git-send-email-david@fromorbit.com>
	<522A1BCA.6010500@sgi.com> <20130906214021.GD12541@dastard>
	<522A4C79.1030200@sgi.com> <20130910010241.GZ12779@dastard>
	<522F289E.6070802@sgi.com> <20130910213249.GC19103@dastard>
	<52306F3E.8060409@sgi.com> <52307D39.6060903@sgi.com>
In-Reply-To: <52307D39.6060903@sgi.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>

On 09/11/13 09:24, Mark Tinguely wrote:
> On 09/11/13 08:25, Mark Tinguely wrote:
>> On 09/10/13 16:32, Dave Chinner wrote:
>>
>> > libxfs: switch over to xfs_sb.c and remove xfs_mount.c
>> >
>> > From: Dave Chinner <dchinner@redhat.com>
>> >
>> > Now that the kernel code has split the superblock specific code out
>> > of xfs_mount.c, we don't need xfs_mount.c anymore. Copy in xfs_sb.c
>> > and remove xfs_mount.c
>> >
>> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> > ---
>>
>> Applies clean for me.
>>
>> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>
> patch 31 V2/V3 break the compilation of xfsprogs.
>
> I get:
> ...
>
> configure: creating ./config.status
> config.status: creating include/builddefs
> config.status: creating include/platform_defs.h
> config.status: executing libtool commands
> Building include
> [LN] xfs
> [LN] disk
> Building libxfs
> [CC] gen_crc32table
> [GENERATE] crc32table.h
> [TEST] CRC32
> CRC_LE_BITS = 32
> crc32: tests passed, 225944 bytes in 117 usec
> crc32c: tests passed, 225944 bytes in 121 usec
> gmake[3]: *** No rule to make target `.ltdep', needed by `ltdepend'. Stop.
> gmake[2]: *** [libxfs] Error 2
> make[1]: *** [default] Error 2
> make: *** [default] Error 2
>


Auugh, I think I had a bad version of quilt. on another machine it 
applied and compiled correctly.

I put reviewed-by in the files and sent to Rich to commit.

--Mark.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
