Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEJOgd0225283 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 13:24:43 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F7B957D5BF
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 11:24:35 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id RMsFUDXXhdinpE9h for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 11:24:35 -0800 (PST)
Message-ID: <4EE8F7F0.7070207@suse.com>
Date: Wed, 14 Dec 2011 14:24:32 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: Re: xfs-trace-ilock-more
References: <20111214024040.GA17780@infradead.org>
	<20111214182750.GH11114@wotan.suse.de>
In-Reply-To: <20111214182750.GH11114@wotan.suse.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Fasheh <mfasheh@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/14/2011 01:27 PM, Mark Fasheh wrote:
> Hey Christoph,
> 
> On Tue, Dec 13, 2011 at 09:40:40PM -0500, Christoph Hellwig wrote:
>> Can you explain the story behid this patch in SLES11SP1?
> 
> We were looking at some performance issues and needed a bit more
> information on the amount of time spent in ilock. I can give you
> more specifics if you want, I just have to dig up the e-mails (it's
> been a while).

That's pretty much the explanation. With heavy reader load, buffered
writes were stalling for 80 ms and sometimes longer. I suspected it
was contention on the ilock and the tracing with that patch
demonstrated a delay there. Since we were chasing a similar issue at
another site, it seemed worthwhile to just keep it around. We're still
tracking down the cause. I'm not sure if more recent kernels have the
same issue as there's been quite a lot of churn.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO6PfwAAoJEB57S2MheeWyE+MQAIeh/VUfWExpjsgdBbkSj4jv
7sJQW2WweYpHHZdLnGx5Pn4cDO6/2YyqNXfwAGZk2yoXTcycykR7ZVHLGEyyNDLV
BrKUvcDG/5XYTx3B64yPge8rNY9YIiy2e/c+pbwPeSnDPMY9976igqbrC5qaJ31a
1a/REm/MpDkGV7NcS4XYjbZwl0bP6BBJib0fnCrvkmWo7mtuzwz1XMpORGLWltOg
EhRTTgh+HRc1zlqknz5+ceMghky+GTp56/3YPslbco61uI9XmKzLc/bi1iNgda24
gy6wAIRk0EwPd9o2Wl+Jvvm79YvTE2SvkjDzHz3exOAX3JTMVnF//7bjVfPg7A9f
xyHQ7GQJRWQwIXuGVqi7JciN5/5IKOdkrGILIIC1osFjr7z894xGgQejNhqxuXNE
B06WUJ2PLYEOCKLCnH75OwCsDRqdj7N+yPbxGJIZeAjdiH6r2tanAAtYAtqdn+3T
J7sdsm/Kvod4wgKBLJWk/rvTI/i1pjoqNaeF0rdXsQbqGI7C9OKeNfIjilt0HT8h
9EIaoy3KjnGmAU1pouHZro2hR1Ec8Ni09DM5GMQeGTIAPvgTgP8oHB/MPFIM9Jnl
QxfLJ5o3bxvB3u2aDJQta3+V/9TQPfELtokjjk34GjAcaxBZT7mTy8lVOHVL1Srg
86cHVs6PDRXQf7CeoX+N
=Cjlo
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
