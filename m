Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f170.google.com ([209.85.208.170]:42452 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbeLMEtj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 23:49:39 -0500
Received: by mail-lj1-f170.google.com with SMTP id l15-v6so575825lja.9
        for <linux-xfs@vger.kernel.org>; Wed, 12 Dec 2018 20:49:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADyTPEwfeOhCOSn3-SQh+XCWOthj0ms5mpbiHEtkscQQSQU+aQ@mail.gmail.com>
References: <20181210143345.GB8356@bfoster> <CADyTPEw_RZCC2yodbJ6W0e9mwJgQW19UXCHhcw1-tF4b0=hMjg@mail.gmail.com>
 <20181210161121.GC8356@bfoster> <20181210165020.GT24487@magnolia>
 <20181210174627.GD8356@bfoster> <CADyTPEzcjKO163RehVHtOo0=71=u515oHaeAnzmkfHtatpjhLg@mail.gmail.com>
 <20181210214115.GC6311@dastard> <CADyTPEyJkxM=YBwLudwPrTMFNpMtpfZ7ALjD0GrtrdCVTKa7+Q@mail.gmail.com>
 <20181211122701.GA2819@bfoster> <CADyTPEwXDtFRn5HciKwiGRPn4LSjAvLTK0HJ9UXKq6ZJTmj9pQ@mail.gmail.com>
 <20181213035352.GF6311@dastard> <CADyTPEwfeOhCOSn3-SQh+XCWOthj0ms5mpbiHEtkscQQSQU+aQ@mail.gmail.com>
From: Nick Bowler <nbowler@draconx.ca>
Date: Wed, 12 Dec 2018 23:49:36 -0500
Message-ID: <CADyTPEyOD6jTQF1QEc8M753=KAjbnbHFTLERhJZdCLuzT9r21w@mail.gmail.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 2018-12-12, Nick Bowler <nbowler@draconx.ca> wrote:
> On 2018-12-12, Dave Chinner <david@fromorbit.com> wrote:
>> On Tue, Dec 11, 2018 at 11:56:33PM -0500, Nick Bowler wrote:
>>> OK, xfstests has revealed some trouble with the three "bulkstat" ioctls,
>>> since while the xfs_bulkstat structure itself is fine, one of its
>>> members
>>> is used as a pointer to various structures which are not fine.  This
>>> wasn't too hard to fix though.
>>
>> IIRC, there's bigger problems than you realise here - the bulkstat
>> structure has embedded timestamps in them and on x32 struct timeval
>> doesn't match either ia32 or x86-64. i.e. on ia32, struct timeval is
>> 8 bytes, on x86-64 it is 16 bytes, and in x32 it is 12 bytes.
>
> This is not the case: struct timeval is 16 bytes on x32:
>
>   sizeof (struct timeval): 16
>   tv_sec          size:   8 offset:   0
>   tv_usec         size:   8 offset:   8
>
> This is the same as what I get on native 64-bit compilations; but
> anyway the xfs_bstat structure has xfs_bstime members, with the
> following characteristics on x32:
>
>   sizeof (struct xfs_bstime): 16
>   tv_sec          size:   8 offset:   0
>   tv_nsec         size:   4 offset:   8
>
> which is also the same as native 64-bit (time_t is the same on x32 and
> native: 8 bytes with 8 byte alignment).
>
> I manually verified every member of the xfs_bstat structure with sizeof
> and offsetof on -mx32 and -m64 compilations to ensure that this structure
> matches precisely between the x32 and native 64-bit cases.

To expand on this, for each structure which my RFC patchset feeds up to
the native handler, I first checked them by manual inspection and then
double checked using the following program; we can compile with both
-mx32 and -m64 and check that the output is identical.

  #include <stdio.h>
  #include <stddef.h>
  #include <xfs/xfs.h>
  #include <time.h>

  #define SHOWSIZE(type) do { \
  	printf("sizeof (%s): %zu\n", #type, sizeof (type)); \
  } while(0)

  #define SHOWMEMBER(type, member) do { \
  	printf("  %-15s size: %3zu offset: %3zu\n", #member, \
  	       sizeof (type){0}.member, offsetof(type, member)); \
  } while(0)

  int main(void)
  {
  	SHOWSIZE(struct xfs_flock64);
  	SHOWMEMBER(struct xfs_flock64, l_type);
  	SHOWMEMBER(struct xfs_flock64, l_whence);
  	SHOWMEMBER(struct xfs_flock64, l_start);
  	SHOWMEMBER(struct xfs_flock64, l_len);
  	SHOWMEMBER(struct xfs_flock64, l_sysid);
  	SHOWMEMBER(struct xfs_flock64, l_pid);
  	SHOWMEMBER(struct xfs_flock64, l_pad);

  	SHOWSIZE(struct xfs_fsop_geom_v1);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, blocksize);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, rtextsize);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, agblocks);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, agcount);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, logblocks);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, sectsize);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, inodesize);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, imaxpct);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, datablocks);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, rtblocks);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, rtextents);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, logstart);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, uuid);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, sunit);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, swidth);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, version);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, flags);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, logsectsize);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, rtsectsize);
  	SHOWMEMBER(struct xfs_fsop_geom_v1, dirblocksize);

  	SHOWSIZE(struct xfs_growfs_data);
  	SHOWMEMBER(struct xfs_growfs_data, newblocks);
  	SHOWMEMBER(struct xfs_growfs_data, imaxpct);

  	SHOWSIZE(struct xfs_growfs_rt);
  	SHOWMEMBER(struct xfs_growfs_rt, newblocks);
  	SHOWMEMBER(struct xfs_growfs_rt, extsize);

  	SHOWSIZE(struct xfs_bstime);
  	SHOWMEMBER(struct xfs_bstime, tv_sec);
  	SHOWMEMBER(struct xfs_bstime, tv_nsec);

  	SHOWSIZE(struct xfs_bstat);
  	SHOWMEMBER(struct xfs_bstat, bs_ino);
  	SHOWMEMBER(struct xfs_bstat, bs_mode);
  	SHOWMEMBER(struct xfs_bstat, bs_nlink);
  	SHOWMEMBER(struct xfs_bstat, bs_uid);
  	SHOWMEMBER(struct xfs_bstat, bs_gid);
  	SHOWMEMBER(struct xfs_bstat, bs_rdev);
  	SHOWMEMBER(struct xfs_bstat, bs_blksize);
  	SHOWMEMBER(struct xfs_bstat, bs_size);
  	SHOWMEMBER(struct xfs_bstat, bs_atime);
  	SHOWMEMBER(struct xfs_bstat, bs_mtime);
  	SHOWMEMBER(struct xfs_bstat, bs_ctime);
  	SHOWMEMBER(struct xfs_bstat, bs_blocks);
  	SHOWMEMBER(struct xfs_bstat, bs_xflags);
  	SHOWMEMBER(struct xfs_bstat, bs_extsize);
  	SHOWMEMBER(struct xfs_bstat, bs_extents);
  	SHOWMEMBER(struct xfs_bstat, bs_gen);
  	SHOWMEMBER(struct xfs_bstat, bs_projid_lo);
  	SHOWMEMBER(struct xfs_bstat, bs_forkoff);
  	SHOWMEMBER(struct xfs_bstat, bs_projid_hi);
  	SHOWMEMBER(struct xfs_bstat, bs_pad);
  	SHOWMEMBER(struct xfs_bstat, bs_cowextsize);
  	SHOWMEMBER(struct xfs_bstat, bs_dmevmask);
  	SHOWMEMBER(struct xfs_bstat, bs_dmstate);
  	SHOWMEMBER(struct xfs_bstat, bs_aextents);

  	SHOWSIZE(struct xfs_inogrp);
  	SHOWMEMBER(struct xfs_inogrp, xi_startino);
  	SHOWMEMBER(struct xfs_inogrp, xi_alloccount);
  	SHOWMEMBER(struct xfs_inogrp, xi_allocmask);

  	SHOWSIZE(struct xfs_swapext);
  	SHOWMEMBER(struct xfs_swapext, sx_version);
  	SHOWMEMBER(struct xfs_swapext, sx_fdtarget);
  	SHOWMEMBER(struct xfs_swapext, sx_fdtmp);
  	SHOWMEMBER(struct xfs_swapext, sx_offset);
  	SHOWMEMBER(struct xfs_swapext, sx_length);
  	SHOWMEMBER(struct xfs_swapext, sx_pad);
  	SHOWMEMBER(struct xfs_swapext, sx_stat);
  }
