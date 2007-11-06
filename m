Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 10:01:33 -0800 (PST)
Received: from astoria.ccjclearline.com (astoria.ccjclearline.com [64.235.106.9])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6I1Mh0018327
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 10:01:26 -0800
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IpQNv-0007fs-6Z
	for xfs@oss.sgi.com; Tue, 06 Nov 2007 10:30:43 -0500
Date: Tue, 6 Nov 2007 10:28:44 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: use is_power_of_2() macro?
Message-ID: <Pine.LNX.4.64.0711061026210.9329@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


  given this in fs/xfs/xfs_inode.c:

/*
 * xfs_iroundup: round up argument to next power of two
 */
uint
xfs_iroundup(
        uint    v)
{
        int i;
        uint m;

        if ((v & (v - 1)) == 0)
                return v;
        ASSERT((v & 0x80000000) == 0);
        if ((v & (v + 1)) == 0)
                return v + 1;
        for (i = 0, m = 1; i < 31; i++, m <<= 1) {
                if (v & m)
                        continue;
                v |= m;
                if ((v & (v + 1)) == 0)
                        return v + 1;
        }
        ASSERT(0);
        return( 0 );
}

  is there any reason that can't be rewritten with simply
roundup_pow_of_two() as defined in include/linux/log2.h?

#define roundup_pow_of_two(n)                   \
(                                               \
        __builtin_constant_p(n) ? (             \
                (n == 1) ? 1 :                  \
                (1UL << (ilog2((n) - 1) + 1))   \
                                   ) :          \
        __roundup_pow_of_two(n)                 \
 )

  just curious.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
