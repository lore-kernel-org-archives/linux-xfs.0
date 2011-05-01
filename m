Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41J1VtF188753
	for <linux-xfs@oss.sgi.com>; Sun, 1 May 2011 14:01:31 -0500
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7DC3424C0C
	for <linux-xfs@oss.sgi.com>; Sun,  1 May 2011 12:05:06 -0700 (PDT)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id OlPZW5QrMFk7LpLn for <linux-xfs@oss.sgi.com>;
	Sun, 01 May 2011 12:05:06 -0700 (PDT)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1QGbx3-0006CG-B9
	for linux-xfs@oss.sgi.com; Sun, 01 May 2011 21:05:05 +0200
Received: from 121.79-160-103.customer.lyse.net ([79.160.103.121])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sun, 01 May 2011 21:05:05 +0200
Received: from david.brown by 121.79-160-103.customer.lyse.net with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Sun, 01 May 2011 21:05:05 +0200
From: David Brown <david.brown@hesbynett.no>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Sun, 01 May 2011 20:32:22 +0200
Message-ID: <ipk8vn$s9a$1@dough.gmane.org>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>	<20110501082717.5116e575@notabene.brown>
	<19901.31958.368144.832086@tree.ty.sabi.co.UK>
Mime-Version: 1.0
In-Reply-To: <19901.31958.368144.832086@tree.ty.sabi.co.UK>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org

On 01/05/11 17:31, Peter Grandi wrote:
> [ ... ]
>
>>> * Can Linux MD do "abbreviated" read-modify-write RAID6
>>> updates like for RAID5? [ ... ]
>
>> No. (patches welcome).
>
> Ahhhm, but let me dig a bit deeper, even if it may be implied in
> the answer: would it be *possible*?
>
> That is, is the double parity scheme used in MS such that it is
> possible to "subtract" the old content of a page and "add" the
> new content of that page to both parity pages?
>

If I've understood the maths correctly, then yes it would be possible. =

But it would involve more calculations, and it is difficult to see where =

the best balance lies between cpu demands and IO demands.  In general, =

calculating the Q parity block for raid6 is processor-intensive - =

there's a fair amount of optimisation done in the normal calculations to =

keep it reasonable.

Basically, the first parity P is a simple calculation:

P =3D D_0 + D_1 + .. + D_n-1

But Q is more difficult:

Q =3D D_0 + g.D_1 + g=B2.D_2 + ... + g^(n-1).D_n-1

where "plus" is xor, "times" is a weird function calculated over a =

G(2^8) field, and g is a generator for that field.

If you want to replace D_i, then you can calculate:

P(new) =3D P(old) + D_i(old) + D_i(new)

Q(new) =3D Q(old) + g^i.(D_i(old) + D_i(new))

This means multiplying by g_i for whichever block i is being replaced.

The generator and multiply operation are picked to make it relatively =

fast and easy to multiply by g, especially if you've got a processor =

that has vector operations (as most powerful cpus do).  This means that =

the original Q calculation is fairly efficient.  But to do general =

multiplications by g_i is more effort, and will typically involve =

cache-killing lookup tables or multiple steps.


It is probably reasonable to say that when md raid first implemented =

raid6, it made little sense to do these abbreviated parity calculations. =

  But as processors have got faster (and wider, with more cores) while =

disk throughput has made slower progress, it's maybe a different =

balance.  So it's probably both possible and practical to do these =

calculations.  All it needs is someone to spend the time writing the =

code - and lots of people willing to test it.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
