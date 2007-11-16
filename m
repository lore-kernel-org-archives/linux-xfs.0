Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Nov 2007 22:04:03 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAG63uhI014653
	for <xfs@oss.sgi.com>; Thu, 15 Nov 2007 22:03:59 -0800
Message-ID: <473D32D9.2020500@sgi.com>
Date: Fri, 16 Nov 2007 17:04:09 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno #2
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> A couple changes from the first xfs_reno:
>
>  - Major one is that symlinks are now supported, but only
>    owner, group and extended attributes are copied for them
>    (not times or inode attributes).
>
>  - Man page!
>
>
> To make this better, ideally we need some form of
> "swap inodes" function in the kernel, where the entire
> contents of the inode themselves are swapped. This form
> can handle any inode and without any of the dir/file/attr/etc
> copy/swap mechanisms we have in xfs_reno.
>
> Barry.
Hi Barry,

The code is looking good. Some questions and minor remarks bellow.

- init_nodehash() return value is not used

- Why poll_output is volatile?

- I think you meant "exit()" instead of "goto quit" below as
"recover_fd" is not opened yet:

		if (n_opt)
			goto quit;
...			
quit:
	free_nodehash();

	close(recover_fd);


- Is dirname(xxx) used as intended? I think it should be xxx = dirname(xxx).

- Some log_message() strings don't have _("text") convention.

I see that you take care to copy the DMAPI fields as well.
Unfortunately changing the inode number in a DMAPI filesystem
would make the DMAPI handle different, which means any application
using DMAPI would not be able to access the new file anymore.

When the XFS parent pointers feature is released we would need to find
out to update the EA to point to the new inode parent directory. This may
not be that easy though.

Regards,
Vlad
