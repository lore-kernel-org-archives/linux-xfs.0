Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96C5C7F37
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 08:54:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7EFD430405F
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 06:54:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FHtZfKEi2qoJDsxi for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 06:54:08 -0700 (PDT)
Message-ID: <51DC1600.7080906@sandeen.net>
Date: Tue, 09 Jul 2013 08:54:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: inode64 and Firefox
References: <EA658AFF-6AEC-41D1-BA40-4103BEF7FD5E@gmail.com>
In-Reply-To: <EA658AFF-6AEC-41D1-BA40-4103BEF7FD5E@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: aurfalien <aurfalien@gmail.com>
Cc: xfs@oss.sgi.com

On 7/9/13 8:37 AM, aurfalien wrote:
> Before I dig deeper, wondering if any one has issues running Firefox v22 from an XFS file system mounted using inode64 option?

I've not tried it, but first question - 32-bit or 64-bit firefox?

However, this isn't encouraging:

$ file /usr/lib64/firefox/firefox
/usr/lib64/firefox/firefox: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped

$ ./summarise_stat.pl /usr/lib64/firefox/firefox
      1 100.0% use 32-bit stat() family interfaces only

sooo if my perl script is to be believed, it may be problematic, depending on how serious a stat() failure is.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
