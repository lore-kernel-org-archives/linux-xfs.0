Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:47086 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbeLNDsA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 22:48:00 -0500
Received: by mail-lj1-f193.google.com with SMTP id v15-v6so3665197ljh.13
        for <linux-xfs@vger.kernel.org>; Thu, 13 Dec 2018 19:47:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181213013000.15716-1-nbowler@draconx.ca>
References: <20181213013000.15716-1-nbowler@draconx.ca>
From: Nick Bowler <nbowler@draconx.ca>
Date: Thu, 13 Dec 2018 22:47:55 -0500
Message-ID: <CADyTPEyq7iYSK6rV1o9GHVGykAt=qqxRDqFyMDg8arP+a_ANxA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Fixing xfs ioctls on x32
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

OK, I went through every single case in xfs_file_compat_ioctl, and wrote
a brief justification for what, if any, changes appear to be be required
to correctly support x32 userspace.  The analysis is done by inspecting
how the implementation accesses userspace memory and what structures
are involved.

There is a general assumption in this analysis that the current compat
implementation is correct as written for IA-32 userspace.  However,
during this inspection I may have found a problem in one of the ioctls
which affects i686 (NOT x32!) today.  I am looking into this next.

Anyway, here's the complete list.

XFS_IOC_DIOINFO, XFS_IOC_FSGEOMETRY, XFS_IOC_FSGETXATTR,
XFS_IOC_FSSETXATTR, XFS_IOC_FSGETXATTRA, XFS_IOC_FSSETDM,
XFS_IOC_GETBMAP, XFS_IOC_GETBMAPA, XFS_IOC_GETBMAPX, XFS_IOC_FSCOUNTS,
XFS_IOC_SET_RESBLKS, XFS_IOC_GET_RESBLKS, XFS_IOC_FSGROWFSLOG,
XFS_IOC_GOINGDOWN, XFS_IOC_ERROR_INJECTION, XFS_IOC_ERROR_CLEARALL,
FS_IOC_GETFSMAP, XFS_IOC_SCRUB_METADATA:

  - All of these call directly the native implementation.  Since that
    implementation is correct for both ia32 and amd64 it will also be
    correct for x32.

XFS_IOC_ALLOCSP_32, XFS_IOC_FREESP_32, XFS_IOC_ALLOCSP64_32,
XFS_IOC_FREESP64_32, XFS_IOC_RESVSP_32, XFS_IOC_UNRESVSP_32,
XFS_IOC_RESVSP64_32, XFS_IOC_UNRESVSP64_32, XFS_IOC_ZERO_RANGE_32:

  - The relevant struct is xfs_flock64.  On x32 this structure matches
    exactly the amd64 layout, so the ioctl cmd number is changed.

  - No other data in userspace is involved.

  - Since the x32 structure matches the native layout exactly, it is
    required to add new cases which pass the arguments onward to the
    native implementation.  This is patch #2 in this series ("Fix x32
    ioctls when cmd numbers differ from ia32.")

XFS_IOC_FSGEOMETRY_V1_32:

  - The relevant struct is xfs_fsop_geom_v1.  On x32 this structure
    matches exactly the amd64 layout, so the ioctl cmd number is
    changed.

  - No other data in userspace is involved.

  - Since the x32 structure matches the native layout exactly, it is
    required to add a new case (XFS_IOC_FSGEOMETRY_V1) which passes the
    arguments onward to the native implementation.  This is patch #2
    in this series ("Fix x32 ioctls when cmd numbers differ from ia32.")

