Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78A427F37
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 07:16:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06DFFAC002
	for <xfs@oss.sgi.com>; Thu,  7 May 2015 05:15:59 -0700 (PDT)
Received: from mail-pa0-f54.google.com (mail-pa0-f54.google.com
	[209.85.220.54]) by cuda.sgi.com with ESMTP id 1Bwn1aDXbstGFRn9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 May 2015 05:15:58 -0700 (PDT)
Received: by pacyx8 with SMTP id yx8so38766662pac.1
	for <xfs@oss.sgi.com>; Thu, 07 May 2015 05:15:57 -0700 (PDT)
Message-ID: <554B5782.4040303@xtremenitro.org>
Date: Thu, 07 May 2015 19:16:02 +0700
From: Dewangga <dewanggaba@xtremenitro.org>
MIME-Version: 1.0
Subject: Re: Valid Benchmark Value & Methods
References: <554B4B59.6000706@xtremenitro.org> <2204700.QypQcg3ER3@merkaba>
In-Reply-To: <2204700.QypQcg3ER3@merkaba>
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
To: Martin Steigerwald <martin@lichtvoll.de>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello Martin,
Thanks for your reply, yes I've read that link, but another question,
is noatime,nodiratime,etc still valid for performance tuning guidance?
Even the default mount options only "rw,inode64,seclabel,attr2".

Is it still increase the performance if the additional mount options
added?

On 5/7/2015 18:49, Martin Steigerwald wrote:
> Am Donnerstag, 7. Mai 2015, 18:24:09 schrieb Dewangga:
>> Hello!
>> 
>> I'm new on XFS and curious about any tune/tweak regarding XFS 
>> filesystem on any raid array, non-raid, ssd or non-ssd. But, is
>> there any valid value to determine about the performance? At
>> least valid benchmark result (eg. using fio with some parameters,
>> or any method).
>> 
>> Then, about bsize, sectsz, etc, is there any wiki/guidelines how
>> to set them on a right way?
> 
> Ok, one additional thing:
> 
> Use recent kernel and userspace utilities.
> 
> Cause defaults are updated sometimes and with recent tools you get
> best out of box experience.
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJVS1eBAAoJEF1+odKB6YIxyQwH/Am1bC+YhydmoWOknAMgjrEI
3mTmeUu0O/p90+DsXPS04zjht18XzsZKVTASVraPgPcrgzoqlHtHflK55++YIKp2
SLbFI2IexNLNbffyUgM7NCCpEjKZLkN8v4eNP2ylSgQqK4DTzwWPDypF16FX/rlc
2WuvQINR345i8rwjPryMbZAHiCem3ewYssx34jfH5NPh9CoRo1mnuFCEHzz9IG3L
4u0Z7zTKHZQPDaRzC3MVO5wOZNelnWXcP2TwiDJF3LgdEzWTinQGthEKy5ytSPPI
xRZvJnzUvXWt6JNuWCUjtIUV3ODhBctfkk200wvMUyBdQg7Zo+OiXXOyaA24GsU=
=wHBL
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
