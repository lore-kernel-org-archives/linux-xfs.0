Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Jul 2008 23:57:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6S6vrHJ003300
	for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 23:57:54 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA16194 for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 16:59:05 +1000
Date: Mon, 28 Jul 2008 17:00:48 +1000
Subject: xfs_lowbit32 implementation
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uezprmvd3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

More of this libxfs port of the kernel (who cleaned up xfs_bit.*!)...

Anyway...

/* Get low bit set out of 32-bit argument, -1 if none set */
static inline int xfs_lowbit32(__uint32_t v)
{
	unsigned long	t = v;
	return (v) ? find_first_bit(&t, 32) : -1;
}


Couldn't that be:


/* Get low bit set out of 32-bit argument, -1 if none set */
static inline int xfs_lowbit32(__uint32_t v)
{
	return ffs(v) - 1;
}
