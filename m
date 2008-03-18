Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 18:46:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2I1k0GO025059
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 18:46:04 -0700
Received: from opera.rednote.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B5A1FBE412
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 18:46:30 -0700 (PDT)
Received: from opera.rednote.net (opera.rednote.net [74.53.93.34]) by cuda.sgi.com with ESMTP id nRmPBTQFWtlBNVJV for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 18:46:30 -0700 (PDT)
Received: from jdc.jasonjgw.net ([IPv6:::1])
	by opera.rednote.net (8.14.1/8.14.1) with ESMTP id m2I1CLGt017826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 01:12:27 GMT
Received: from jdc.jasonjgw.net (ip6-localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.2/8.14.2/Debian-3) with ESMTP id m2I1CAew012751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 12:12:10 +1100
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.2/8.14.2/Submit) id m2I1CAE5012750
	for xfs@oss.sgi.com; Tue, 18 Mar 2008 12:12:10 +1100
Date: Tue, 18 Mar 2008 12:12:10 +1100
From: Jason White <jason@jasonjgw.net>
Subject: Re: XFS check script on boot?
Message-ID: <20080318011210.GA12727@jdc.jasonjgw.net>
References: <20080317134847.GJ14510@sv.lnf.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317134847.GJ14510@sv.lnf.it>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Mar 17, 2008 at 02:48:47PM +0100, Marco Gaiarin wrote:
 
> This was the first tile i hit a xfs filesystem corruption, so i'm
> asking why seems there's no /etc/init.d/checkfs.sh-like script that
> check and repair XFS filesystem at boot.

Because XFS is a journaling file system which can, and should, recover
automatically from an unclean shutdown such as a system crash or power
failure.

If you get XFS corruption after a reboot then you have a hardware or software
problem that shouldn't be happening and which ought to be investigated and
fixed.

The purpose of a journaling file system is to make time-consuming fsck and
similar checks unnecessary after a reboot.
