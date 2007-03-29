Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 08:16:24 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.244])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2TFGE6p020866
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 08:16:17 -0700
Received: by an-out-0708.google.com with SMTP id c5so181576anc
        for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 08:16:12 -0700 (PDT)
Message-ID: <54fb6c0f0703290635i50cd51ddv16e1dd0941435d77@mail.gmail.com>
Date: Thu, 29 Mar 2007 15:35:36 +0200
From: "Mike Machuidel" <machuidel@gmail.com>
Subject: ISCSI / Xen: EIP at xfs_bmap_local_to_extents
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I am using XFS over ISCSI in Xen and after a while I get Oops's saying
"EIP is at xfs_bmap_local_to_extents". The errors occur mainly when
opening files (for reading?). For example when using the program
"file".

ISCSI seems to be working fine. No connection errors occured which
means it should behave as a typical block device.

I am using the following software:
Debian Etch
Linux Kernel: 2.6.18
Xen: 3.0.2
(I am not using SMP inside the virtual machine)

Oops can be found at:
http://www.satl.com/~machuidel/xfs_oops.txt

Hope anyone can help to improve this situation.

Thanks.

Cheers,
Mike Machuidel
