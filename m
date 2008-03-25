Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 05:53:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PCrnGO015481
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 05:53:52 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C63936E32D3
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 05:54:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id HGrDUxXIq6RT5gkJ for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 05:54:23 -0700 (PDT)
Message-ID: <47E8F5FE.8040600@sandeen.net>
Date: Tue, 25 Mar 2008 07:54:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: call _notrun in common.dump if dump utils not
 found
References: <47E5CFBA.7060405@sandeen.net> <47E8703C.30603@sgi.com> <op.t8jyw8i63jf8g2@pc-bnaujok.melbourne.sgi.com> <47E87D97.9050900@sandeen.net> <47E88676.7080006@sgi.com> <47E8960D.1000801@sgi.com>
In-Reply-To: <47E8960D.1000801@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Timothy Shimmin wrote:
>  > Eric Sandeen wrote:
>  >> Barry Naujok wrote:
>  >>> On Tue, 25 Mar 2008 14:23:40 +1100, Timothy Shimmin <tes@sgi.com> wrote:
>  >>>
>  >>>> Thanks, Eric.
>  >>>>
>  >>>> On IRIX:
>  >>>>  > where xfsdump xfsrestore xfsinvutil
>  >>>> /sbin/xfsdump
>  >>>> /usr/sbin/xfsdump
>  >>>> /sbin/xfsrestore
>  >>>> /usr/sbin/xfsinvutil
>  >>>>  > ls -l /sbin/xfsdump
>  >>>> lrwxr-xr-x    ... /sbin/xfsdump -> ../usr/sbin/xfsdump*
>  >>>>
>  >>>> I'll add the IRIX xfsrestore path and wait for Russell or
>  >>>> whoever to complain about BSD :)
>  >>> common.config sets up environment variables for the various
>  >>> tools used and can handle these paths. It has them for the
>  >>> xfsprogs tools (XFS_REPAIR_PROG, XFS_DB_PROG, etc) but
>  >>> nothing for the xfsdump tools.
>  >>
>  >> yeah, that may be better...
>  >>
>  > Okay. Fair point.
>  > I'll change common.dump to use the XFSDUMP_PROG etc....
>  > and common.config to set the PROG vars.
>  >
>  > --Tim
>  >
>  >
> 
> Okay, something like below then.
> Note, I only test for failure in common.dump and I need
> to filter out the fullpaths for the commands now as
> they output their full path.
> Oh and I changed a bit for the DEBUGDUMP which can
> use binaries in xfstests for debugging.
> Ughhh.

well, I don't want to make this too much work... it's not critical.

-eric
