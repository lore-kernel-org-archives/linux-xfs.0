Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F04477F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 04:47:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 809B4AC001
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 02:46:58 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id zR9brEEDrXyGSxkC
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 02:46:57 -0800 (PST)
Message-ID: <51065721.40102@hardwarefreak.com>
Date: Mon, 28 Jan 2013 04:46:57 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Volume fine on x86_64, corruption on ARM
References: <20130127225258.GA2287@vicerveza.homeunix.net>
In-Reply-To: <20130127225258.GA2287@vicerveza.homeunix.net>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
Cc: xfs@oss.sgi.com

On 1/27/2013 4:52 PM, Llu=EDs Batlle i Rossell wrote:

> ----------------------
> starting systemd...
> systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX +IMA +=
SYSVINIT -LIBCRYPTSETUP +GCRYPT +ACL +XZ)
> =

> Welcome to NixOS 0.2pre-4eb2b09-af495e0!
> =

> Failed to insert module 'autofs4'
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> dea96000: 58 46 53 42 00 00 10 00 00 00 00 00 01 bd 26 f0  XFSB..........=
&.
> XFS (sda1): Internal error xfs_da_do_buf(2) at line 2192 of file fs/xfs/x=
fs_da_btree.c.  Caller 0xbf057e68
...

https://wiki.archlinux.org/index.php/Autofs

This document outlines the procedure needed to set up AutoFS, a package
that provides support for automounting removable media or network shares
when they are inserted or accessed.

Your HDD is USB.  Might the failure of this module to load have
something to do with the XFS problems?

Forgive me if my lack of experience with this is causing me to ask a
stupid question.  I've never used, nor will I ever use, XFS with a USB
drive.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
