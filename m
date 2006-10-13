Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Oct 2006 12:46:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9DJkpaG024288
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 12:46:52 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C41FCD134CA8
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 12:46:08 -0700 (PDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k9DJk7LE021019
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 15:46:07 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k9DJk7Xi014804
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 15:46:07 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k9DJk7Zr016376
	for <xfs@oss.sgi.com>; Fri, 13 Oct 2006 15:46:07 -0400
Message-ID: <452FECFE.5050902@sandeen.net>
Date: Fri, 13 Oct 2006 14:46:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: corrupted log causes infinite loop at mount
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

While playing with some filesystem corruption testers, I ran into this.

http://sandeen.net/xfs.31.img.bz2

If you try to mount, it gets into xfs_buf_get_noaddr via log replay with
a len of 0, and I think this causes an infinite loop in the goto:

 try_again:
        data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL);
        if (unlikely(data == NULL))
                goto fail_free_buf;

        /* check whether alignment matches.. */
        if ((__psunsigned_t)data !=
            ((__psunsigned_t)data & ~target->bt_smask)) {
                /* .. else double the size and try again */
                kmem_free(data, malloc_len);
                malloc_len <<= 1;
                goto try_again;
        }

Up the callchain a bit there is an ASSERT that the size is > 0, but of
course that doesn't help on a non-debug kernel...

haven't had time to investigate beyond that.

-Eric
