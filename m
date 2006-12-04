Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Dec 2006 09:54:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB4Hs0aG008383
	for <xfs@oss.sgi.com>; Mon, 4 Dec 2006 09:54:01 -0800
Message-ID: <45746082.2090403@sandeen.net>
Date: Mon, 04 Dec 2006 11:53:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs errors:
References: <200612041631.kB4GVdwV031915@mcvs4.priv.usm.edu>
In-Reply-To: <200612041631.kB4GVdwV031915@mcvs4.priv.usm.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Johnson <robert.e.johnson@usm.edu>
Cc: xfs@oss.sgi.com

Robert Johnson wrote:
> I have just installed and configured a xfs file system on Redhat AS4 server,

RHEL4 doesn't support xfs ;-)

> running on IBM eServer 366 platform.  The file system was carved out of our
> EMC SAN, with Qlogic HBA dual port fiber channel cards. The error message is
> as follows:
> 
> Dec  4 09:43:11 mail kernel: XFS: possible memory allocation deadlock in
> kmem_alloc (mode:0x250)
> Dec  4 09:43:14 mail kernel: XFS: possible memory allocation deadlock in
> kmem_alloc (mode:0x250)
> Dec  4 09:43:15 mail kernel: XFS: possible memory allocation deadlock in
> kmem_alloc (mode:0x250)
> Dec  4 09:44:44 mail kernel: XFS: possible memory allocation deadlock in
> kmem_alloc (mode:0x2d0)

You might have highly fragmented files, and xfs_fsr might help with this...

-Eric