XFS_IOC_FSGROWFSDATA_32:

  - The relevant struct is xfs_growfs_data.  On x32 this structure
    matches exactly the amd64 layout, so the ioctl cmd number is
    changed.

  - No other data in userspace is involved.

  - Since the x32 structure matches the native layout exactly, it is
    required to add a new case (XFS_IOC_FSGROWFSDATA) which passes the
    arguments onward to the native implementation.  This is patch #2
    in this series.  ("Fix x32 ioctls when cmd numbers differ from
    ia32.")


XFS_IOC_FSGROWFSRT_32:

  - The relevant struct is xfs_growfs_rt.  On x32 this structure matches
    exactly the amd64 layout, so the ioctl cmd number is changed.

  - No other data in userspace is involved.

  - Since the x32 structure matches the native layout exactly, it is
    required to add a new case which passes the arguments onward to
    the native implementation.  This is patch #2 in this series ("Fix
    x32 ioctls when cmd numbers differ from ia32.")

XFS_IOC_GETXFLAGS_32, XFS_IOC_SETXFLAGS_32, XFS_IOC_GETVERSION_32:

  - Trivial, the only compat problem is the ioctl cmd number itself,
    which on x32 will match the ia32 number so it will be handled
    correctly.

  - No change is required.

XFS_IOC_SWAPEXT_32:

  - The relevant struct is xfs_swapext.  On x32 this structure matches
    exactly with the amd64 layout, so the ioctl cmd number is changed.

  - No other data in userspace is involved.

  - Since the x32 structure matches the native layout exactly, it is
    required to add a new case (XFS_IOC_SWAPEXT) which passes the
    arguments onward to the native implementation.  This is patch #2
    in this series ("Fix x32 ioctls when cmd numbers differ from ia32.")

XFS_IOC_FSBULKSTAT_32, XFS_IOC_FSBULKSTAT_SINGLE_32,
XFS_IOC_FSINUMBERS_32:

  - These three are all busted on x32 and patch #1 in this series
    ("Fix bulkstat compat ioctls on x32") should fix them.  See the
    patch thread for details.

XFS_IOC_FD_TO_HANDLE_32, XFS_IOC_PATH_TO_HANDLE_32,
XFS_IOC_PATH_TO_FSHANDLE_32, XFS_IOC_OPEN_BY_HANDLE_32,
XFS_IOC_READLINK_BY_HANDLE_32:

  - For all of these, The relevant struct is xfs_fsop_handlereq.  On
    x32, this structure matches exactly the ia32 layout, so ioctl cmd
    number will match.

  - The current compat implementation reads in the structure according
    to ia32 layout.  Thus it will be read correctly from x32 userspace.

  - The existing implementation then calls the native implementation.
    Since that is correct for both ia32 and amd64 it will also be
    correct for x32.

  - No change is required.

XFS_IOC_ATTRLIST_BY_HANDLE_32:

  - The relevant struct is xfs_fsop_attrlist_handlereq.  On x32, this
    structure matches exactly the ia32 layout, so ioctl cmd number will
    match.  The implementation calls xfs_compat_attrlist_by_handle.

  - Since the xfs_fsop_attrlist_handlereq struct matches ia32, the
    existing compat implementation will read it from x32 userspace
    correctly.

  - Something is strange here, the native implementation has an extra
    copy_to_user which is not present in the compat implementation,
    which writes the attrlist_cursor_kern struct back into the
    xfs_fsop_attrlist_handlereq structure provided by the user.

  - Other than that one difference, the existing compat implementation
    does exactly the same thing as the native implementation.  Since
    those parts are correct for both ia32 and amd64 they will also be
    correct for x32.

  - If any change is required, it may be that this ioctl is currently
    broken on regular ia32 compat.

  - This may be why xfstests xfs/269 is failing for me on i686, since
    that test makes use of this very ioctl.  I will investigate.

XFS_IOC_ATTRMULTI_BY_HANDLE_32:

  - The relevant struct is xfs_fsop_attrmulti_handlereq.  On x32, this
    structure matches exactly the ia32 layout, so ioctl cmd number will
    match.  The implementation calls xfs_compat_attrmulti_by_handle.

  - The main structure contains a pointer to another xfs struct,
    xfs_attr_multiop (this is read as an array of these structs).
    On x32, this structure also matches exactly the ia32 layout
    (so the array does too).

  - Since both these structures match ia32, the existing compat
    implementation will read them in from x32 userspace correctly.

  - The xfs_attr_multiop structure contains two pointers to strings
    (am_attrname, am_attrvalue).  There are no compat issues with
    strings so these will be read and/or written correctly by the
    existing compat implementation.

  - Finally, the implementation writes back to the xfs_attr_multiop
    array.  Since the x32 version matches ia32, this will be correctly
    formatted for x32 userspace.

  - No change is required.

XFS_IOC_FSSETDM_BY_HANDLE_32:

  - The relevant struct is xfs_fsop_setdm_handlereq.  On x32, this
    structure matches exactly the ia32 layout, so ioctl cmd number will
    match.  The implementation calls xfs_compat_fssetdm_by_handle.

  - Since the xfs_fsop_setdm_handlereq struct matches ia32, the existing
    compat implementation will read it from x32 userspace correctly.

  - The existing implementation then reads the pointed-to struct
    fsdmidata.  This structure matches between ia32, x32, and amd64
    layouts; the existing compat implementation just snarfs it in
    directly and this will work as expected on x32.

  - After this point the existing compat implementation is identical to
    the native implementation.  Since that part is correct for both ia32
    and amd64 it will also be correct for x32.

  - No change is required.

And that's a wrap.

Cheers,
  Nick
